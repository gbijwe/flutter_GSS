import 'package:flutter/foundation.dart';
import 'package:photo_buddy/data/isar_classes/folder.dart';
import 'package:photo_buddy/data/isar_classes/mediaItem.dart';
import 'package:photo_buddy/data/repo/folderRepo.dart';
import 'package:photo_buddy/data/repo/mediaRepo.dart';
import 'package:photo_buddy/helpers/PathContextManger.dart';

enum FolderOperationStatus { idle, loading, success, error }

class FolderMediaProvider extends ChangeNotifier {
  final FolderRepository _folderRepo = FolderRepository();
  late final MediaRepository _mediaRepo;
  final _pathContext = PathContextManager();

  List<Folder> _folders = [];
  FolderOperationStatus _status = FolderOperationStatus.idle;
  String? _errorMessage;
  double _progress = 0.0;
  String _currentOperation = '';

  List<Folder> get folders => _folders;
  FolderOperationStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get hasError => _status == FolderOperationStatus.error;
  bool get isLoading => _status == FolderOperationStatus.loading;
  double get progress => _progress;
  String get currentOperation => _currentOperation;

  FolderMediaProvider(this._mediaRepo) {
    _folderRepo.setIsar(_mediaRepo.isar);
    _loadFolders();
  }

  void _setStatus(
    FolderOperationStatus status, {
    String? error,
    String? operation,
  }) {
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

  Future<void> _loadFolders() async {
    _folders = await _folderRepo.getAllFolders();
    notifyListeners();
  }

  /// Create a new folder
  Future<void> createFolder({required String name, String? color}) async {
    _setStatus(FolderOperationStatus.loading, operation: 'Creating folder...');
    _updateProgress(0.2);
    try {
      final currentPath = _pathContext.currentPath;
      if (currentPath == null) {
        _setStatus(
          FolderOperationStatus.error,
          error: 'No source directory selected',
        );
        return;
      }

      // Check for duplicate name
      _updateProgress(0.3, operation: 'Checking for duplicates...');
      final existing = _folders.where((f) => f.name == name).firstOrNull;
      if (existing != null) {
        _setStatus(
          FolderOperationStatus.error,
          error: 'This folder name already exists. Please \ncreate a new folder by a different name.',
        );
        return;
      }

      _updateProgress(0.6, operation: 'Creating folder...');
      await _folderRepo.createFolder(name: name, sourceDirectory: currentPath);

      _updateProgress(0.9, operation: 'Refreshing folders...');
      await _loadFolders();

      _updateProgress(1.0, operation: 'Done!');
      _setStatus(FolderOperationStatus.success);
    } catch (e) {
      _setStatus(
        FolderOperationStatus.error,
        error: "Failed to create folder: $e",
      );
    }
  }

  /// Add media to folder
  Future<void> addMediaToFolder({
    required int folderId,
    required List<int> mediaItemIds,
  }) async {
    await _folderRepo.addMediaToFolder(folderId, mediaItemIds);
    await _loadFolders();
  }

  /// Remove media from folder
  Future<void> removeMediaFromFolder({
    required int folderId,
    required List<int> mediaItemIds,
  }) async {
    await _folderRepo.removeMediaFromFolder(folderId, mediaItemIds);
    await _loadFolders();
    notifyListeners();
  }

  /// Delete folder
  Future<void> deleteFolder(int folderId) async {
    debugPrint("Deleting folder with ID: $folderId");
    await _folderRepo.deleteFolder(folderId);
    await _loadFolders();
  }

  /// Rename folder
  Future<void> renameFolder(int folderId, String newName) async {
    await _folderRepo.renameFolder(folderId, newName);
    await _loadFolders();
    notifyListeners();
  }

  /// Get media items in a folder
  Future<List<MediaItem>> getMediaInFolder(int folderId) async {
    final folder = await _folderRepo.getFolderById(folderId);
    if (folder == null || folder.mediaItemIds.isEmpty) {
      return [];
    }

    // Get all media items that match the IDs
    final allMedia = await _mediaRepo.getAllMedia();
    return allMedia
        .where((item) => folder.mediaItemIds.contains(item.id))
        .toList();
  }

  Future<void> refreshFolders() async {
    await _loadFolders();
  }

  void clearError() {
    _status = FolderOperationStatus.idle;
    _errorMessage = null;
    _progress = 0.0;
    _currentOperation = '';
    notifyListeners();
  }
}
