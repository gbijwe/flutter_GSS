import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';
import 'package:photo_buddy/data/isar_classes/mediaItem.dart';
import 'package:photo_buddy/data/repo/faceRepo.dart';
import 'package:photo_buddy/data/repo/mediaRepo.dart';
import 'package:photo_buddy/data/services/ClusteringService.dart';
import 'package:photo_buddy/data/services/FaceClusteringInitService.dart';
import 'package:photo_buddy/data/services/FaceEmbeddingService.dart';
import 'package:photo_buddy/data/services/IncrementalClusteringService.dart';
import 'package:photo_buddy/data/services/PersonAggregationService.dart';

class FaceClusteringProvider extends ChangeNotifier {
  final Isar isar;

  late final FaceClusteringInitService _initService;
  late final FaceEmbeddingService _faceEmbeddingService;

  bool _isInitialized = false;
  bool _isProcessing = false;
  double _progress = 0.0;
  String? _currentFile;
  FaceClusteringInitResult? _lastResult;

  bool get isInitialized => _isInitialized;
  bool get isProcessing => _isProcessing;
  double get progress => _progress;
  String? get currentFile => _currentFile;
  FaceClusteringInitResult? get lastResult => _lastResult;

  FaceClusteringProvider({required this.isar}) {
    _initializeServices();
  }

  void _initializeServices() {
    _faceEmbeddingService = FaceEmbeddingService();

    final mediaRepo = MediaRepository();
    final faceRepo = FaceEmbeddingRepo(isar);
    final clusteringService = ClusteringService();
    final personAggregationService = PersonAggregationService(
      faceEmbeddingRepo: faceRepo,
      clusteringService: clusteringService,
    );
    final incrementalClusteringService = IncrementalClusteringService(
      faceEmbeddingRepo: faceRepo,
      clusteringService: clusteringService,
      personAggregationService: personAggregationService,
    );

    _initService = FaceClusteringInitService(
      isar: isar,
      mediaRepo: mediaRepo,
      faceEmbeddingRepo: faceRepo,
      faceEmbeddingService: _faceEmbeddingService,
      clusteringService: clusteringService,
      personAggregationService: personAggregationService,
      incrementalClusteringService: incrementalClusteringService,
    );
  }

  /// Initialize face clustering (call after initial media scan)
  Future<void> initialize({bool force = false}) async {
    if (_isProcessing) return;

    _isProcessing = true;
    _progress = 0.0;
    _currentFile = null;
    notifyListeners();

    try {
      // Initialize ML model
      await _faceEmbeddingService.initialize();

      // Process all media
      _lastResult = await _initService.initializeFaceClustering(
        forceRecluster: force,
        onProgress: (current, total, file) {
          _progress = current / total;
          _currentFile = file;
          notifyListeners();
        },
      );

      _isInitialized = true;
      print(_lastResult.toString());
    } catch (e) {
      print('Face clustering initialization failed: $e');
    } finally {
      _isProcessing = false;
      _progress = 0.0;
      _currentFile = null;
      notifyListeners();
    }
  }

  /// Process new media items incrementally
  Future<void> processNewMedia(List<MediaItem> newItems) async {
    if (_isProcessing || !_isInitialized) return;

    _isProcessing = true;
    _progress = 0.0;
    notifyListeners();

    try {
      _lastResult = await _initService.processNewMedia(
        newItems,
        onProgress: (current, total, file) {
          _progress = current / total;
          _currentFile = file;
          notifyListeners();
        },
      );

      print(_lastResult.toString());
    } catch (e) {
      print('Processing new media failed: $e');
    } finally {
      _isProcessing = false;
      _progress = 0.0;
      _currentFile = null;
      notifyListeners();
    }
  }

  /// Rescan and recluster everything
  Future<void> rescanAndRecluster() async {
    if (_isProcessing) return;

    _isProcessing = true;
    _progress = 0.0;
    _isInitialized = false;
    notifyListeners();

    try {
      _lastResult = await _initService.rescanAndRecluster(
        onProgress: (current, total, file) {
          _progress = current / total;
          _currentFile = file;
          notifyListeners();
        },
      );

      _isInitialized = true;
      print(_lastResult.toString());
    } catch (e) {
      print('Rescan and recluster failed: $e');
    } finally {
      _isProcessing = false;
      _progress = 0.0;
      _currentFile = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _faceEmbeddingService.dispose();
    super.dispose();
  }
}
