import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

part 'local_db.g.dart';

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

class Members extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1)();
  DateTimeColumn get membershipStart => dateTime()();
  DateTimeColumn get membershipEnd => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// This annotation tells the code generator which tables this DB works with
@UseMoor(tables: [Members], daos: [MemberDao])
// _$AppDatabase is the name of the generated class
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(FlutterQueryExecutor.inDatabaseFolder(path: 'db.sqlite', logStatements: true));

  @override
  // ignore: override_on_non_overriding_member
  int get schemaVersion => 1;
}

// Denote which tables this DAO can access
@UseDao(tables: [Members])
class MemberDao extends DatabaseAccessor<AppDatabase> with _$MemberDaoMixin {
  final AppDatabase db;

  // Called by the AppDatabase class
  MemberDao(this.db) : super(db);

  Future<int> insertMember(Insertable<Member> member) => into(members).insert(member);
  Future<int> deleteMember(Insertable<Member> member) => delete(members).delete(member);

  Stream<List<Member>> watchMembers() {
    return (select(members)
          ..orderBy([
            (t) => OrderingTerm.desc(t.createdAt),
            // (t) => OrderingTerm.asc(t.name),
          ]))
        .watch();
  }
}
