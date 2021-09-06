// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Member extends DataClass implements Insertable<Member> {
  final int id;
  final int code;
  final String name;
  final Uint8List? image;
  final DateTime membershipStart;
  final DateTime membershipEnd;
  final String membershipType;
  final double? weight;
  final int? height;
  final double? muscleMass;
  final double? burnRate;
  final double? fatPersentage;
  final DateTime createdAt;
  final DateTime updatedAt;
  Member(
      {required this.id,
      required this.code,
      required this.name,
      this.image,
      required this.membershipStart,
      required this.membershipEnd,
      required this.membershipType,
      this.weight,
      this.height,
      this.muscleMass,
      this.burnRate,
      this.fatPersentage,
      required this.createdAt,
      required this.updatedAt});
  factory Member.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Member(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      code: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}code'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      image: const BlobType()
          .mapFromDatabaseResponse(data['${effectivePrefix}image']),
      membershipStart: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}membership_start'])!,
      membershipEnd: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}membership_end'])!,
      membershipType: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}membership_type'])!,
      weight: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}weight']),
      height: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}height']),
      muscleMass: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}muscle_mass']),
      burnRate: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}burn_rate']),
      fatPersentage: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}fat_persentage']),
      createdAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at'])!,
      updatedAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<int>(code);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<Uint8List?>(image);
    }
    map['membership_start'] = Variable<DateTime>(membershipStart);
    map['membership_end'] = Variable<DateTime>(membershipEnd);
    map['membership_type'] = Variable<String>(membershipType);
    if (!nullToAbsent || weight != null) {
      map['weight'] = Variable<double?>(weight);
    }
    if (!nullToAbsent || height != null) {
      map['height'] = Variable<int?>(height);
    }
    if (!nullToAbsent || muscleMass != null) {
      map['muscle_mass'] = Variable<double?>(muscleMass);
    }
    if (!nullToAbsent || burnRate != null) {
      map['burn_rate'] = Variable<double?>(burnRate);
    }
    if (!nullToAbsent || fatPersentage != null) {
      map['fat_persentage'] = Variable<double?>(fatPersentage);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MembersCompanion toCompanion(bool nullToAbsent) {
    return MembersCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
      membershipStart: Value(membershipStart),
      membershipEnd: Value(membershipEnd),
      membershipType: Value(membershipType),
      weight:
          weight == null && nullToAbsent ? const Value.absent() : Value(weight),
      height:
          height == null && nullToAbsent ? const Value.absent() : Value(height),
      muscleMass: muscleMass == null && nullToAbsent
          ? const Value.absent()
          : Value(muscleMass),
      burnRate: burnRate == null && nullToAbsent
          ? const Value.absent()
          : Value(burnRate),
      fatPersentage: fatPersentage == null && nullToAbsent
          ? const Value.absent()
          : Value(fatPersentage),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Member.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Member(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<int>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      image: serializer.fromJson<Uint8List?>(json['image']),
      membershipStart: serializer.fromJson<DateTime>(json['membershipStart']),
      membershipEnd: serializer.fromJson<DateTime>(json['membershipEnd']),
      membershipType: serializer.fromJson<String>(json['membershipType']),
      weight: serializer.fromJson<double?>(json['weight']),
      height: serializer.fromJson<int?>(json['height']),
      muscleMass: serializer.fromJson<double?>(json['muscleMass']),
      burnRate: serializer.fromJson<double?>(json['burnRate']),
      fatPersentage: serializer.fromJson<double?>(json['fatPersentage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<int>(code),
      'name': serializer.toJson<String>(name),
      'image': serializer.toJson<Uint8List?>(image),
      'membershipStart': serializer.toJson<DateTime>(membershipStart),
      'membershipEnd': serializer.toJson<DateTime>(membershipEnd),
      'membershipType': serializer.toJson<String>(membershipType),
      'weight': serializer.toJson<double?>(weight),
      'height': serializer.toJson<int?>(height),
      'muscleMass': serializer.toJson<double?>(muscleMass),
      'burnRate': serializer.toJson<double?>(burnRate),
      'fatPersentage': serializer.toJson<double?>(fatPersentage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Member copyWith(
          {int? id,
          int? code,
          String? name,
          Uint8List? image,
          DateTime? membershipStart,
          DateTime? membershipEnd,
          String? membershipType,
          double? weight,
          int? height,
          double? muscleMass,
          double? burnRate,
          double? fatPersentage,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Member(
        id: id ?? this.id,
        code: code ?? this.code,
        name: name ?? this.name,
        image: image ?? this.image,
        membershipStart: membershipStart ?? this.membershipStart,
        membershipEnd: membershipEnd ?? this.membershipEnd,
        membershipType: membershipType ?? this.membershipType,
        weight: weight ?? this.weight,
        height: height ?? this.height,
        muscleMass: muscleMass ?? this.muscleMass,
        burnRate: burnRate ?? this.burnRate,
        fatPersentage: fatPersentage ?? this.fatPersentage,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('Member(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('image: $image, ')
          ..write('membershipStart: $membershipStart, ')
          ..write('membershipEnd: $membershipEnd, ')
          ..write('membershipType: $membershipType, ')
          ..write('weight: $weight, ')
          ..write('height: $height, ')
          ..write('muscleMass: $muscleMass, ')
          ..write('burnRate: $burnRate, ')
          ..write('fatPersentage: $fatPersentage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          code.hashCode,
          $mrjc(
              name.hashCode,
              $mrjc(
                  image.hashCode,
                  $mrjc(
                      membershipStart.hashCode,
                      $mrjc(
                          membershipEnd.hashCode,
                          $mrjc(
                              membershipType.hashCode,
                              $mrjc(
                                  weight.hashCode,
                                  $mrjc(
                                      height.hashCode,
                                      $mrjc(
                                          muscleMass.hashCode,
                                          $mrjc(
                                              burnRate.hashCode,
                                              $mrjc(
                                                  fatPersentage.hashCode,
                                                  $mrjc(
                                                      createdAt.hashCode,
                                                      updatedAt
                                                          .hashCode))))))))))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Member &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.image == this.image &&
          other.membershipStart == this.membershipStart &&
          other.membershipEnd == this.membershipEnd &&
          other.membershipType == this.membershipType &&
          other.weight == this.weight &&
          other.height == this.height &&
          other.muscleMass == this.muscleMass &&
          other.burnRate == this.burnRate &&
          other.fatPersentage == this.fatPersentage &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MembersCompanion extends UpdateCompanion<Member> {
  final Value<int> id;
  final Value<int> code;
  final Value<String> name;
  final Value<Uint8List?> image;
  final Value<DateTime> membershipStart;
  final Value<DateTime> membershipEnd;
  final Value<String> membershipType;
  final Value<double?> weight;
  final Value<int?> height;
  final Value<double?> muscleMass;
  final Value<double?> burnRate;
  final Value<double?> fatPersentage;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const MembersCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.image = const Value.absent(),
    this.membershipStart = const Value.absent(),
    this.membershipEnd = const Value.absent(),
    this.membershipType = const Value.absent(),
    this.weight = const Value.absent(),
    this.height = const Value.absent(),
    this.muscleMass = const Value.absent(),
    this.burnRate = const Value.absent(),
    this.fatPersentage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MembersCompanion.insert({
    this.id = const Value.absent(),
    required int code,
    required String name,
    this.image = const Value.absent(),
    required DateTime membershipStart,
    required DateTime membershipEnd,
    required String membershipType,
    this.weight = const Value.absent(),
    this.height = const Value.absent(),
    this.muscleMass = const Value.absent(),
    this.burnRate = const Value.absent(),
    this.fatPersentage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : code = Value(code),
        name = Value(name),
        membershipStart = Value(membershipStart),
        membershipEnd = Value(membershipEnd),
        membershipType = Value(membershipType);
  static Insertable<Member> custom({
    Expression<int>? id,
    Expression<int>? code,
    Expression<String>? name,
    Expression<Uint8List?>? image,
    Expression<DateTime>? membershipStart,
    Expression<DateTime>? membershipEnd,
    Expression<String>? membershipType,
    Expression<double?>? weight,
    Expression<int?>? height,
    Expression<double?>? muscleMass,
    Expression<double?>? burnRate,
    Expression<double?>? fatPersentage,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (image != null) 'image': image,
      if (membershipStart != null) 'membership_start': membershipStart,
      if (membershipEnd != null) 'membership_end': membershipEnd,
      if (membershipType != null) 'membership_type': membershipType,
      if (weight != null) 'weight': weight,
      if (height != null) 'height': height,
      if (muscleMass != null) 'muscle_mass': muscleMass,
      if (burnRate != null) 'burn_rate': burnRate,
      if (fatPersentage != null) 'fat_persentage': fatPersentage,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MembersCompanion copyWith(
      {Value<int>? id,
      Value<int>? code,
      Value<String>? name,
      Value<Uint8List?>? image,
      Value<DateTime>? membershipStart,
      Value<DateTime>? membershipEnd,
      Value<String>? membershipType,
      Value<double?>? weight,
      Value<int?>? height,
      Value<double?>? muscleMass,
      Value<double?>? burnRate,
      Value<double?>? fatPersentage,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return MembersCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      image: image ?? this.image,
      membershipStart: membershipStart ?? this.membershipStart,
      membershipEnd: membershipEnd ?? this.membershipEnd,
      membershipType: membershipType ?? this.membershipType,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      muscleMass: muscleMass ?? this.muscleMass,
      burnRate: burnRate ?? this.burnRate,
      fatPersentage: fatPersentage ?? this.fatPersentage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<int>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (image.present) {
      map['image'] = Variable<Uint8List?>(image.value);
    }
    if (membershipStart.present) {
      map['membership_start'] = Variable<DateTime>(membershipStart.value);
    }
    if (membershipEnd.present) {
      map['membership_end'] = Variable<DateTime>(membershipEnd.value);
    }
    if (membershipType.present) {
      map['membership_type'] = Variable<String>(membershipType.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double?>(weight.value);
    }
    if (height.present) {
      map['height'] = Variable<int?>(height.value);
    }
    if (muscleMass.present) {
      map['muscle_mass'] = Variable<double?>(muscleMass.value);
    }
    if (burnRate.present) {
      map['burn_rate'] = Variable<double?>(burnRate.value);
    }
    if (fatPersentage.present) {
      map['fat_persentage'] = Variable<double?>(fatPersentage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MembersCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('image: $image, ')
          ..write('membershipStart: $membershipStart, ')
          ..write('membershipEnd: $membershipEnd, ')
          ..write('membershipType: $membershipType, ')
          ..write('weight: $weight, ')
          ..write('height: $height, ')
          ..write('muscleMass: $muscleMass, ')
          ..write('burnRate: $burnRate, ')
          ..write('fatPersentage: $fatPersentage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MembersTable extends Members with TableInfo<$MembersTable, Member> {
  final GeneratedDatabase _db;
  final String? _alias;
  $MembersTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _codeMeta = const VerificationMeta('code');
  late final GeneratedColumn<int?> code = GeneratedColumn<int?>(
      'code', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name =
      GeneratedColumn<String?>('name', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          typeName: 'TEXT',
          requiredDuringInsert: true);
  final VerificationMeta _imageMeta = const VerificationMeta('image');
  late final GeneratedColumn<Uint8List?> image = GeneratedColumn<Uint8List?>(
      'image', aliasedName, true,
      typeName: 'BLOB', requiredDuringInsert: false);
  final VerificationMeta _membershipStartMeta =
      const VerificationMeta('membershipStart');
  late final GeneratedColumn<DateTime?> membershipStart =
      GeneratedColumn<DateTime?>('membership_start', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _membershipEndMeta =
      const VerificationMeta('membershipEnd');
  late final GeneratedColumn<DateTime?> membershipEnd =
      GeneratedColumn<DateTime?>('membership_end', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _membershipTypeMeta =
      const VerificationMeta('membershipType');
  late final GeneratedColumn<String?> membershipType = GeneratedColumn<String?>(
      'membership_type', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _weightMeta = const VerificationMeta('weight');
  late final GeneratedColumn<double?> weight = GeneratedColumn<double?>(
      'weight', aliasedName, true,
      typeName: 'REAL', requiredDuringInsert: false);
  final VerificationMeta _heightMeta = const VerificationMeta('height');
  late final GeneratedColumn<int?> height = GeneratedColumn<int?>(
      'height', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _muscleMassMeta = const VerificationMeta('muscleMass');
  late final GeneratedColumn<double?> muscleMass = GeneratedColumn<double?>(
      'muscle_mass', aliasedName, true,
      typeName: 'REAL', requiredDuringInsert: false);
  final VerificationMeta _burnRateMeta = const VerificationMeta('burnRate');
  late final GeneratedColumn<double?> burnRate = GeneratedColumn<double?>(
      'burn_rate', aliasedName, true,
      typeName: 'REAL', requiredDuringInsert: false);
  final VerificationMeta _fatPersentageMeta =
      const VerificationMeta('fatPersentage');
  late final GeneratedColumn<double?> fatPersentage = GeneratedColumn<double?>(
      'fat_persentage', aliasedName, true,
      typeName: 'REAL', requiredDuringInsert: false);
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime?> createdAt = GeneratedColumn<DateTime?>(
      'created_at', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime?> updatedAt = GeneratedColumn<DateTime?>(
      'updated_at', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        code,
        name,
        image,
        membershipStart,
        membershipEnd,
        membershipType,
        weight,
        height,
        muscleMass,
        burnRate,
        fatPersentage,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? 'members';
  @override
  String get actualTableName => 'members';
  @override
  VerificationContext validateIntegrity(Insertable<Member> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    }
    if (data.containsKey('membership_start')) {
      context.handle(
          _membershipStartMeta,
          membershipStart.isAcceptableOrUnknown(
              data['membership_start']!, _membershipStartMeta));
    } else if (isInserting) {
      context.missing(_membershipStartMeta);
    }
    if (data.containsKey('membership_end')) {
      context.handle(
          _membershipEndMeta,
          membershipEnd.isAcceptableOrUnknown(
              data['membership_end']!, _membershipEndMeta));
    } else if (isInserting) {
      context.missing(_membershipEndMeta);
    }
    if (data.containsKey('membership_type')) {
      context.handle(
          _membershipTypeMeta,
          membershipType.isAcceptableOrUnknown(
              data['membership_type']!, _membershipTypeMeta));
    } else if (isInserting) {
      context.missing(_membershipTypeMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    }
    if (data.containsKey('height')) {
      context.handle(_heightMeta,
          height.isAcceptableOrUnknown(data['height']!, _heightMeta));
    }
    if (data.containsKey('muscle_mass')) {
      context.handle(
          _muscleMassMeta,
          muscleMass.isAcceptableOrUnknown(
              data['muscle_mass']!, _muscleMassMeta));
    }
    if (data.containsKey('burn_rate')) {
      context.handle(_burnRateMeta,
          burnRate.isAcceptableOrUnknown(data['burn_rate']!, _burnRateMeta));
    }
    if (data.containsKey('fat_persentage')) {
      context.handle(
          _fatPersentageMeta,
          fatPersentage.isAcceptableOrUnknown(
              data['fat_persentage']!, _fatPersentageMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Member map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Member.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $MembersTable createAlias(String alias) {
    return $MembersTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $MembersTable members = $MembersTable(this);
  late final MemberDao memberDao = MemberDao(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [members];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$MemberDaoMixin on DatabaseAccessor<AppDatabase> {
  $MembersTable get members => attachedDatabase.members;
}
