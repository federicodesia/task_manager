// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drifted_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class DriftedState extends DataClass implements Insertable<DriftedState> {
  final String key;
  final Map<String, dynamic>? state;
  final DateTime updatedAt;
  DriftedState(
      {required this.key, required this.state, required this.updatedAt});
  factory DriftedState.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return DriftedState(
      key: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}key'])!,
      state: $DriftedStatesTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}state']))!,
      updatedAt: $DriftedStatesTable.$converter1.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']))!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    {
      final converter = $DriftedStatesTable.$converter0;
      map['state'] = Variable<String>(converter.mapToSql(state)!);
    }
    {
      final converter = $DriftedStatesTable.$converter1;
      map['updated_at'] = Variable<int>(converter.mapToSql(updatedAt)!);
    }
    return map;
  }

  DriftedStatesCompanion toCompanion(bool nullToAbsent) {
    return DriftedStatesCompanion(
      key: Value(key),
      state: Value(state),
      updatedAt: Value(updatedAt),
    );
  }

  factory DriftedState.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftedState(
      key: serializer.fromJson<String>(json['key']),
      state: serializer.fromJson<Map<String, dynamic>?>(json['state']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'state': serializer.toJson<Map<String, dynamic>?>(state),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DriftedState copyWith(
          {String? key, Map<String, dynamic>? state, DateTime? updatedAt}) =>
      DriftedState(
        key: key ?? this.key,
        state: state ?? this.state,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('DriftedState(')
          ..write('key: $key, ')
          ..write('state: $state, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, state, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftedState &&
          other.key == this.key &&
          other.state == this.state &&
          other.updatedAt == this.updatedAt);
}

class DriftedStatesCompanion extends UpdateCompanion<DriftedState> {
  final Value<String> key;
  final Value<Map<String, dynamic>?> state;
  final Value<DateTime> updatedAt;
  const DriftedStatesCompanion({
    this.key = const Value.absent(),
    this.state = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DriftedStatesCompanion.insert({
    required String key,
    required Map<String, dynamic>? state,
    required DateTime updatedAt,
  })  : key = Value(key),
        state = Value(state),
        updatedAt = Value(updatedAt);
  static Insertable<DriftedState> custom({
    Expression<String>? key,
    Expression<Map<String, dynamic>?>? state,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (state != null) 'state': state,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DriftedStatesCompanion copyWith(
      {Value<String>? key,
      Value<Map<String, dynamic>?>? state,
      Value<DateTime>? updatedAt}) {
    return DriftedStatesCompanion(
      key: key ?? this.key,
      state: state ?? this.state,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (state.present) {
      final converter = $DriftedStatesTable.$converter0;
      map['state'] = Variable<String>(converter.mapToSql(state.value)!);
    }
    if (updatedAt.present) {
      final converter = $DriftedStatesTable.$converter1;
      map['updated_at'] = Variable<int>(converter.mapToSql(updatedAt.value)!);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftedStatesCompanion(')
          ..write('key: $key, ')
          ..write('state: $state, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DriftedStatesTable extends DriftedStates
    with TableInfo<$DriftedStatesTable, DriftedState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriftedStatesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String?> key = GeneratedColumn<String?>(
      'key', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String?>
      state = GeneratedColumn<String?>('state', aliasedName, false,
              type: const StringType(), requiredDuringInsert: true)
          .withConverter<Map<String, dynamic>?>(
              $DriftedStatesTable.$converter0);
  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int?> updatedAt =
      GeneratedColumn<int?>('updated_at', aliasedName, false,
              type: const IntType(), requiredDuringInsert: true)
          .withConverter<DateTime>($DriftedStatesTable.$converter1);
  @override
  List<GeneratedColumn> get $columns => [key, state, updatedAt];
  @override
  String get aliasedName => _alias ?? 'drifted_states';
  @override
  String get actualTableName => 'drifted_states';
  @override
  VerificationContext validateIntegrity(Insertable<DriftedState> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    context.handle(_stateMeta, const VerificationResult.success());
    context.handle(_updatedAtMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  DriftedState map(Map<String, dynamic> data, {String? tablePrefix}) {
    return DriftedState.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $DriftedStatesTable createAlias(String alias) {
    return $DriftedStatesTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, dynamic>?, String> $converter0 =
      const StateConverter();
  static TypeConverter<DateTime, int> $converter1 = const DateTimeConverter();
}

abstract class _$DriftedDatabase extends GeneratedDatabase {
  _$DriftedDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  _$DriftedDatabase.connect(DatabaseConnection c) : super.connect(c);
  late final $DriftedStatesTable driftedStates = $DriftedStatesTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [driftedStates];
}
