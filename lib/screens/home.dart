import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:golden_gym_system/db/local_db.dart';
import 'package:golden_gym_system/models/member.dart';
import 'package:provider/src/provider.dart';

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
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddMemeberScreen()));
          setState(() {});
        },
      ),
      body: SafeArea(
        child: StreamBuilder<List<Member>>(
            stream: db.watchMembers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData) return const Center(child: Text("NO DATA"));
              final members = snapshot.data ?? const [];
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
                      DataCell(Text(member.name)),
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
