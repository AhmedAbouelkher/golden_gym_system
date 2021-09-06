import 'dart:io';

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

  IntColumn get code => integer()();
  TextColumn get name => text().withLength(min: 1)();
  BlobColumn get image => blob().nullable()();

  DateTimeColumn get membershipStart => dateTime()();
  DateTimeColumn get membershipEnd => dateTime()();
  TextColumn get membershipType => text()();

  RealColumn get weight => real().nullable()();
  IntColumn get height => integer().nullable()();

  RealColumn get muscleMass => real().nullable()();
  RealColumn get burnRate => real().nullable()();
  RealColumn get fatPersentage => real().nullable()();

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

  Future<bool> doesCodeExist(int code) async {
    final query = select(members)..where((mbr) => mbr.code.equals(code));
    final member = await query.getSingleOrNull();
    return member != null;
  }

  Stream<List<Member>> fetchMembers({String? query, bool isNumeric = false}) {
    var s = select(members);
    if (query != null && query != '') {
      if (isNumeric) {
        s.where((member) => member.code.cast<String>().contains(query));
      } else {
        s.where((member) => member.name.contains(query));
      }
    }
    s.orderBy([(t) => OrderingTerm.desc(t.createdAt)]);

    return s.watch();
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
