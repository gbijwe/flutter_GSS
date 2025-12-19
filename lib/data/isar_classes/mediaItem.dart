import 'package:isar_community/isar.dart';
import 'package:photo_buddy/helpers/FileTypeChecker.dart';

part 'mediaItem.g.dart';

@collection
@Name("MediaFiles")
class MediaItem {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String path;

  @Index()
  late DateTime dateAdded;

  @Index() @Enumerated(EnumType.name)
  late FileType type;

  bool isFavorite = false; 

  MediaItem({
    required this.path,
    required this.dateAdded,  
    required this.type,
    this.isFavorite = false,
  });
}