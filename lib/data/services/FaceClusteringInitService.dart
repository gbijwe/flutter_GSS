import 'dart:io';
import 'package:isar_community/isar.dart';
import 'package:photo_buddy/data/isar_classes/faceEmbedding.dart';
import 'package:photo_buddy/data/isar_classes/mediaItem.dart';
import 'package:photo_buddy/data/repo/faceRepo.dart';
import 'package:photo_buddy/data/repo/mediaRepo.dart';
import 'package:photo_buddy/data/services/ClusteringService.dart';
import 'package:photo_buddy/data/services/FaceEmbeddingService.dart';
import 'package:photo_buddy/data/services/IncrementalClusteringService.dart';
import 'package:photo_buddy/data/services/PersonAggregationService.dart';
import 'package:photo_buddy/helpers/FileTypeChecker.dart';

class FaceClusteringInitService {
  final Isar isar;
  final MediaRepository mediaRepo;
  final FaceEmbeddingRepo faceEmbeddingRepo;
  final FaceEmbeddingService faceEmbeddingService;
  final ClusteringService clusteringService;
  final PersonAggregationService personAggregationService;
  final IncrementalClusteringService incrementalClusteringService;
  
  FaceClusteringInitService({
    required this.isar,
    required this.mediaRepo,
    required this.faceEmbeddingRepo,
    required this.faceEmbeddingService,
    required this.clusteringService,
    required this.personAggregationService,
    required this.incrementalClusteringService,
  });
  
  /// Initialize face clustering for all media items
  Future<FaceClusteringInitResult> initializeFaceClustering({
    Function(int current, int total, String? currentFile)? onProgress,
    bool forceRecluster = false,
  }) async {
    final startTime = DateTime.now();
    
    // Check if already clustered
    final existingFaceCount = await faceEmbeddingRepo.getTotalFaceCount();
    if (existingFaceCount > 0 && !forceRecluster) {
      return FaceClusteringInitResult(
        totalProcessed: existingFaceCount,
        newEmbeddings: 0,
        clustersCreated: (await faceEmbeddingRepo.getAllPersons()).length,
        duration: Duration.zero,
        skipped: true,
      );
    }
    
    // Get all media items (photos only, skip videos)
    final allMedia = await mediaRepo.getAllMedia();
    final photoMedia = allMedia.where((m) => 
      m.type == FileType.image
    ).toList();
    
    if (photoMedia.isEmpty) {
      return FaceClusteringInitResult(
        totalProcessed: 0,
        newEmbeddings: 0,
        clustersCreated: 0,
        duration: Duration.zero,
        skipped: false,
      );
    }
    
    int processedCount = 0;
    int successCount = 0;
    final newEmbeddings = <FaceEmbedding>[];
    
    // Process in batches to avoid memory issues
    const batchSize = 50;
    
    for (int i = 0; i < photoMedia.length; i += batchSize) {
      final batch = photoMedia.skip(i).take(batchSize).toList();
      
      for (final media in batch) {
        processedCount++;
        onProgress?.call(processedCount, photoMedia.length, media.path);
        
        try {
          // Check if embedding already exists
          final existing = await faceEmbeddingRepo.getFaceByMediaPath(media.path);
          if (existing != null && !forceRecluster) {
            successCount++;
            continue;
          }
          
          // Extract embedding
          final file = File(media.path);
          if (!await file.exists()) continue;
          
          final embedding = await faceEmbeddingService.extractEmbeddingFromFile(file);
          
          final faceEmbedding = FaceEmbedding.create(
            filePath: media.path,
            embedding: embedding,
          );
          
          newEmbeddings.add(faceEmbedding);
          successCount++;
          
        } catch (e) {
          print('Failed to process ${media.path}: $e');
        }
      }
      
      // Save batch to database
      if (newEmbeddings.isNotEmpty) {
        await faceEmbeddingRepo.saveFaceEmbeddings(newEmbeddings);
        newEmbeddings.clear();
      }
    }
    
    // Perform clustering on all faces
    onProgress?.call(photoMedia.length, photoMedia.length, 'Clustering faces...');
    final clusteringResult = await personAggregationService.clusterAndAggregate();
    
    final duration = DateTime.now().difference(startTime);
    
    return FaceClusteringInitResult(
      totalProcessed: processedCount,
      newEmbeddings: successCount,
      clustersCreated: clusteringResult.persons.length,
      duration: duration,
      skipped: false,
      stats: clusteringResult.stats,
    );
  }
  
