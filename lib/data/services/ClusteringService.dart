import 'dart:math' as math;

import 'package:photo_buddy/data/isar_classes/faceEmbedding.dart';

class ClusteringService {
  static const double DEFAULT_EPS = 0.5; // Cosine distance threshold
  static const int DEFAULT_MIN_SAMPLES = 2; // Minimum faces per cluster
  
  /// Performs DBSCAN clustering on face embeddings
  /// Returns a map of faceEmbedding.id -> clusterId (-1 for noise)
  Map<int, int> dbscan({
    required List<FaceEmbedding> faceEmbeddings,
    double eps = DEFAULT_EPS,
    int minSamples = DEFAULT_MIN_SAMPLES,
  }) {
    if (faceEmbeddings.isEmpty) return {};
    
    final labels = <int, int>{};
    int clusterId = 0;
    
    // Initialize all as unvisited (-2)
    for (final face in faceEmbeddings) {
      labels[face.id] = -2;
    }
    
    for (int i = 0; i < faceEmbeddings.length; i++) {
      final faceId = faceEmbeddings[i].id;
      
      // Skip if already processed
      if (labels[faceId]! != -2) continue;
      
      // Find neighbors
      final neighbors = _findNeighbors(
        faceEmbeddings,
        i,
        eps,
      );
      
      // Mark as noise if not enough neighbors
      if (neighbors.length < minSamples) {
        labels[faceId] = -1;
        continue;
      }
      
      // Start new cluster
      _expandCluster(
        faceEmbeddings,
        i,
        neighbors,
        clusterId,
        eps,
        minSamples,
        labels,
      );
      
      clusterId++;
    }
    
    return labels;
  }
  
  void _expandCluster(
    List<FaceEmbedding> faceEmbeddings,
    int index,
    List<int> neighbors,
    int clusterId,
    double eps,
    int minSamples,
    Map<int, int> labels,
  ) {
    final faceId = faceEmbeddings[index].id;
    labels[faceId] = clusterId;
    
    final seeds = List<int>.from(neighbors);
    int seedIndex = 0;
    
    while (seedIndex < seeds.length) {
      final currentIdx = seeds[seedIndex];
      final currentFaceId = faceEmbeddings[currentIdx].id;
      
      // Change noise to border point
      if (labels[currentFaceId] == -1) {
        labels[currentFaceId] = clusterId;
      }
      
      // Skip if already processed
      if (labels[currentFaceId]! != -2) {
        seedIndex++;
        continue;
      }
      
      labels[currentFaceId] = clusterId;
      
      // Find neighbors of current point
      final currentNeighbors = _findNeighbors(
        faceEmbeddings,
        currentIdx,
        eps,
      );
      
      // Add new neighbors to seeds if density requirement met
      if (currentNeighbors.length >= minSamples) {
        for (final neighborIdx in currentNeighbors) {
          if (!seeds.contains(neighborIdx)) {
            seeds.add(neighborIdx);
          }
        }
      }
      
      seedIndex++;
    }
  }
  
  List<int> _findNeighbors(
    List<FaceEmbedding> faceEmbeddings,
    int index,
    double eps,
  ) {
    final neighbors = <int>[];
    final targetEmbedding = faceEmbeddings[index].embedding;
    
    for (int i = 0; i < faceEmbeddings.length; i++) {
      if (i == index) continue;
      
      final distance = _cosineDistance(
        targetEmbedding,
        faceEmbeddings[i].embedding,
      );
      
      if (distance <= eps) {
        neighbors.add(i);
      }
    }
    
    return neighbors;
  }
  
  double _cosineDistance(List<double> embedding1, List<double> embedding2) {
    double dotProduct = 0.0;
    for (int i = 0; i < embedding1.length; i++) {
      dotProduct += embedding1[i] * embedding2[i];
    }
    
    // Embeddings are already normalized, so dot product = cosine similarity
    return 1.0 - dotProduct;
  }
  
  /// Get cluster statistics
  ClusterStats getClusterStats(Map<int, int> labels) {
    final clusterCounts = <int, int>{};
    int noiseCount = 0;
    
    for (final clusterId in labels.values) {
      if (clusterId == -1) {
        noiseCount++;
      } else {
        clusterCounts[clusterId] = (clusterCounts[clusterId] ?? 0) + 1;
      }
    }
    
    return ClusterStats(
      totalClusters: clusterCounts.length,
      clusterCounts: clusterCounts,
      noisePoints: noiseCount,
      totalPoints: labels.length,
    );
  }
  
  /// Calculate centroid embedding for a cluster
  List<double> calculateCentroid(List<FaceEmbedding> clusterFaces) {
    if (clusterFaces.isEmpty) return [];
    
    final embeddingSize = clusterFaces.first.embedding.length;
    final centroid = List<double>.filled(embeddingSize, 0.0);
    
    // Sum all embeddings
    for (final face in clusterFaces) {
      for (int i = 0; i < embeddingSize; i++) {
        centroid[i] += face.embedding[i];
      }
    }
    
    // Average
    for (int i = 0; i < embeddingSize; i++) {
      centroid[i] /= clusterFaces.length;
    }
    
    // Normalize
    return _normalizeEmbedding(centroid);
  }
  
  List<double> _normalizeEmbedding(List<double> embedding) {
    double sumSquares = 0.0;
    for (final value in embedding) {
      sumSquares += value * value;
    }
    
    final magnitude = sumSquares > 0 ? 1.0 / math.sqrt(sumSquares) : 0.0;
    return embedding.map((value) => value * magnitude).toList();
  }
}

class ClusterStats {
  final int totalClusters;
  final Map<int, int> clusterCounts;
  final int noisePoints;
  final int totalPoints;
  
  ClusterStats({
    required this.totalClusters,
    required this.clusterCounts,
    required this.noisePoints,
    required this.totalPoints,
  });
  
  @override
  String toString() {
    return 'ClusterStats(clusters: $totalClusters, noise: $noisePoints, total: $totalPoints)';
  }
}