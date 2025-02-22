// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TrustedDevicesTable extends TrustedDevices
    with TableInfo<$TrustedDevicesTable, TrustedDevice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrustedDevicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deviceNameMeta =
      const VerificationMeta('deviceName');
  @override
  late final GeneratedColumn<String> deviceName = GeneratedColumn<String>(
      'device_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deviceTypeMeta =
      const VerificationMeta('deviceType');
  @override
  late final GeneratedColumn<String> deviceType = GeneratedColumn<String>(
      'device_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _publicKeyMeta =
      const VerificationMeta('publicKey');
  @override
  late final GeneratedColumn<String> publicKey = GeneratedColumn<String>(
      'public_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, deviceId, deviceName, deviceType, publicKey];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trusted_devices';
  @override
  VerificationContext validateIntegrity(Insertable<TrustedDevice> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('device_name')) {
      context.handle(
          _deviceNameMeta,
          deviceName.isAcceptableOrUnknown(
              data['device_name']!, _deviceNameMeta));
    } else if (isInserting) {
      context.missing(_deviceNameMeta);
    }
    if (data.containsKey('device_type')) {
      context.handle(
          _deviceTypeMeta,
          deviceType.isAcceptableOrUnknown(
              data['device_type']!, _deviceTypeMeta));
    } else if (isInserting) {
      context.missing(_deviceTypeMeta);
    }
    if (data.containsKey('public_key')) {
      context.handle(_publicKeyMeta,
          publicKey.isAcceptableOrUnknown(data['public_key']!, _publicKeyMeta));
    } else if (isInserting) {
      context.missing(_publicKeyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrustedDevice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrustedDevice(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      deviceName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_name'])!,
      deviceType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_type'])!,
      publicKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}public_key'])!,
    );
  }

  @override
  $TrustedDevicesTable createAlias(String alias) {
    return $TrustedDevicesTable(attachedDatabase, alias);
  }
}

class TrustedDevice extends DataClass implements Insertable<TrustedDevice> {
  final int id;
  final String deviceId;
  final String deviceName;
  final String deviceType;
  final String publicKey;
  const TrustedDevice(
      {required this.id,
      required this.deviceId,
      required this.deviceName,
      required this.deviceType,
      required this.publicKey});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['device_id'] = Variable<String>(deviceId);
    map['device_name'] = Variable<String>(deviceName);
    map['device_type'] = Variable<String>(deviceType);
    map['public_key'] = Variable<String>(publicKey);
    return map;
  }

  TrustedDevicesCompanion toCompanion(bool nullToAbsent) {
    return TrustedDevicesCompanion(
      id: Value(id),
      deviceId: Value(deviceId),
      deviceName: Value(deviceName),
      deviceType: Value(deviceType),
      publicKey: Value(publicKey),
    );
  }

  factory TrustedDevice.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrustedDevice(
      id: serializer.fromJson<int>(json['id']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      deviceName: serializer.fromJson<String>(json['deviceName']),
      deviceType: serializer.fromJson<String>(json['deviceType']),
      publicKey: serializer.fromJson<String>(json['publicKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'deviceId': serializer.toJson<String>(deviceId),
      'deviceName': serializer.toJson<String>(deviceName),
      'deviceType': serializer.toJson<String>(deviceType),
      'publicKey': serializer.toJson<String>(publicKey),
    };
  }

  TrustedDevice copyWith(
          {int? id,
          String? deviceId,
          String? deviceName,
          String? deviceType,
          String? publicKey}) =>
      TrustedDevice(
        id: id ?? this.id,
        deviceId: deviceId ?? this.deviceId,
        deviceName: deviceName ?? this.deviceName,
        deviceType: deviceType ?? this.deviceType,
        publicKey: publicKey ?? this.publicKey,
      );
  @override
  String toString() {
    return (StringBuffer('TrustedDevice(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('deviceName: $deviceName, ')
          ..write('deviceType: $deviceType, ')
          ..write('publicKey: $publicKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, deviceId, deviceName, deviceType, publicKey);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrustedDevice &&
          other.id == this.id &&
          other.deviceId == this.deviceId &&
          other.deviceName == this.deviceName &&
          other.deviceType == this.deviceType &&
          other.publicKey == this.publicKey);
}

class TrustedDevicesCompanion extends UpdateCompanion<TrustedDevice> {
  final Value<int> id;
  final Value<String> deviceId;
  final Value<String> deviceName;
  final Value<String> deviceType;
  final Value<String> publicKey;
  const TrustedDevicesCompanion({
    this.id = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.deviceName = const Value.absent(),
    this.deviceType = const Value.absent(),
    this.publicKey = const Value.absent(),
  });
  TrustedDevicesCompanion.insert({
    this.id = const Value.absent(),
    required String deviceId,
    required String deviceName,
    required String deviceType,
    required String publicKey,
  })  : deviceId = Value(deviceId),
        deviceName = Value(deviceName),
        deviceType = Value(deviceType),
        publicKey = Value(publicKey);
  static Insertable<TrustedDevice> custom({
    Expression<int>? id,
    Expression<String>? deviceId,
    Expression<String>? deviceName,
    Expression<String>? deviceType,
    Expression<String>? publicKey,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceId != null) 'device_id': deviceId,
      if (deviceName != null) 'device_name': deviceName,
      if (deviceType != null) 'device_type': deviceType,
      if (publicKey != null) 'public_key': publicKey,
    });
  }

  TrustedDevicesCompanion copyWith(
      {Value<int>? id,
      Value<String>? deviceId,
      Value<String>? deviceName,
      Value<String>? deviceType,
      Value<String>? publicKey}) {
    return TrustedDevicesCompanion(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      deviceName: deviceName ?? this.deviceName,
      deviceType: deviceType ?? this.deviceType,
      publicKey: publicKey ?? this.publicKey,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (deviceName.present) {
      map['device_name'] = Variable<String>(deviceName.value);
    }
    if (deviceType.present) {
      map['device_type'] = Variable<String>(deviceType.value);
    }
    if (publicKey.present) {
      map['public_key'] = Variable<String>(publicKey.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrustedDevicesCompanion(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('deviceName: $deviceName, ')
          ..write('deviceType: $deviceType, ')
          ..write('publicKey: $publicKey')
          ..write(')'))
        .toString();
  }
}

class $HistoriesTable extends Histories
    with TableInfo<$HistoriesTable, History> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, type, title, content, date];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'histories';
  @override
  VerificationContext validateIntegrity(Insertable<History> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  History map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return History(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
    );
  }

  @override
  $HistoriesTable createAlias(String alias) {
    return $HistoriesTable(attachedDatabase, alias);
  }
}

class History extends DataClass implements Insertable<History> {
  final int id;
  final String type;
  final String title;
  final String content;
  final DateTime date;
  const History(
      {required this.id,
      required this.type,
      required this.title,
      required this.content,
      required this.date});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  HistoriesCompanion toCompanion(bool nullToAbsent) {
    return HistoriesCompanion(
      id: Value(id),
      type: Value(type),
      title: Value(title),
      content: Value(content),
      date: Value(date),
    );
  }

  factory History.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return History(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  History copyWith(
          {int? id,
          String? type,
          String? title,
          String? content,
          DateTime? date}) =>
      History(
        id: id ?? this.id,
        type: type ?? this.type,
        title: title ?? this.title,
        content: content ?? this.content,
        date: date ?? this.date,
      );
  @override
  String toString() {
    return (StringBuffer('History(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, title, content, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is History &&
          other.id == this.id &&
          other.type == this.type &&
          other.title == this.title &&
          other.content == this.content &&
          other.date == this.date);
}

class HistoriesCompanion extends UpdateCompanion<History> {
  final Value<int> id;
  final Value<String> type;
  final Value<String> title;
  final Value<String> content;
  final Value<DateTime> date;
  const HistoriesCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.date = const Value.absent(),
  });
  HistoriesCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required String title,
    required String content,
    required DateTime date,
  })  : type = Value(type),
        title = Value(title),
        content = Value(content),
        date = Value(date);
  static Insertable<History> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? content,
    Expression<DateTime>? date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (date != null) 'date': date,
    });
  }

  HistoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? type,
      Value<String>? title,
      Value<String>? content,
      Value<DateTime>? date}) {
    return HistoriesCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistoriesCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  _$AppDatabaseManager get managers => _$AppDatabaseManager(this);
  late final $TrustedDevicesTable trustedDevices = $TrustedDevicesTable(this);
  late final $HistoriesTable histories = $HistoriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [trustedDevices, histories];
}

