// import 'package:isar_community/isar.dart';
// import '../isar_classes/faceEmbedding.dart';
// import '../isar_classes/person.dart';

// class FaceEmbeddingRepo {
//   final Isar isar;
  
//   FaceEmbeddingRepo(this.isar);
  
//   // Face embedding operations
//   Future<void> saveFaceEmbedding(FaceEmbedding face) async {
//     await isar.writeTxn(() async {
//       await isar.faceEmbeddings.put(face);
//     });
//   }
  
//   Future<void> saveFaceEmbeddings(List<FaceEmbedding> faces) async {
//     await isar.writeTxn(() async {
//       await isar.faceEmbeddings.putAll(faces);
//     });
//   }
  
//   Future<FaceEmbedding?> getFaceByMediaPath(String mediaPath) async {
//     return await isar.faceEmbeddings
//         .filter()
//         .filePathEqualTo(mediaPath)
//         .findFirst();
//   }
  
//   Future<List<FaceEmbedding>> getAllFaceEmbeddings() async {
//     return await isar.faceEmbeddings.where().findAll();
//   }
  
//   Future<List<FaceEmbedding>> getFacesByCluster(int clusterId) async {
//     return await isar.faceEmbeddings
//         .filter()
//         .clusterIdEqualTo(clusterId)
//         .findAll();
//   }
  
//   Future<List<FaceEmbedding>> getUnclusteredFaces() async {
//     return await isar.faceEmbeddings
//         .filter()
//         .clusterIdEqualTo(-1)
//         .findAll();
//   }
  
//   Future<void> updateFaceCluster(int faceId, int clusterId) async {
//     await isar.writeTxn(() async {
//       final face = await isar.faceEmbeddings.get(faceId);
//       if (face != null) {
//         face.clusterId = clusterId;
//         face.updatedAt = DateTime.now();
//         await isar.faceEmbeddings.put(face);
//       }
//     });
//   }
  
//   Future<void> updateFaceClusters(Map<int, int> faceIdToClusterId) async {
//     await isar.writeTxn(() async {
//       for (final entry in faceIdToClusterId.entries) {
//         final face = await isar.faceEmbeddings.get(entry.key);
//         if (face != null) {
//           face.clusterId = entry.value;
//           face.updatedAt = DateTime.now();
//           await isar.faceEmbeddings.put(face);
//         }
//       }
//     });
//   }
  
//   // Person operations
//   Future<void> savePerson(Person person) async {
//     await isar.writeTxn(() async {
//       await isar.persons.put(person);
//     });
//   }
  
//   Future<void> savePersons(List<Person> persons) async {
//     await isar.writeTxn(() async {
//       await isar.persons.putAll(persons);
//     });
//   }
  
//   Future<List<Person>> getAllPersons() async {
//     return await isar.persons.where().findAll();
//   }
  
//   Future<Person?> getPersonByCluster(int clusterId) async {
//     return await isar.persons
//         .filter()
//         .clusterIdEqualTo(clusterId)
//         .findFirst();
//   }
  
//   Future<void> updatePersonName(int personId, String name) async {
//     await isar.writeTxn(() async {
//       final person = await isar.persons.get(personId);
//       if (person != null) {
//         person.name = name;
//         person.updatedAt = DateTime.now();
//         await isar.persons.put(person);
//       }
//     });
//   }
  
//   Future<void> deletePerson(int personId) async {
//     await isar.writeTxn(() async {
//       await isar.persons.delete(personId);
//     });
//   }
  
//   Future<int> getTotalFaceCount() async {
//     return await isar.faceEmbeddings.count();
//   }
  
//   Future<int> getClusteredFaceCount() async {
//     return await isar.faceEmbeddings
//         .filter()
//         .clusterIdGreaterThan(-1)
//         .count();
//   }
  
//   Future<void> clearAllClusters() async {
//     await isar.writeTxn(() async {
//       final faces = await isar.faceEmbeddings.where().findAll();
//       for (final face in faces) {
//         face.clusterId = -1;
//         face.personId = null;
//       }
//       await isar.faceEmbeddings.putAll(faces);
//       await isar.persons.clear();
//     });
//   }
// }
