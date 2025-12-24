import 'package:photo_buddy/data/repo/faceRepo.dart';
import 'package:photo_buddy/data/services/ClusteringService.dart';

import '../../data/isar_classes/faceEmbedding.dart';
import '../../data/isar_classes/person.dart';

class PersonAggregationService {
  final FaceEmbeddingRepo faceEmbeddingRepo;
  final ClusteringService clusteringService;
  
  PersonAggregationService({
    required this.faceEmbeddingRepo,
    required this.clusteringService,
  });
  
  /// Aggregates clustered faces into person entities
  Future<List<Person>> aggregatePersons(Map<int, int> clusterLabels) async {
    final persons = <Person>[];
    final clusterMap = <int, List<FaceEmbedding>>{};
    
    // Group faces by cluster ID
    for (final entry in clusterLabels.entries) {
      final clusterId = entry.value;
      
      // Skip noise points
      if (clusterId == -1) continue;
      
      clusterMap.putIfAbsent(clusterId, () => []);
    }
    
    // Fetch all clustered faces
    for (final clusterId in clusterMap.keys) {
      final clusterFaces = await faceEmbeddingRepo.getFacesByCluster(clusterId);
      clusterMap[clusterId] = clusterFaces;
    }
    
    // Create person for each cluster
    for (final entry in clusterMap.entries) {
      final clusterId = entry.key;
      final faces = entry.value;
      
      if (faces.isEmpty) continue;
      
      // Calculate centroid
      final centroid = clusteringService.calculateCentroid(faces);
      
      // Find representative face (first one for now, can be improved)
      final representativeFace = _findRepresentativeFace(faces, centroid);
      
      final person = Person.create(
        clusterId: clusterId,
        faceCount: faces.length,
        centroidEmbedding: centroid,
        representativeMediaPath: representativeFace?.filePath,
      );
      
      persons.add(person);
    }
    
    return persons;
  }
  
  /// Updates existing persons with new cluster information
  Future<void> updatePersons(Map<int, int> clusterLabels) async {
    final newPersons = await aggregatePersons(clusterLabels);
    
    for (final newPerson in newPersons) {
      final existingPerson = await faceEmbeddingRepo.getPersonByCluster(newPerson.clusterId);
      
      if (existingPerson != null) {
        // Update existing person
        existingPerson.faceCount = newPerson.faceCount;
        existingPerson.centroidEmbedding = newPerson.centroidEmbedding;
        existingPerson.representativeMediaPath = newPerson.representativeMediaPath;
        existingPerson.updatedAt = DateTime.now();
        
        await faceEmbeddingRepo.savePerson(existingPerson);
      } else {
        // Create new person
        await faceEmbeddingRepo.savePerson(newPerson);
      }
    }
  }
  
  /// Finds the most representative face in a cluster (closest to centroid)
  FaceEmbedding? _findRepresentativeFace(
    List<FaceEmbedding> faces,
    List<double> centroid,
  ) {
    if (faces.isEmpty) return null;
    
    FaceEmbedding? bestFace;
    double minDistance = double.infinity;
    
    for (final face in faces) {
      final distance = _cosineDistance(face.embedding, centroid);
      
      if (distance < minDistance) {
        minDistance = distance;
        bestFace = face;
      }
    }
    
    return bestFace;
  }
  
  double _cosineDistance(List<double> embedding1, List<double> embedding2) {
    double dotProduct = 0.0;
    for (int i = 0; i < embedding1.length; i++) {
      dotProduct += embedding1[i] * embedding2[i];
    }
    return 1.0 - dotProduct;
  }
  
  /// Complete clustering and aggregation pipeline
  Future<ClusteringResult> clusterAndAggregate({
    double eps = ClusteringService.DEFAULT_EPS,
    int minSamples = ClusteringService.DEFAULT_MIN_SAMPLES,
  }) async {
    // Get all face embeddings
    final allFaces = await faceEmbeddingRepo.getAllFaceEmbeddings();
    
    if (allFaces.isEmpty) {
      return ClusteringResult(
        clusterLabels: {},
        persons: [],
        stats: ClusterStats(
          totalClusters: 0,
          clusterCounts: {},
          noisePoints: 0,
          totalPoints: 0,
        ),
      );
    }
    
    // Perform clustering
    final clusterLabels = clusteringService.dbscan(
      faceEmbeddings: allFaces,
      eps: eps,
      minSamples: minSamples,
    );
    
    // Update face cluster assignments in database
    await faceEmbeddingRepo.updateFaceClusters(clusterLabels);
    
    // Create/update persons
    final persons = await aggregatePersons(clusterLabels);
    await faceEmbeddingRepo.savePersons(persons);
    
    // Get statistics
    final stats = clusteringService.getClusterStats(clusterLabels);
    
    return ClusteringResult(
      clusterLabels: clusterLabels,
      persons: persons,
      stats: stats,
    );
  }
}

class ClusteringResult {
  final Map<int, int> clusterLabels;
  final List<Person> persons;
  final ClusterStats stats;
  
  ClusteringResult({
    required this.clusterLabels,
    required this.persons,
    required this.stats,
  });
}