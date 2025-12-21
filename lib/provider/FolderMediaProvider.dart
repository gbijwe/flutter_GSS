import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_buddy/data/isar_classes/folder.dart';
import 'package:photo_buddy/data/isar_classes/mediaItem.dart';
import 'package:photo_buddy/data/repo/folderRepo.dart';
import 'package:photo_buddy/data/repo/mediaRepo.dart';

class FolderMediaProvider extends ChangeNotifier {
  final FolderRepository _folderRepo = FolderRepository();
  late final MediaRepository _mediaRepo;
  List<Folder> _folders = [];

  List<Folder> get folders => _folders;

  FolderMediaProvider(this._mediaRepo) {
    _folderRepo.setIsar(_mediaRepo.isar);
    _loadFolders();
  }

  Future<void> _loadFolders() async {
    _folders = await _folderRepo.getAllFolders();
    notifyListeners();
  }

  /// Create a new folder
  Future<void> createFolder({
    required String name,
    String? sourceDirectory,
    String? color,
  }) async {
    final applicationDir = await getApplicationDocumentsDirectory();
    await _folderRepo.createFolder(
      name: name,
      sourceDirectory: sourceDirectory ?? applicationDir.path,
      color: color,
    );
    await _loadFolders();
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
}
