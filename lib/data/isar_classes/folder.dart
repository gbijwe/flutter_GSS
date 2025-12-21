import 'package:isar_community/isar.dart';

part 'folder.g.dart';

@collection
@Name("Folders")
class Folder {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String name;

  DateTime? createdAt;

  // Store media item IDs
  List<int> mediaItemIds = [];

  // Optional: source directory this folder belongs to
  String sourceDirectory;

  Folder({
    required this.name,
    DateTime? createdAt,
    this.mediaItemIds = const [],
    required this.sourceDirectory,
  }) : createdAt = createdAt ?? DateTime.now();
}
