import 'package:isar_community/isar.dart';

part 'person.g.dart';

@collection
class Person {
  Id id = Isar.autoIncrement;
  
  // Cluster ID this person represents
  @Index(unique: true)
  late int clusterId;
  
  // User-assigned name (optional)
  String? name;
  
  // Representative face media path (best quality)
  String? representativeMediaPath;
  
  // Number of faces in this cluster
  late int faceCount;
  
  // Cluster centroid embedding
  late List<double> centroidEmbedding;
  
  // Timestamps
  late DateTime createdAt;
  late DateTime updatedAt;
  
  // User preferences
  bool isFavorite;
  bool isHidden;
  
  Person({
    this.isFavorite = false,
    this.isHidden = false,
  });
  
  Person.create({
    required this.clusterId,
    required this.faceCount,
    required this.centroidEmbedding,
    this.name,
    this.representativeMediaPath,
    this.isFavorite = false,
    this.isHidden = false,
  }) {
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
  }
}