import 'package:data_tables/data_tables.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:golden_gym_system/db/local_db.dart';
import 'package:moor/moor.dart';
import 'package:provider/src/provider.dart';
import 'package:sqflite/sqflite.dart';

import 'add_member.dart';

// List<Memberr> members = [];

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final db = context.read<MemberDao>();
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddMemeberScreen()));
          // setState(() {});
          final f = Faker();
          final d = f.date.dateTime();
          final m = MembersCompanion(
            name: Value(f.person.name()),
            membershipStart: Value(d),
            membershipEnd: Value(d.add(Duration(days: 1))),
          );
          await db.insertMember(m);
          // final dbFolder = await getDatabasesPath();
          // print(dbFolder);
        },
      ),
      body: SafeArea(
        child: StreamBuilder<List<Member>>(
            stream: db.watchMembersS('spi'),
            builder: (context, snapshot) {
              final members = snapshot.data ?? const [];
              if (members.isEmpty) return const Center(child: Text("NO DATA"));
              return NativeDataTable.builder(
                rowsPerPage: 5656654,
                header: const Text("This is a header"),
                columns: const [
                  DataColumn(
                    label: Text("Name"),
                  ),
                  DataColumn(
                    label: Text("Start"),
                  ),
                  DataColumn(
                    label: Text("End"),
                  ),
                  DataColumn(
                    label: Text("Created At"),
                  ),
                ],
                itemCount: members.length,
                itemBuilder: (index) {
                  final member = members[index];
                  return DataRow.byIndex(
                    index: index,
                    cells: [
                      DataCell(Text(member.name), onTap: () {
                        print("object");
                      }),
                      DataCell(Text(member.membershipStart.toIso8601String())),
                      DataCell(Text(member.membershipEnd.toIso8601String())),
                      DataCell(Text(member.createdAt.millisecondsSinceEpoch.toString())),
                    ],
                  );
                },
              );
            }),
      ),
    );
  }
}
