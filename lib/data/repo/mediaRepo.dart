import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_buddy/data/isar_classes/faceEmbedding.dart';
import 'package:photo_buddy/data/isar_classes/folder.dart';
import 'package:photo_buddy/data/isar_classes/mediaItem.dart';
import 'package:photo_buddy/data/isar_classes/person.dart';
import 'package:photo_buddy/helpers/FileTypeChecker.dart';
import 'package:photo_buddy/helpers/PathContextManger.dart';

class MediaRepository {
  late Isar _isar;
  final _pathContext = PathContextManager();
  
  /// Open the Database
  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();

    // Open Isar with the schema
    _isar = await Isar.open([MediaItemSchema, FolderSchema, FaceEmbeddingSchema, PersonSchema], directory: dir.path);
  }

  /// Get all items sorted by DateAdded 
  Future<List<MediaItem>> getAllMedia() async {
    final currentPath = _pathContext.currentPath;
    if (currentPath == null) return [];

    return await _isar.mediaItems
        .filter()
        .pathStartsWith(currentPath)
        .sortByDateAddedDesc()
        .findAll();
  }

  Future<List<MediaItem>> getRecentlyAddedMedia() async {
    final currentPath = _pathContext.currentPath;
    if (currentPath == null) return [];

    final last24Hours = DateTime.now().subtract(Duration(hours: 24));
    return await _isar.mediaItems
        .filter()
        .pathStartsWith(currentPath)
        .and()
        .dateAddedGreaterThan(last24Hours, include: true)
        .sortByDateAddedDesc()
        .findAll();
  }

  /// Get only Favorites
  Future<List<MediaItem>> getFavorites() async {
    final currentPath = _pathContext.currentPath;
    if (currentPath == null) return [];

    return await _isar.mediaItems
        .filter()
        .pathStartsWith(currentPath)
        .and()
        .isFavoriteEqualTo(true)
        .sortByDateAddedDesc()
        .findAll();
  }

  /// Toggle Favorite Status
  Future<void> toggleFavorite(int id) async {
    await _isar.writeTxn(() async {
      final item = await _isar.mediaItems.get(id);
      if (item != null) {
        item.isFavorite = !item.isFavorite;
        await _isar.mediaItems.put(item);
      }
    });
  }

  Future<List<MediaItem>> getMediaItemsByIds(Set<int> ids) async {
    List<MediaItem> items = [];
    for (var id in ids) {
      final item = await _isar.mediaItems.get(id);
      if (item != null) {
        items.add(item);
      }
    }
    return items;
  }

  /// THE SYNC LOGIC
  Future<List<MediaItem>> syncFromDirectory(String directoryPath) async {
    final dir = Directory(directoryPath);
    if (!await dir.exists()) return [];

    // 1. Get real files from disk
    final List<FileSystemEntity> diskFiles = dir.listSync();
    final Set<String> diskPaths = {};
    final List<MediaItem> newItems = [];

    for (var file in diskFiles) {
      final path = file.path;
      final ext = path.split('.').last.toLowerCase();

      // Helper to determine Enum type (see bottom of file)
      final FileType? type = _getFileType(ext);

      // If type is null, it's not a supported media file, so skip it
      if (type == null) continue;

      diskPaths.add(path);

      // Check if this file is already in our DB
      final existingItem = await _isar.mediaItems
          .filter()
          .pathEqualTo(path)
          .findFirst();

      if (existingItem == null) {
        // It's a new file! Add it.
        final stat = await file.stat();
        // Add image size and aspect ratio for panaroma filtering
        if (type == FileType.image) {
          final sizeResult = ImageSizeGetter.getSizeResult(FileInput(file as File));

          int width = sizeResult.size.width > sizeResult.size.height ? sizeResult.size.height : sizeResult.size.width;
          int height = sizeResult.size.width < sizeResult.size.height ? sizeResult.size.height : sizeResult.size.width;
          debugPrint("Aspect Ratio: ${width / height}");
          newItems.add(
            MediaItem(
              path: path,
              dateAdded: stat.modified, 
              type: type, 
              width: width,
              height: height,
              aspectRatio: width / height,
            ),
          );
        } else {
          newItems.add(
            MediaItem(
              path: path,
              dateAdded: stat.modified, // Updated from modifiedDate
              type: type, // Passing the Enum directly
            ),
          );
        }
      }
    }

    // 2. Write new items to DB in a single transaction
    if (newItems.isNotEmpty) {
      await _isar.writeTxn(() async {
        await _isar.mediaItems.putAll(newItems);
      });
    }

    // 3. Clean up: Remove items from DB that no longer exist on disk
    // (Only remove items that belong to the current directory being scanned)
    final itemsToDelete = await _isar.mediaItems
        .filter()
        .pathStartsWith(directoryPath)
        .findAll();

    final idsToDelete = itemsToDelete
        .where((item) => !diskPaths.contains(item.path))
        .map((e) => e.id)
        .toList();

    if (idsToDelete.isNotEmpty) {
      await _isar.writeTxn(() async {
        await _isar.mediaItems.deleteAll(idsToDelete);
      });
    }
    
    return newItems;
  }

  /// Simple helper to map extension strings to your Enum
  /// You might already have this logic in FileTypeChecker,
  /// if so, use that instead.
  FileType? _getFileType(String extension) {
    const imageExts = {'jpg', 'jpeg', 'png', 'gif', 'webp', 'heic'};
    const videoExts = {'mov', 'avi', 'mkv', 'webm','mp4'};

    if (imageExts.contains(extension)) {
      return FileType.image;
    } else if (videoExts.contains(extension)) {
      return FileType.video;
    }
    return null;
  }

  Isar get isar => _isar;
}
