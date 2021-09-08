import 'package:data_tables/data_tables.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moor/moor.dart';
import 'package:provider/provider.dart';

import 'package:golden_gym_system/controllers/provider.dart';
import 'package:golden_gym_system/db/local_db.dart';
import 'package:golden_gym_system/main.dart';
import 'package:golden_gym_system/screens/search.dart';

import '../utilities/datetime_format.dart';
import 'member_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      context.read<MembersProvider>().initMembers();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final memberProvider = context.read<MembersProvider>();
    final sort = context.select<MembersProvider, TColumnSort>((p) => p.sort);
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
            heroTag: 'general_button',
            onPressed: () async {
              memberProvider.addDummyMember();
              // await copyImage(File('/Users/ahmedmahmoud/Desktop/img.png'), 'new');
              // print("DONE");
              // try {
              //   final f = await memberProvider.doCodeExist(129);
              //   print(f);
              // } catch (e) {
              //   print(e);
              // }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Selector<MembersProvider, Stream<List<Member>>?>(
            selector: (_, provider) => provider.members,
            builder: (context, _membersStream, child) {
              if (_membersStream == null) return const Center(child: CircularProgressIndicator());
              return StreamBuilder<List<Member>>(
                stream: _membersStream,
                builder: (context, snapshot) {
                  final members = snapshot.data ?? const [];

                  return NativeDataTable.builder(
                    rowsPerPage: members.isEmpty ? 10 : members.length,
                    itemCount: members.length,
                    totalItems: members.length,
                    header: Row(
                      children: [
                        Image.asset(Constants.logo, width: 40, fit: BoxFit.fitWidth),
                        const SizedBox(width: 10),
                        Text("Golden Gym", style: TextStyle(color: CColors.gold)),
                      ],
                    ),
                    noItems: const Text("لا يوجد اي اعضاء مسجلين حتي لان"),
                    actions: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen()));
                        },
                        icon: const Icon(Icons.search),
                      )
                    ],
                    sortColumnIndex: sort.columnIndex,
                    sortAscending: sort.mode == OrderingMode.asc,
                    columns: [
                      DataColumn(label: const Text("ID"), onSort: memberProvider.changeMembersN),
                      DataColumn(label: const Text("الاسم"), onSort: memberProvider.changeMembersN),
                      DataColumn(label: const Text("نهاية الاشتراك"), onSort: memberProvider.changeMembersN),
                    ],
                    itemBuilder: (index) {
                      final member = members[index];
                      return DataRow.byIndex(
                        index: index,
                        cells: [
                          DataCell(Text('${member.id}'), onTap: () => _goToMember(member)),
                          DataCell(Text(member.name), onTap: () => _goToMember(member)),
                          DataCell(
                            Text(member.membershipEnd.toLocalizedDateString(locale: context.locale)),
                            onTap: () => _goToMember(member),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            }),
      ),
    );
  }

  void _goToMember(Member member) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AddMemeberScreen(member: member)));
  }
}
