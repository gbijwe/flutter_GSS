// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faceEmbedding.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFaceEmbeddingCollection on Isar {
  IsarCollection<FaceEmbedding> get faceEmbeddings => this.collection();
}

const FaceEmbeddingSchema = CollectionSchema(
  name: r'FaceEmbedding',
  id: -7362080099285850007,
  properties: {
    r'clusterId': PropertySchema(
      id: 0,
      name: r'clusterId',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'embedding': PropertySchema(
      id: 2,
      name: r'embedding',
      type: IsarType.doubleList,
    ),
    r'filePath': PropertySchema(
      id: 3,
      name: r'filePath',
      type: IsarType.string,
    ),
    r'personId': PropertySchema(
      id: 4,
      name: r'personId',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 5,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _faceEmbeddingEstimateSize,
  serialize: _faceEmbeddingSerialize,
  deserialize: _faceEmbeddingDeserialize,
  deserializeProp: _faceEmbeddingDeserializeProp,
  idName: r'id',
  indexes: {
    r'filePath': IndexSchema(
      id: 2918041768256347220,
      name: r'filePath',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'filePath',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'clusterId': IndexSchema(
      id: 1919966277605001711,
      name: r'clusterId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'clusterId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'personId': IndexSchema(
      id: 750717629518044662,
      name: r'personId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'personId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _faceEmbeddingGetId,
  getLinks: _faceEmbeddingGetLinks,
  attach: _faceEmbeddingAttach,
  version: '3.3.0',
);

int _faceEmbeddingEstimateSize(
  FaceEmbedding object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.embedding.length * 8;
  bytesCount += 3 + object.filePath.length * 3;
  {
    final value = object.personId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _faceEmbeddingSerialize(
  FaceEmbedding object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.clusterId);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeDoubleList(offsets[2], object.embedding);
  writer.writeString(offsets[3], object.filePath);
  writer.writeString(offsets[4], object.personId);
  writer.writeDateTime(offsets[5], object.updatedAt);
}

FaceEmbedding _faceEmbeddingDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FaceEmbedding();
  object.clusterId = reader.readLong(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.embedding = reader.readDoubleList(offsets[2]) ?? [];
  object.filePath = reader.readString(offsets[3]);
  object.id = id;
  object.personId = reader.readStringOrNull(offsets[4]);
  object.updatedAt = reader.readDateTime(offsets[5]);
  return object;
}

P _faceEmbeddingDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDoubleList(offset) ?? []) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _faceEmbeddingGetId(FaceEmbedding object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _faceEmbeddingGetLinks(FaceEmbedding object) {
  return [];
}

void _faceEmbeddingAttach(
  IsarCollection<dynamic> col,
  Id id,
  FaceEmbedding object,
) {
  object.id = id;
}

extension FaceEmbeddingQueryWhereSort
    on QueryBuilder<FaceEmbedding, FaceEmbedding, QWhere> {
  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterWhere> anyClusterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'clusterId'),
      );
    });
  }
}

extension FaceEmbeddingQueryWhere
    on QueryBuilder<FaceEmbedding, FaceEmbedding, QWhereClause> {
  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterWhereClause> idBetween(
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

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterWhereClause> filePathEqualTo(
    String filePath,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'filePath', value: [filePath]),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterWhereClause>
  filePathNotEqualTo(String filePath) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'filePath',
                lower: [],
                upper: [filePath],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'filePath',
                lower: [filePath],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'filePath',
                lower: [filePath],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'filePath',
                lower: [],
                upper: [filePath],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterWhereClause>
  clusterIdEqualTo(int clusterId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'clusterId', value: [clusterId]),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterWhereClause>
  clusterIdNotEqualTo(int clusterId) {
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

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterWhereClause>
  clusterIdGreaterThan(int clusterId, {bool include = false}) {
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

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterWhereClause>
  clusterIdLessThan(int clusterId, {bool include = false}) {
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

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterWhereClause>
  clusterIdBetween(
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

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterWhereClause>
  personIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'personId', value: [null]),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterWhereClause>
  personIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'personId',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterWhereClause> personIdEqualTo(
    String? personId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'personId', value: [personId]),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterWhereClause>
  personIdNotEqualTo(String? personId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'personId',
                lower: [],
                upper: [personId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'personId',
                lower: [personId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'personId',
                lower: [personId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'personId',
                lower: [],
                upper: [personId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension FaceEmbeddingQueryFilter
    on QueryBuilder<FaceEmbedding, FaceEmbedding, QFilterCondition> {
  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  clusterIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'clusterId', value: value),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  clusterIdGreaterThan(int value, {bool include = false}) {
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

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  clusterIdLessThan(int value, {bool include = false}) {
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

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  clusterIdBetween(
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

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  createdAtGreaterThan(DateTime value, {bool include = false}) {
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

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  createdAtLessThan(DateTime value, {bool include = false}) {
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

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  createdAtBetween(
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

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  embeddingElementEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'embedding',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  embeddingElementGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'embedding',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  embeddingElementLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'embedding',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  embeddingElementBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'embedding',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  embeddingLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'embedding', length, true, length, true);
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  embeddingIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'embedding', 0, true, 0, true);
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  embeddingIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'embedding', 0, false, 999999, true);
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  embeddingLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'embedding', 0, true, length, include);
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  embeddingLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'embedding', length, include, 999999, true);
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  embeddingLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'embedding',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  filePathEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'filePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  filePathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'filePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  filePathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'filePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  filePathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'filePath',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  filePathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'filePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  filePathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'filePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  filePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'filePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  filePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'filePath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  filePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'filePath', value: ''),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  filePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'filePath', value: ''),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
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

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition> idBetween(
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

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  personIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'personId'),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  personIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'personId'),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  personIdEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'personId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  personIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'personId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  personIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'personId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  personIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'personId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  personIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'personId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  personIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'personId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  personIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'personId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  personIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'personId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  personIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'personId', value: ''),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  personIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'personId', value: ''),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  updatedAtGreaterThan(DateTime value, {bool include = false}) {
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

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  updatedAtLessThan(DateTime value, {bool include = false}) {
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

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterFilterCondition>
  updatedAtBetween(
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

extension FaceEmbeddingQueryObject
    on QueryBuilder<FaceEmbedding, FaceEmbedding, QFilterCondition> {}

extension FaceEmbeddingQueryLinks
    on QueryBuilder<FaceEmbedding, FaceEmbedding, QFilterCondition> {}

extension FaceEmbeddingQuerySortBy
    on QueryBuilder<FaceEmbedding, FaceEmbedding, QSortBy> {
  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterSortBy> sortByClusterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clusterId', Sort.asc);
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterSortBy>
  sortByClusterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clusterId', Sort.desc);
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterSortBy> sortByFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.asc);
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterSortBy>
  sortByFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.desc);
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterSortBy> sortByPersonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personId', Sort.asc);
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterSortBy>
  sortByPersonIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personId', Sort.desc);
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension FaceEmbeddingQuerySortThenBy
    on QueryBuilder<FaceEmbedding, FaceEmbedding, QSortThenBy> {
  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterSortBy> thenByClusterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clusterId', Sort.asc);
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterSortBy>
  thenByClusterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clusterId', Sort.desc);
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterSortBy> thenByFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.asc);
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterSortBy>
  thenByFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.desc);
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterSortBy> thenByPersonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personId', Sort.asc);
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterSortBy>
  thenByPersonIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personId', Sort.desc);
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension FaceEmbeddingQueryWhereDistinct
    on QueryBuilder<FaceEmbedding, FaceEmbedding, QDistinct> {
  QueryBuilder<FaceEmbedding, FaceEmbedding, QDistinct> distinctByClusterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clusterId');
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QDistinct> distinctByEmbedding() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'embedding');
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QDistinct> distinctByFilePath({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'filePath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QDistinct> distinctByPersonId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'personId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FaceEmbedding, FaceEmbedding, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension FaceEmbeddingQueryProperty
    on QueryBuilder<FaceEmbedding, FaceEmbedding, QQueryProperty> {
  QueryBuilder<FaceEmbedding, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FaceEmbedding, int, QQueryOperations> clusterIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clusterId');
    });
  }

  QueryBuilder<FaceEmbedding, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<FaceEmbedding, List<double>, QQueryOperations>
  embeddingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'embedding');
    });
  }

  QueryBuilder<FaceEmbedding, String, QQueryOperations> filePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'filePath');
    });
  }

  QueryBuilder<FaceEmbedding, String?, QQueryOperations> personIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'personId');
    });
  }

  QueryBuilder<FaceEmbedding, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