typedef $$TrustedDevicesTableInsertCompanionBuilder = TrustedDevicesCompanion
    Function({
  Value<int> id,
  required String deviceId,
  required String deviceName,
  required String deviceType,
  required String publicKey,
});
typedef $$TrustedDevicesTableUpdateCompanionBuilder = TrustedDevicesCompanion
    Function({
  Value<int> id,
  Value<String> deviceId,
  Value<String> deviceName,
  Value<String> deviceType,
  Value<String> publicKey,
});

class $$TrustedDevicesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TrustedDevicesTable,
    TrustedDevice,
    $$TrustedDevicesTableFilterComposer,
    $$TrustedDevicesTableOrderingComposer,
    $$TrustedDevicesTableProcessedTableManager,
    $$TrustedDevicesTableInsertCompanionBuilder,
    $$TrustedDevicesTableUpdateCompanionBuilder> {
  $$TrustedDevicesTableTableManager(
      _$AppDatabase db, $TrustedDevicesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$TrustedDevicesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$TrustedDevicesTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$TrustedDevicesTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<String> deviceName = const Value.absent(),
            Value<String> deviceType = const Value.absent(),
            Value<String> publicKey = const Value.absent(),
          }) =>
              TrustedDevicesCompanion(
            id: id,
            deviceId: deviceId,
            deviceName: deviceName,
            deviceType: deviceType,
            publicKey: publicKey,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required String deviceId,
            required String deviceName,
            required String deviceType,
            required String publicKey,
          }) =>
              TrustedDevicesCompanion.insert(
            id: id,
            deviceId: deviceId,
            deviceName: deviceName,
            deviceType: deviceType,
            publicKey: publicKey,
          ),
        ));
}

