import 'package:isar_community/isar.dart';

part 'folder.g.dart';

@collection
@Name("Folders")
class Folder {
  Id id = Isar.autoIncrement;

  String name;

  DateTime? createdAt;

  // Store media item IDs
  List<int> mediaItemIds = [];

  // Optional: source directory this folder belongs to
  String? sourceDirectory;

  // Optional: color or icon for visual distinction
  String? color;

  Folder({
    required this.name,
    DateTime? createdAt,
    this.mediaItemIds = const [],
    this.sourceDirectory,
    this.color,
  }) : createdAt = createdAt ?? DateTime.now();
}
