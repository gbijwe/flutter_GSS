import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PathContextManager {
  static final PathContextManager _instance = PathContextManager._internal();
  factory PathContextManager() => _instance;
  PathContextManager._internal();

  String? _currentPath;
  static const String _prefKey = 'media_source_path';
  static const String _defaultDirName = 'photobuddysource';

  String? get currentPath => _currentPath;

  /// Initialize and load saved path, or create default directory
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPath = prefs.getString(_prefKey);

    if (savedPath != null && await Directory(savedPath).exists()) {
      _currentPath = savedPath;
    } else {
      // Create default directory
      _currentPath = await _createDefaultDirectory();
      await prefs.setString(_prefKey, _currentPath!);
    }
  }

  /// Create default photobuddysource directory
  Future<String> _createDefaultDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final defaultPath = '${appDir.path}/$_defaultDirName';
    final dir = Directory(defaultPath);

    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    return defaultPath;
  }

  /// Set new current path
  Future<void> setCurrentPath(String path) async {
    _currentPath = path;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, path);
  }

  /// Check if path is within current context
  bool isPathInContext(String filePath) {
    if (_currentPath == null) return false;
    return filePath.startsWith(_currentPath!);
  }
}
