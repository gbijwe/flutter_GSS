// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPersonCollection on Isar {
  IsarCollection<Person> get persons => this.collection();
}

const PersonSchema = CollectionSchema(
  name: r'Person',
  id: 7854610480646705599,
  properties: {
    r'centroidEmbedding': PropertySchema(
      id: 0,
      name: r'centroidEmbedding',
      type: IsarType.doubleList,
    ),
    r'clusterId': PropertySchema(
      id: 1,
      name: r'clusterId',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'faceCount': PropertySchema(
      id: 3,
      name: r'faceCount',
      type: IsarType.long,
    ),
    r'isFavorite': PropertySchema(
      id: 4,
      name: r'isFavorite',
      type: IsarType.bool,
    ),
    r'isHidden': PropertySchema(id: 5, name: r'isHidden', type: IsarType.bool),
    r'name': PropertySchema(id: 6, name: r'name', type: IsarType.string),
    r'representativeMediaPath': PropertySchema(
      id: 7,
      name: r'representativeMediaPath',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 8,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _personEstimateSize,
  serialize: _personSerialize,
  deserialize: _personDeserialize,
  deserializeProp: _personDeserializeProp,
  idName: r'id',
  indexes: {
    r'clusterId': IndexSchema(
      id: 1919966277605001711,
      name: r'clusterId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'clusterId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _personGetId,
  getLinks: _personGetLinks,
  attach: _personAttach,
  version: '3.3.0',
);

int _personEstimateSize(
  Person object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.centroidEmbedding.length * 8;
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.representativeMediaPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _personSerialize(
  Person object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDoubleList(offsets[0], object.centroidEmbedding);
  writer.writeLong(offsets[1], object.clusterId);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeLong(offsets[3], object.faceCount);
  writer.writeBool(offsets[4], object.isFavorite);
  writer.writeBool(offsets[5], object.isHidden);
  writer.writeString(offsets[6], object.name);
  writer.writeString(offsets[7], object.representativeMediaPath);
  writer.writeDateTime(offsets[8], object.updatedAt);
}

Person _personDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Person(
    isFavorite: reader.readBoolOrNull(offsets[4]) ?? false,
    isHidden: reader.readBoolOrNull(offsets[5]) ?? false,
  );
  object.centroidEmbedding = reader.readDoubleList(offsets[0]) ?? [];
  object.clusterId = reader.readLong(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.faceCount = reader.readLong(offsets[3]);
  object.id = id;
  object.name = reader.readStringOrNull(offsets[6]);
  object.representativeMediaPath = reader.readStringOrNull(offsets[7]);
  object.updatedAt = reader.readDateTime(offsets[8]);
  return object;
}

P _personDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleList(offset) ?? []) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 5:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _personGetId(Person object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _personGetLinks(Person object) {
  return [];
}

void _personAttach(IsarCollection<dynamic> col, Id id, Person object) {
  object.id = id;
}

extension PersonByIndex on IsarCollection<Person> {
  Future<Person?> getByClusterId(int clusterId) {
    return getByIndex(r'clusterId', [clusterId]);
  }

  Person? getByClusterIdSync(int clusterId) {
    return getByIndexSync(r'clusterId', [clusterId]);
  }

  Future<bool> deleteByClusterId(int clusterId) {
    return deleteByIndex(r'clusterId', [clusterId]);
  }

  bool deleteByClusterIdSync(int clusterId) {
    return deleteByIndexSync(r'clusterId', [clusterId]);
  }

  Future<List<Person?>> getAllByClusterId(List<int> clusterIdValues) {
    final values = clusterIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'clusterId', values);
  }

  List<Person?> getAllByClusterIdSync(List<int> clusterIdValues) {
    final values = clusterIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'clusterId', values);
  }

  Future<int> deleteAllByClusterId(List<int> clusterIdValues) {
    final values = clusterIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'clusterId', values);
  }

  int deleteAllByClusterIdSync(List<int> clusterIdValues) {
    final values = clusterIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'clusterId', values);
  }

  Future<Id> putByClusterId(Person object) {
    return putByIndex(r'clusterId', object);
  }

  Id putByClusterIdSync(Person object, {bool saveLinks = true}) {
    return putByIndexSync(r'clusterId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByClusterId(List<Person> objects) {
    return putAllByIndex(r'clusterId', objects);
  }

  List<Id> putAllByClusterIdSync(
    List<Person> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'clusterId', objects, saveLinks: saveLinks);
  }
}

extension PersonQueryWhereSort on QueryBuilder<Person, Person, QWhere> {
  QueryBuilder<Person, Person, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Person, Person, QAfterWhere> anyClusterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'clusterId'),
      );
    });
  }
}

