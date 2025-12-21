import 'package:isar_community/isar.dart';
import 'package:photo_buddy/data/isar_classes/folder.dart';
import 'package:photo_buddy/helpers/PathContextManger.dart';

class FolderRepository {
  late Isar _isar;
  final _pathContext = PathContextManager();

  void setIsar(Isar isar) {
    _isar = isar;
  }

  /// Get all folders
  Future<List<Folder>> getAllFolders() async {
    final currentPath = _pathContext.currentPath;
    if (currentPath == null) return [];

    return await _isar.folders
        .filter()
        .sourceDirectoryEqualTo(currentPath)
        .sortByCreatedAtDesc()
        .findAll();
  }

  /// Create a new folder
  Future<int> createFolder({
    required String name,
    required String sourceDirectory,
  }) async {
    final folder = Folder(name: name, sourceDirectory: sourceDirectory);

    return await _isar.writeTxn(() async {
      return await _isar.folders.put(folder);
    });
  }

  /// Add media items to folder
  Future<void> addMediaToFolder(int folderId, List<int> mediaItemIds) async {
    await _isar.writeTxn(() async {
      final folder = await _isar.folders.get(folderId);
      if (folder != null) {
        // Add without duplicates
        final existingIds = folder.mediaItemIds.toSet();
        existingIds.addAll(mediaItemIds);
        folder.mediaItemIds = existingIds.toList();
        await _isar.folders.put(folder);
      }
    });
  }

  Future<void> removeMediaFromFolder(
    int folderId,
    List<int> mediaItemIds,
  ) async {
    await _isar.writeTxn(() async {
      final folder = await _isar.folders.get(folderId);
      if (folder != null) {
        // Create a new mutable list and filter out the IDs to remove
        folder.mediaItemIds = folder.mediaItemIds
            .where((id) => !mediaItemIds.contains(id))
            .toList(); // Create new list
        await _isar.folders.put(folder);
      }
    });
  }

  /// Delete folder
  Future<bool> deleteFolder(int folderId) async {
    return await _isar.writeTxn(() async {
      return await _isar.folders.delete(folderId);
    });
  }

  /// Rename folder
  Future<void> renameFolder(int folderId, String newName) async {
    await _isar.writeTxn(() async {
      final folder = await _isar.folders.get(folderId);
      if (folder != null) {
        folder.name = newName;
        await _isar.folders.put(folder);
      }
    });
  }

  /// Get folder by ID
  Future<Folder?> getFolderById(int folderId) async {
    return await _isar.folders.get(folderId);
  }
}