  /// Process new media items incrementally
  Future<FaceClusteringInitResult> processNewMedia(
    List<MediaItem> newMediaItems, {
    Function(int current, int total, String? currentFile)? onProgress,
  }) async {
    final startTime = DateTime.now();
    
    final photoMedia = newMediaItems.where((m) => 
      m.type == FileType.image
    ).toList();
    
    if (photoMedia.isEmpty) {
      return FaceClusteringInitResult(
        totalProcessed: 0,
        newEmbeddings: 0,
        clustersCreated: 0,
        duration: Duration.zero,
        skipped: false,
      );
    }
    
    int processedCount = 0;
    final newEmbeddings = <FaceEmbedding>[];
    
    for (final media in photoMedia) {
      processedCount++;
      onProgress?.call(processedCount, photoMedia.length, media.path);
      
      try {
        // Check if already processed
        final existing = await faceEmbeddingRepo.getFaceByMediaPath(media.path);
        if (existing != null) continue;
        
        final file = File(media.path);
        if (!await file.exists()) continue;
        
        final embedding = await faceEmbeddingService.extractEmbeddingFromFile(file);
        
        final faceEmbedding = FaceEmbedding.create(
          filePath: media.path,
          embedding: embedding,
        );
        
        newEmbeddings.add(faceEmbedding);
        
      } catch (e) {
        print('Failed to process ${media.path}: $e');
      }
    }
    
    if (newEmbeddings.isEmpty) {
      return FaceClusteringInitResult(
        totalProcessed: processedCount,
        newEmbeddings: 0,
        clustersCreated: 0,
        duration: DateTime.now().difference(startTime),
        skipped: false,
      );
    }
    
    // Incremental clustering
    onProgress?.call(photoMedia.length, photoMedia.length, 'Matching faces...');
    final incrementalResult = await incrementalClusteringService.matchNewFaces(newEmbeddings);
    
    final duration = DateTime.now().difference(startTime);
    
    return FaceClusteringInitResult(
      totalProcessed: processedCount,
      newEmbeddings: newEmbeddings.length,
      clustersCreated: incrementalResult.newClusters,
      duration: duration,
      skipped: false,
      incrementalResult: incrementalResult,
    );
  }
  
  /// Rescan and recluster all faces
  Future<FaceClusteringInitResult> rescanAndRecluster({
    Function(int current, int total, String? currentFile)? onProgress,
  }) async {
    // Clear existing face data
    await faceEmbeddingRepo.clearAllClusters();
    await isar.writeTxn(() async {
      await isar.faceEmbeddings.clear();
    });
    
    // Reinitialize
    return await initializeFaceClustering(
      onProgress: onProgress,
      forceRecluster: true,
    );
  }
}

class FaceClusteringInitResult {
  final int totalProcessed;
  final int newEmbeddings;
  final int clustersCreated;
  final Duration duration;
  final bool skipped;
  final ClusterStats? stats;
  final IncrementalUpdateResult? incrementalResult;
  
  FaceClusteringInitResult({
    required this.totalProcessed,
    required this.newEmbeddings,
    required this.clustersCreated,
    required this.duration,
    required this.skipped,
    this.stats,
    this.incrementalResult,
  });
  
  @override
  String toString() {
    if (skipped) {
      return 'Face clustering skipped (already initialized)';
    }
    
    return '''
Face Clustering Complete:
- Processed: $totalProcessed images
- New embeddings: $newEmbeddings
- Clusters created: $clustersCreated
- Duration: ${duration.inSeconds}s
${stats != null ? '- Stats: $stats' : ''}
${incrementalResult != null ? '- Incremental: $incrementalResult' : ''}
''';
  }
}