extension PersonQueryWhere on QueryBuilder<Person, Person, QWhereClause> {
  QueryBuilder<Person, Person, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<Person, Person, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Person, Person, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterWhereClause> clusterIdEqualTo(
    int clusterId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'clusterId', value: [clusterId]),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterWhereClause> clusterIdNotEqualTo(
    int clusterId,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'clusterId',
                lower: [],
                upper: [clusterId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'clusterId',
                lower: [clusterId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'clusterId',
                lower: [clusterId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'clusterId',
                lower: [],
                upper: [clusterId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<Person, Person, QAfterWhereClause> clusterIdGreaterThan(
    int clusterId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'clusterId',
          lower: [clusterId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterWhereClause> clusterIdLessThan(
    int clusterId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'clusterId',
          lower: [],
          upper: [clusterId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterWhereClause> clusterIdBetween(
    int lowerClusterId,
    int upperClusterId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'clusterId',
          lower: [lowerClusterId],
          includeLower: includeLower,
          upper: [upperClusterId],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension PersonQueryFilter on QueryBuilder<Person, Person, QFilterCondition> {
  QueryBuilder<Person, Person, QAfterFilterCondition>
  centroidEmbeddingElementEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'centroidEmbedding',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition>
  centroidEmbeddingElementGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'centroidEmbedding',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition>
  centroidEmbeddingElementLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'centroidEmbedding',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition>
  centroidEmbeddingElementBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'centroidEmbedding',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition>
  centroidEmbeddingLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'centroidEmbedding', length, true, length, true);
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition>
  centroidEmbeddingIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'centroidEmbedding', 0, true, 0, true);
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition>
  centroidEmbeddingIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'centroidEmbedding', 0, false, 999999, true);
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition>
  centroidEmbeddingLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'centroidEmbedding', 0, true, length, include);
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition>
  centroidEmbeddingLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'centroidEmbedding',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition>
  centroidEmbeddingLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'centroidEmbedding',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> clusterIdEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'clusterId', value: value),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> clusterIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'clusterId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> clusterIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'clusterId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> clusterIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'clusterId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> createdAtEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> faceCountEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'faceCount', value: value),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> faceCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'faceCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> faceCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'faceCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> faceCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'faceCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> isFavoriteEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isFavorite', value: value),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> isHiddenEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isHidden', value: value),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'name'),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'name'),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> nameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> nameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> nameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition>
  representativeMediaPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'representativeMediaPath'),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition>
  representativeMediaPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'representativeMediaPath'),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition>
  representativeMediaPathEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'representativeMediaPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition>
  representativeMediaPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'representativeMediaPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition>
  representativeMediaPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'representativeMediaPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition>
  representativeMediaPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'representativeMediaPath',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition>
  representativeMediaPathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'representativeMediaPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition>
  representativeMediaPathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'representativeMediaPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition>
  representativeMediaPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'representativeMediaPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition>
  representativeMediaPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'representativeMediaPath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition>
  representativeMediaPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'representativeMediaPath',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition>
  representativeMediaPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'representativeMediaPath',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> updatedAtEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Person, Person, QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension PersonQueryObject on QueryBuilder<Person, Person, QFilterCondition> {}

extension PersonQueryLinks on QueryBuilder<Person, Person, QFilterCondition> {}

extension PersonQuerySortBy on QueryBuilder<Person, Person, QSortBy> {
  QueryBuilder<Person, Person, QAfterSortBy> sortByClusterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clusterId', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByClusterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clusterId', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByFaceCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'faceCount', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByFaceCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'faceCount', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByIsHidden() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isHidden', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByIsHiddenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isHidden', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByRepresentativeMediaPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'representativeMediaPath', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy>
  sortByRepresentativeMediaPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'representativeMediaPath', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension PersonQuerySortThenBy on QueryBuilder<Person, Person, QSortThenBy> {
  QueryBuilder<Person, Person, QAfterSortBy> thenByClusterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clusterId', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByClusterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clusterId', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByFaceCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'faceCount', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByFaceCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'faceCount', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByIsHidden() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isHidden', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByIsHiddenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isHidden', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByRepresentativeMediaPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'representativeMediaPath', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy>
  thenByRepresentativeMediaPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'representativeMediaPath', Sort.desc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Person, Person, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension PersonQueryWhereDistinct on QueryBuilder<Person, Person, QDistinct> {
  QueryBuilder<Person, Person, QDistinct> distinctByCentroidEmbedding() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'centroidEmbedding');
    });
  }

  QueryBuilder<Person, Person, QDistinct> distinctByClusterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clusterId');
    });
  }

  QueryBuilder<Person, Person, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Person, Person, QDistinct> distinctByFaceCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'faceCount');
    });
  }

  QueryBuilder<Person, Person, QDistinct> distinctByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFavorite');
    });
  }

  QueryBuilder<Person, Person, QDistinct> distinctByIsHidden() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isHidden');
    });
  }

  QueryBuilder<Person, Person, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Person, Person, QDistinct> distinctByRepresentativeMediaPath({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'representativeMediaPath',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Person, Person, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension PersonQueryProperty on QueryBuilder<Person, Person, QQueryProperty> {
  QueryBuilder<Person, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Person, List<double>, QQueryOperations>
  centroidEmbeddingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'centroidEmbedding');
    });
  }

  QueryBuilder<Person, int, QQueryOperations> clusterIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clusterId');
    });
  }

  QueryBuilder<Person, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Person, int, QQueryOperations> faceCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'faceCount');
    });
  }

  QueryBuilder<Person, bool, QQueryOperations> isFavoriteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFavorite');
    });
  }

  QueryBuilder<Person, bool, QQueryOperations> isHiddenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isHidden');
    });
  }

  QueryBuilder<Person, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Person, String?, QQueryOperations>
  representativeMediaPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'representativeMediaPath');
    });
  }

  QueryBuilder<Person, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
