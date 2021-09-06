import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:golden_gym_system/controllers/provider.dart';
import 'package:golden_gym_system/db/local_db.dart';
import 'package:provider/provider.dart';

import 'member_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final memberProvider = context.read<MembersProvider>();
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AddMemeberScreen()));
            },
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            heroTag: 's',
            onPressed: () async {
              memberProvider.addDummyMember();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<List<Member>>(
            stream: memberProvider.fetchMemers(),
            builder: (context, snapshot) {
              final members = snapshot.data ?? const [];
              return NativeDataTable.builder(
                rowsPerPage: 10,
                itemCount: members.length,
                header: const Text("This is a header"),
                columns: const [
                  DataColumn(label: Text("Code")),
                  DataColumn(label: Text("Name")),
                  DataColumn(label: Text("Start")),
                  DataColumn(label: Text("End")),
                  DataColumn(label: Text("Created At")),
                  DataColumn(label: SizedBox.shrink()),
                ],
                itemBuilder: (index) {
                  final member = members[index];
                  return DataRow.byIndex(
                    index: index,
                    cells: [
                      DataCell(Text('${member.code}')),
                      DataCell(Text(member.name), onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => AddMemeberScreen(member: member)));
                      }),
                      DataCell(Text(member.membershipStart.toIso8601String())),
                      DataCell(Text(member.membershipEnd.toIso8601String())),
                      DataCell(Text(member.createdAt.millisecondsSinceEpoch.toString())),
                      DataCell(IconButton(onPressed: () {}, icon: const Icon(Icons.edit))),
                    ],
                  );
                },
              );
            }),
      ),
    );
  }
}
