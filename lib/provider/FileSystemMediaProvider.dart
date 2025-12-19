import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:photo_buddy/data/media/mediaItem.dart';
import 'package:photo_buddy/data/repo/mediaRepo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watcher/watcher.dart';
import 'package:path/path.dart' as p;

// class FileSystemMediaProvider extends ChangeNotifier {
//   String? _selectedPath;
//   List<FileSystemEntity> _mediaFiles = [];
//   StreamSubscription<WatchEvent>? _watchSubscription;

//   static const String mediaSourceKey = "media_source_path";

//   // Getter for your UI to consume
//   List<FileSystemEntity> get mediaFiles => _mediaFiles;
//   String? get currentPath => _selectedPath;

//   Future<void> loadSavedPath() async {
//     final prefs = await SharedPreferences.getInstance();
//     final savedPath = prefs.getString(mediaSourceKey);

//     if (savedPath != null && await Directory(savedPath).exists()) {
//       _selectedPath = savedPath;
//       notifyListeners();

//       // Immediately load and watch the saved path
//       await _loadFiles();
//       _startWatching();
//     }
//   }

//   /// 1. Triggered when user clicks "Select Source"
//   Future<void> pickSourceDirectory() async {
//     final String? directoryPath = await getDirectoryPath();

//     if (directoryPath != null) {
//       _selectedPath = directoryPath;
//       notifyListeners();

//       await _savePathToPreferences(directoryPath);
//       // Load initial files
//       await _loadFiles();

//       // Start watching for future changes
//       _startWatching();
//     }
//   }

//   Future<void> _savePathToPreferences(String path) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(mediaSourceKey, path);
//   }

//   /// 2. Reads the directory once
//   Future<void> _loadFiles() async {
//     if (_selectedPath == null) return;

//     final dir = Directory(_selectedPath!);
//     if (await dir.exists()) {
//       // Get all files, filter for images/videos only
//       final List<FileSystemEntity> files = await dir.list().toList();

//       _mediaFiles = files.where((file) {
//         return _isMediaFile(file.path);
//       }).toList();

//       notifyListeners();
//     }
//   }

//   /// 3. Sets up the "Continuous" watcher
//   void _startWatching() {
//     // Cancel any previous subscription to avoid memory leaks
//     _watchSubscription?.cancel();
//     if (_selectedPath == null) return;
//     // We use the absolute path to avoid issues with relative paths
//     final absolutePath = p.absolute(_selectedPath!);
//     try {
//       // Use DirectoryWatcher from package:watcher
//       final watcher = DirectoryWatcher(absolutePath);
//       _watchSubscription = watcher.events.listen((event) {
//         // When a file is added, removed, or modified, reload the list
//         // Optimization: You could handle specific events to add/remove
//         // single items instead of reloading all, but reloading is safer for now.
//         debugPrint("File changed: ${event.type} ${event.path}");
//         _loadFiles();
//       });
//     } catch (e) {
//       debugPrint("Error starting watcher: $e");
//     }
//   }

//   bool _isMediaFile(String path) {
//     const allowedExtensions = [
//       '.jpg',
//       '.jpeg',
//       '.png',
//       '.bmp',
//       '.heic',
//       '.mov',
//       '.avi',
//       '.mkv',
//     ];
//     final extension = p.extension(path).toLowerCase();
//     return allowedExtensions.contains(extension);
//   }

//   @override
//   void dispose() {
//     _watchSubscription?.cancel();
//     super.dispose();
//   }
// }


class FileSystemMediaProvider extends ChangeNotifier {
  final MediaRepository _repo = MediaRepository();
  List<MediaItem> _mediaFiles = []; // Notice: List<MediaItem>, not FileSystemEntity
  List<MediaItem> _favoriteMediaFiles = [];
  String? _selectedPath;

  List<MediaItem> get mediaFiles => _mediaFiles;
  List<MediaItem> get favoriteMediaFiles => _favoriteMediaFiles;
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
      
      // 2. Sync in background to find new files
      _repo.syncFromDirectory(savedPath).then((_) {
        _refreshList(); // Update UI after sync finishes
      });
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
      await _refreshList();
    }
  }

  Future<void> _refreshList() async {
    _mediaFiles = await _repo.getAllMedia();
    _favoriteMediaFiles = await _repo.getFavorites();
    notifyListeners();
  }

  Future<void> toggleFavorite(int id) async {
    await _repo.toggleFavorite(id);
    // Reload to update the UI
    await _refreshList(); 
  }

  Future<void> getFavorites() async {
    await _repo.getFavorites();

    await _refreshList();
  }
}
