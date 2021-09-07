import 'dart:io';

import 'package:golden_gym_system/controllers/provider.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'local_db.g.dart';

QueryExecutor _openDB([bool log = true]) {
  if (Platform.isMacOS) {
    return FlutterQueryExecutor.inDatabaseFolder(path: 'local_db.sqlite', logStatements: log);
  }
  return LazyDatabase(() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final dbDir = await Directory(p.join(documentsDir.path, 'golden_gym')).create(recursive: true);
    final file = File(p.join(dbDir.path, 'db.sqlite'));
    return VmDatabase(file, logStatements: log);
  });
}

class Members extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1)();
  TextColumn get image => text().nullable()();
  TextColumn get membershipType => text()();

  RealColumn get height => real().nullable()();
  RealColumn get weight => real().nullable()();
  RealColumn get muscleMass => real().nullable()();
  RealColumn get burnRate => real().nullable()();
  RealColumn get fatPersentage => real().nullable()();

  DateTimeColumn get membershipStart => dateTime()();
  DateTimeColumn get membershipEnd => dateTime()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

@UseMoor(tables: [Members], daos: [MemberDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openDB());

  @override
  int get schemaVersion => 1;
}

// Denote which tables this DAO can access
@UseDao(tables: [Members])
class MemberDao extends DatabaseAccessor<AppDatabase> with _$MemberDaoMixin {
  final AppDatabase db;

  // Called by the AppDatabase class
  MemberDao(this.db) : super(db);

  Future<int> insertMember(Insertable<Member> member) => into(members).insert(member);

  Future<bool> updateMember(Insertable<Member> member) => update(members).replace(member);

  Future<int> deleteMember(Insertable<Member> member) => delete(members).delete(member);

  Future<bool> doesCodeExist(int id) async {
    final query = select(members)..where((mbr) => mbr.id.equals(id));
    final member = await query.getSingleOrNull();
    return member != null;
  }

  Stream<List<Member>> fetchMembers({TColumnSort? sort}) {
    var s = select(members);
    final _sort = sort ?? kColumnSort;
    switch (_sort.column) {
      case TableColumn.id:
        s.orderBy([(t) => OrderingTerm(expression: t.id, mode: _sort.mode)]);
        break;
      case TableColumn.name:
        s.orderBy([(t) => OrderingTerm(expression: t.name, mode: _sort.mode)]);
        break;
      case TableColumn.membershipEnd:
        s.orderBy([(t) => OrderingTerm(expression: t.membershipEnd, mode: _sort.mode)]);
        break;
    }
    return s.watch();
  }

  Future<List<Member>> searchMembers({
    String? query,
    bool isNumeric = false,
    TColumnSort? sort,
  }) {
    var s = select(members);
    if (query != null && query != '') {
      if (isNumeric) {
        s.where((member) => member.id.cast<String>().contains(query));
      } else {
        s.where((member) => member.name.contains(query));
      }
    }
    final _sort = sort ?? kColumnSort;
    switch (_sort.column) {
      case TableColumn.id:
        s.orderBy([(t) => OrderingTerm(expression: t.id, mode: _sort.mode)]);
        break;
      case TableColumn.name:
        s.orderBy([(t) => OrderingTerm(expression: t.name, mode: _sort.mode)]);
        break;
      case TableColumn.membershipEnd:
        s.orderBy([(t) => OrderingTerm(expression: t.membershipEnd, mode: _sort.mode)]);
        break;
    }

    return s.get();
  }

  Stream<Member> watchMember(int id) {
    final query = select(members)..where((mbr) => mbr.id.equals(id));
    return query.watchSingle();
  }

  Future<int> rowsCount() async {
    //Create expression of count
    var countExp = members.id.count();

    //Moor creates query from Expression so, they don't have value unless you execute it as query.
    //Following query will execute experssion on Table.
    final query = selectOnly(members)..addColumns([countExp]);
    int result = await query.map((row) => row.read(countExp)).getSingle();
    return result;
  }
}
