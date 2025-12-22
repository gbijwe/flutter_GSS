import 'dart:async';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:photo_buddy/data/isar_classes/mediaItem.dart';
import 'package:photo_buddy/data/repo/mediaRepo.dart';
import 'package:photo_buddy/helpers/FileTypeChecker.dart';
import 'package:photo_buddy/helpers/PathContextManger.dart';

class FileSystemMediaProvider extends ChangeNotifier {
  final MediaRepository _repo = MediaRepository();
  final _pathContext = PathContextManager();

  List<MediaItem> _mediaFiles = []; 
  List<MediaItem> _recentlyAddedMediaFiles = []; 
  List<MediaItem> _favoriteMediaFiles = [];
  bool _isLoading = false;


  // getters
  String? get currentPath => _pathContext.currentPath;
  bool get isLoading => _isLoading;
  
  List<MediaItem> get mediaFiles => _mediaFiles;
  List<MediaItem> get recentlyAddedMediaFiles => _recentlyAddedMediaFiles;
  List<MediaItem> get favoriteMediaFiles => _mediaFiles.where((file) => file.isFavorite).toList();
  List<MediaItem> get panaromicImages => _mediaFiles.where((file) => file.type == FileType.image && file.aspectRatio != null && file.aspectRatio! < 0.40).toList();
  List<MediaItem> get imageFilesOnly => _mediaFiles.where((file) => file.type == FileType.image).toList();
  List<MediaItem> get videoFilesOnly => _mediaFiles.where((file) => file.type == FileType.video).toList();

  // Initialize DB and load previous state
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    await _pathContext.init(); // Load saved path or create default
    await _repo.init(); // Open Isar

      // 1. Show cached data immediately (Instant UI)
      await _refreshList();
      await getRecentlyAddedMedia();
      
      _isLoading = false;
      notifyListeners();
      
      // 2. Sync in background to find new files
      if (_pathContext.currentPath != null) {
        _repo.syncFromDirectory(_pathContext.currentPath!).then((_) {
          getRecentlyAddedMedia();
          _refreshList(); // Update UI after sync finishes
        });
      }
    }

  Future<void> rescanDirectory() async {
    final currentPath = _pathContext.currentPath;
    if (currentPath != null) {
      _isLoading = true;
      notifyListeners();
      
      await _repo.syncFromDirectory(currentPath);
      await _refreshList();
      await getRecentlyAddedMedia();
      
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> pickSourceDirectory() async {
    final String? directoryPath = await getDirectoryPath();
    if (directoryPath != null) {
      _isLoading = true;
      await _pathContext.setCurrentPath(directoryPath);
      notifyListeners();

      // Sync and Load
      await _repo.syncFromDirectory(directoryPath);
      await getRecentlyAddedMedia();
      await _refreshList();
      
      _isLoading = false;
      notifyListeners();
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

  // MediaRepository getter to be used by FolderRepository
  MediaRepository get mediaRepo => _repo;
}