class $$TrustedDevicesTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $TrustedDevicesTable,
    TrustedDevice,
    $$TrustedDevicesTableFilterComposer,
    $$TrustedDevicesTableOrderingComposer,
    $$TrustedDevicesTableProcessedTableManager,
    $$TrustedDevicesTableInsertCompanionBuilder,
    $$TrustedDevicesTableUpdateCompanionBuilder> {
  $$TrustedDevicesTableProcessedTableManager(super.$state);
}

class $$TrustedDevicesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $TrustedDevicesTable> {
  $$TrustedDevicesTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get deviceId => $state.composableBuilder(
      column: $state.table.deviceId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get deviceName => $state.composableBuilder(
      column: $state.table.deviceName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get deviceType => $state.composableBuilder(
      column: $state.table.deviceType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get publicKey => $state.composableBuilder(
      column: $state.table.publicKey,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$TrustedDevicesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $TrustedDevicesTable> {
  $$TrustedDevicesTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get deviceId => $state.composableBuilder(
      column: $state.table.deviceId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get deviceName => $state.composableBuilder(
      column: $state.table.deviceName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get deviceType => $state.composableBuilder(
      column: $state.table.deviceType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get publicKey => $state.composableBuilder(
      column: $state.table.publicKey,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$HistoriesTableInsertCompanionBuilder = HistoriesCompanion Function({
  Value<int> id,
  required String type,
  required String title,
  required String content,
  required DateTime date,
});
typedef $$HistoriesTableUpdateCompanionBuilder = HistoriesCompanion Function({
  Value<int> id,
  Value<String> type,
  Value<String> title,
  Value<String> content,
  Value<DateTime> date,
});

class $$HistoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HistoriesTable,
    History,
    $$HistoriesTableFilterComposer,
    $$HistoriesTableOrderingComposer,
    $$HistoriesTableProcessedTableManager,
    $$HistoriesTableInsertCompanionBuilder,
    $$HistoriesTableUpdateCompanionBuilder> {
  $$HistoriesTableTableManager(_$AppDatabase db, $HistoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$HistoriesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$HistoriesTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$HistoriesTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
          }) =>
              HistoriesCompanion(
            id: id,
            type: type,
            title: title,
            content: content,
            date: date,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required String type,
            required String title,
            required String content,
            required DateTime date,
          }) =>
              HistoriesCompanion.insert(
            id: id,
            type: type,
            title: title,
            content: content,
            date: date,
          ),
        ));
}

class $$HistoriesTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $HistoriesTable,
    History,
    $$HistoriesTableFilterComposer,
    $$HistoriesTableOrderingComposer,
    $$HistoriesTableProcessedTableManager,
    $$HistoriesTableInsertCompanionBuilder,
    $$HistoriesTableUpdateCompanionBuilder> {
  $$HistoriesTableProcessedTableManager(super.$state);
}

class $$HistoriesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $HistoriesTable> {
  $$HistoriesTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get content => $state.composableBuilder(
      column: $state.table.content,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$HistoriesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $HistoriesTable> {
  $$HistoriesTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get content => $state.composableBuilder(
      column: $state.table.content,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class _$AppDatabaseManager {
  final _$AppDatabase _db;
  _$AppDatabaseManager(this._db);
  $$TrustedDevicesTableTableManager get trustedDevices =>
      $$TrustedDevicesTableTableManager(_db, _db.trustedDevices);
  $$HistoriesTableTableManager get histories =>
      $$HistoriesTableTableManager(_db, _db.histories);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'714990a2e6fd2d3d79f7eec09f37630f4a590035';

/// See also [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = Provider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppDatabaseRef = ProviderRef<AppDatabase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
