import 'dart:math' as math;
import 'package:photo_buddy/data/isar_classes/faceEmbedding.dart';
import 'package:photo_buddy/data/isar_classes/person.dart';
import 'package:photo_buddy/data/repo/faceRepo.dart';
import 'package:photo_buddy/data/services/ClusteringService.dart';
import 'package:photo_buddy/data/services/PersonAggregationService.dart';


class IncrementalClusteringService {
  final FaceEmbeddingRepo faceEmbeddingRepo;
  final ClusteringService clusteringService;
  final PersonAggregationService personAggregationService;
  
  static const double MATCH_THRESHOLD = 0.6; // Cosine distance threshold for matching
  
  IncrementalClusteringService({
    required this.faceEmbeddingRepo,
    required this.clusteringService,
    required this.personAggregationService,
  });
  
  /// Matches new face embeddings against existing clusters
  Future<IncrementalUpdateResult> matchNewFaces(
    List<FaceEmbedding> newFaces, {
    double matchThreshold = MATCH_THRESHOLD,
  }) async {
    if (newFaces.isEmpty) {
      return IncrementalUpdateResult(
        matched: 0,
        newClusters: 0,
        unmatched: 0,
      );
    }
    
    // Get all existing persons
    final existingPersons = await faceEmbeddingRepo.getAllPersons();
    
    if (existingPersons.isEmpty) {
      // No existing clusters, perform full clustering
      await _performFullClustering(newFaces);
      return IncrementalUpdateResult(
        matched: 0,
        newClusters: existingPersons.length,
        unmatched: 0,
      );
    }
    
    int matchedCount = 0;
    int unmatchedCount = 0;
    final unmatchedFaces = <FaceEmbedding>[];
    
    // Try to match each new face to existing persons
    for (final newFace in newFaces) {
      final matchedPerson = await _findBestMatch(
        newFace,
        existingPersons,
        matchThreshold,
      );
      
      if (matchedPerson != null) {
        // Assign to existing cluster
        newFace.clusterId = matchedPerson.clusterId;
        newFace.personId = matchedPerson.id.toString();
        await faceEmbeddingRepo.saveFaceEmbedding(newFace);
        
        // Update person centroid and face count
        await _updatePersonCentroid(matchedPerson);
        matchedCount++;
      } else {
        // No match found
        unmatchedFaces.add(newFace);
        unmatchedCount++;
      }
    }
    
    // Cluster unmatched faces together
    int newClustersCount = 0;
    if (unmatchedFaces.isNotEmpty) {
      newClustersCount = await _clusterUnmatchedFaces(unmatchedFaces);
    }
    
    return IncrementalUpdateResult(
      matched: matchedCount,
      newClusters: newClustersCount,
      unmatched: unmatchedFaces.where((f) => f.clusterId == -1).length,
    );
  }
  
  /// Finds the best matching person for a face embedding
  Future<Person?> _findBestMatch(
    FaceEmbedding face,
    List<Person> persons,
    double threshold,
  ) async {
    Person? bestMatch;
    double minDistance = double.infinity;
    
    for (final person in persons) {
      final distance = _cosineDistance(
        face.embedding,
        person.centroidEmbedding,
      );
      
      if (distance < threshold && distance < minDistance) {
        minDistance = distance;
        bestMatch = person;
      }
    }
    
    return bestMatch;
  }
  
  /// Updates person centroid after adding new faces
  Future<void> _updatePersonCentroid(Person person) async {
    final clusterFaces = await faceEmbeddingRepo.getFacesByCluster(person.clusterId);
    
    if (clusterFaces.isEmpty) return;
    
    // Recalculate centroid
    final newCentroid = clusteringService.calculateCentroid(clusterFaces);
    
    // Update person
    person.centroidEmbedding = newCentroid;
    person.faceCount = clusterFaces.length;
    person.updatedAt = DateTime.now();
    
    await faceEmbeddingRepo.savePerson(person);
  }
  
  /// Clusters unmatched faces and creates new persons
  Future<int> _clusterUnmatchedFaces(List<FaceEmbedding> unmatchedFaces) async {
    if (unmatchedFaces.length < 2) {
      // Mark as noise if only one face
      for (final face in unmatchedFaces) {
        face.clusterId = -1;
        await faceEmbeddingRepo.saveFaceEmbedding(face);
      }
      return 0;
    }
    
    // Get next cluster ID
    final existingPersons = await faceEmbeddingRepo.getAllPersons();
    int nextClusterId = existingPersons.isEmpty 
        ? 0 
        : existingPersons.map((p) => p.clusterId).reduce(math.max) + 1;
    
    // Perform DBSCAN on unmatched faces
    final labels = clusteringService.dbscan(
      faceEmbeddings: unmatchedFaces,
      eps: ClusteringService.DEFAULT_EPS,
      minSamples: ClusteringService.DEFAULT_MIN_SAMPLES,
    );
    
    // Adjust cluster IDs to avoid conflicts
    final adjustedLabels = <int, int>{};
    final clusterIdMap = <int, int>{};
    
    for (final entry in labels.entries) {
      final faceId = entry.key;
      final clusterId = entry.value;
      
      if (clusterId == -1) {
        adjustedLabels[faceId] = -1;
      } else {
        if (!clusterIdMap.containsKey(clusterId)) {
          clusterIdMap[clusterId] = nextClusterId++;
        }
        adjustedLabels[faceId] = clusterIdMap[clusterId]!;
      }
    }
    
    // Update face cluster assignments
    await faceEmbeddingRepo.updateFaceClusters(adjustedLabels);
    
    // Create new persons for new clusters
    final newPersons = await personAggregationService.aggregatePersons(adjustedLabels);
    await faceEmbeddingRepo.savePersons(newPersons);
    
    return clusterIdMap.length;
  }
  
  /// Performs full clustering when no existing clusters exist
  Future<void> _performFullClustering(List<FaceEmbedding> faces) async {
    await faceEmbeddingRepo.saveFaceEmbeddings(faces);
    await personAggregationService.clusterAndAggregate();
  }
  
  double _cosineDistance(List<double> embedding1, List<double> embedding2) {
    double dotProduct = 0.0;
    for (int i = 0; i < embedding1.length; i++) {
      dotProduct += embedding1[i] * embedding2[i];
    }
    return 1.0 - dotProduct;
  }
  
  /// Re-clusters all faces from scratch (useful for tuning parameters)
  Future<ClusteringResult> reclusterAll({
    double eps = ClusteringService.DEFAULT_EPS,
    int minSamples = ClusteringService.DEFAULT_MIN_SAMPLES,
  }) async {
    // Clear existing clusters
    await faceEmbeddingRepo.clearAllClusters();
    
    // Perform fresh clustering
    return await personAggregationService.clusterAndAggregate(
      eps: eps,
      minSamples: minSamples,
    );
  }
}

class IncrementalUpdateResult {
  final int matched;
  final int newClusters;
  final int unmatched;
  
  IncrementalUpdateResult({
    required this.matched,
    required this.newClusters,
    required this.unmatched,
  });
  
  @override
  String toString() {
    return 'IncrementalUpdateResult(matched: $matched, newClusters: $newClusters, unmatched: $unmatched)';
  }
}