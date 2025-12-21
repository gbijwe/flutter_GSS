import 'dart:async';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:photo_buddy/data/isar_classes/mediaItem.dart';
import 'package:photo_buddy/data/repo/mediaRepo.dart';
import 'package:photo_buddy/helpers/FileTypeChecker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;

class FileSystemMediaProvider extends ChangeNotifier {
  final MediaRepository _repo = MediaRepository();
  List<MediaItem> _mediaFiles = []; 
  List<MediaItem> _recentlyAddedMediaFiles = []; 
  List<MediaItem> _favoriteMediaFiles = [];
  String? _selectedPath;

  // getters
  List<MediaItem> get mediaFiles => _mediaFiles;
  List<MediaItem> get recentlyAddedMediaFiles => _recentlyAddedMediaFiles;
  List<MediaItem> get favoriteMediaFiles => _favoriteMediaFiles;
  List<MediaItem> get panaromicImages => _mediaFiles.where((file) => file.type == FileType.image && file.aspectRatio != null && file.aspectRatio! < 0.40).toList();
  List<MediaItem> get imageFilesOnly => _mediaFiles.where((file) => file.type == FileType.image).toList();
  List<MediaItem> get videoFilesOnly => _mediaFiles.where((file) => file.type == FileType.video).toList();

  // get current source path 
  String? get currentPath => _selectedPath;

  // Initialize DB and load previous state
  Future<void> init() async {
    await _repo.init(); // Open Isar

    // Load persisted path
    final prefs = await SharedPreferences.getInstance();
    final savedPath = prefs.getString('media_source_path');

    if (savedPath != null) {
      _selectedPath = savedPath;

      // 1. Show cached data immediately (Instant UI)
      await _refreshList();
      await getFavorites();
      await getRecentlyAddedMedia();
      // 2. Sync in background to find new files
      _repo.syncFromDirectory(savedPath).then((_) {
        getFavorites();
        getRecentlyAddedMedia();
        _refreshList(); // Update UI after sync finishes
      });
    }
  }

  Future<void> rescanDirectory() async {
    if (_selectedPath != null) {
      await _repo.syncFromDirectory(_selectedPath!);
      await _refreshList();
      await getFavorites();
      await getRecentlyAddedMedia();
    }
  }

  Future<void> pickSourceDirectory() async {
    final String? directoryPath = await getDirectoryPath();
    if (directoryPath != null) {
      _selectedPath = p.absolute(directoryPath);
      notifyListeners();

      // Save path
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('media_source_path', _selectedPath!);

      // Sync and Load
      await _repo.syncFromDirectory(_selectedPath!);
      await getFavorites();
      await getRecentlyAddedMedia();
      await _refreshList();
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

  // check if a media item is favorite by id
  bool isFavorite(int id) {
    final item = _mediaFiles.firstWhere((element) => element.id == id);
    return item.isFavorite;
  }

  Future<void> getFavorites() async {
    _favoriteMediaFiles = await _repo.getFavorites();
    notifyListeners();
  }

  // MediaRepository getter to be used by FolderRepository
  MediaRepository get mediaRepo => _repo;
}
