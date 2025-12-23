import 'dart:async';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:photo_buddy/data/isar_classes/mediaItem.dart';
import 'package:photo_buddy/data/repo/mediaRepo.dart';
import 'package:photo_buddy/helpers/FileTypeChecker.dart';
import 'package:photo_buddy/helpers/PathContextManger.dart';

enum MediaOperationStatus { idle, loading, success, error }

class FileSystemMediaProvider extends ChangeNotifier {
  final MediaRepository _repo = MediaRepository();
  final _pathContext = PathContextManager();

  List<MediaItem> _mediaFiles = []; 
  List<MediaItem> _recentlyAddedMediaFiles = []; 
  List<MediaItem> _favoriteMediaFiles = [];
  MediaOperationStatus _status = MediaOperationStatus.idle;
  String? _errorMessage;
  double _progress = 0.0;
  String _currentOperation = '';


  // getters
  String? get currentPath => _pathContext.currentPath;
  bool get isLoading => _status == MediaOperationStatus.loading;
  MediaOperationStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get hasError => _status == MediaOperationStatus.error;
  double get progress => _progress;
  String get currentOperation => _currentOperation;
  
  List<MediaItem> get mediaFiles => _mediaFiles;
  List<MediaItem> get recentlyAddedMediaFiles => _recentlyAddedMediaFiles;
  List<MediaItem> get favoriteMediaFiles => _mediaFiles.where((file) => file.isFavorite).toList();
  List<MediaItem> get panaromicImages => _mediaFiles.where((file) => file.type == FileType.image && file.aspectRatio != null && file.aspectRatio! < 0.40).toList();
  List<MediaItem> get imageFilesOnly => _mediaFiles.where((file) => file.type == FileType.image).toList();
  List<MediaItem> get videoFilesOnly => _mediaFiles.where((file) => file.type == FileType.video).toList();

  void _setStatus(MediaOperationStatus status, {String? error, String? operation}) {
    _status = status;
    _errorMessage = error;
    if (operation != null) _currentOperation = operation;
    notifyListeners();
  }

  void _updateProgress(double progress, {String? operation}) {
    _progress = progress.clamp(0.0, 1.0);
    if (operation != null) _currentOperation = operation;
    notifyListeners();
  }

  // Initialize DB and load previous state
  Future<void> init() async {
    _setStatus(MediaOperationStatus.loading, operation: 'Initializing...');
    _updateProgress(0.0);

    try {
      _updateProgress(0.2, operation: 'Loading configuration...');
      await _pathContext.init(); // Load saved path or create default
      
      _updateProgress(0.4, operation: 'Opening database...');
      await _repo.init(); // Open Isar

      // 1. Show cached data immediately (Instant UI)
      _updateProgress(0.6, operation: 'Loading cached media...');
      await _refreshList();
      await getRecentlyAddedMedia();
      
      _updateProgress(1.0, operation: 'Done!');
      _setStatus(MediaOperationStatus.success);
      
      // 2. Sync in background to find new files
      if (_pathContext.currentPath != null) {
        _repo.syncFromDirectory(_pathContext.currentPath!).then((_) {
          getRecentlyAddedMedia();
          _refreshList(); // Update UI after sync finishes
        });
      }
    } catch (e) {
      _setStatus(
        MediaOperationStatus.error,
        error: 'Failed to initialize: $e',
      );
    }
  }

  Future<void> rescanDirectory() async {
    final currentPath = _pathContext.currentPath;
    if (currentPath == null) {
      _setStatus(MediaOperationStatus.error, error: 'No source directory selected');
      return;
    }

    _setStatus(MediaOperationStatus.loading, operation: 'Rescanning directory...');
    _updateProgress(0.0);

    try {
      _updateProgress(0.3, operation: 'Scanning files...');
      await _repo.syncFromDirectory(currentPath);
      
      _updateProgress(0.7, operation: 'Loading media...');
      await _refreshList();
      await getRecentlyAddedMedia();
      
      _updateProgress(1.0, operation: 'Done!');
      _setStatus(MediaOperationStatus.success);
    } catch (e) {
      _setStatus(
        MediaOperationStatus.error,
        error: 'Failed to rescan directory: $e',
      );
    }
  }

  Future<void> pickSourceDirectory() async {
    final String? directoryPath = await getDirectoryPath();
    if (directoryPath == null) return;

    _setStatus(MediaOperationStatus.loading, operation: 'Setting source directory...');
    _updateProgress(0.0);

    try {
      _updateProgress(0.2, operation: 'Saving configuration...');
      await _pathContext.setCurrentPath(directoryPath);
      notifyListeners();

      // Sync and Load
      _updateProgress(0.4, operation: 'Scanning files...');
      await _repo.syncFromDirectory(directoryPath);
      
      _updateProgress(0.7, operation: 'Loading media...');
      await getRecentlyAddedMedia();
      await _refreshList();
      
      _updateProgress(1.0, operation: 'Done!');
      _setStatus(MediaOperationStatus.success);
    } catch (e) {
      _setStatus(
        MediaOperationStatus.error,
        error: 'Failed to set source directory: $e',
      );
    }
  }

  // Get all recently added media files
  Future<void> getRecentlyAddedMedia() async {
    _recentlyAddedMediaFiles = await _repo.getRecentlyAddedMedia(); 
    notifyListeners();
  }

  Future<void> _refreshList() async {
    _mediaFiles = await _repo.getAllMedia();
    notifyListeners();
  }

  Future<void> toggleFavorite(int id) async {
    await _repo.toggleFavorite(id);
    // Reload to update the UI
    final index = _mediaFiles.indexWhere((item) => item.id == id);
    if (index == -1) return;

    final file = _mediaFiles[index];
    // Update cached list of all media files
    file.isFavorite = !file.isFavorite;

    // Update the favoriteMediaFiles list
    if (file.isFavorite) {
      if (!_favoriteMediaFiles.any((e) => e.id == id)) {
        _favoriteMediaFiles.add(file);
      }
    } else {
      _favoriteMediaFiles.removeWhere((e) => e.id == id);
    }
    notifyListeners();
  }

  Future<void> addToFavorites(List<int> ids) async {
    for (var id in ids) {
      final index = _mediaFiles.indexWhere((item) => item.id == id);
      if (index == -1) continue;

      final file = _mediaFiles[index];
      if (!file.isFavorite) {
        _repo.toggleFavorite(file.id);
        // Update cached list of all media files
        file.isFavorite = true;
        if (!_favoriteMediaFiles.any((e) => e.id == id)) {
          _favoriteMediaFiles.add(file);
        }
      }
    }
    notifyListeners();
  }

  // Remove from favorites
  Future<void> removeFromFavorites(List<int> ids) async {
    for (var id in ids) {
      final index = _mediaFiles.indexWhere((item) => item.id == id);
      if (index == -1) continue;

      final file = _mediaFiles[index];
      if (file.isFavorite) {
        _repo.toggleFavorite(file.id);
        // Update cached list of all media files
        file.isFavorite = false;
        if (!_favoriteMediaFiles.any((e) => e.id == id)) {
          _favoriteMediaFiles.remove(file);
        }
      }
    }
    notifyListeners();
  }

  // check if a media item is favorite by id
  bool isFavorite(int id) {
    final item = _mediaFiles.firstWhere((element) => element.id == id);
    return item.isFavorite;
  }

  void clearError() {
    _status = MediaOperationStatus.idle;
    _errorMessage = null;
    _progress = 0.0;
    _currentOperation = '';
    notifyListeners();
  }

  // MediaRepository getter to be used by FolderRepository
  MediaRepository get mediaRepo => _repo;
}
