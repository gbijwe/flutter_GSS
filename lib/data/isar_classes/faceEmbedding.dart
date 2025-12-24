import 'package:isar_community/isar.dart';

part 'faceEmbedding.g.dart';

@collection
class FaceEmbedding {
  Id id = Isar.autoIncrement;

  @Index()
  late String filePath;

  late List<double> embedding;

  @Index()
  late int clusterId;

  @Index()
  String? personId;

  late DateTime createdAt;
  late DateTime updatedAt;
  
  FaceEmbedding();
  
  FaceEmbedding.create({
    required this.filePath,
    required this.embedding,
    this.clusterId = -1,
    this.personId,
  }) {
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
  }
}
