import 'dart:async';

import 'package:data_tables/data_tables.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:moor/moor.dart';
import 'package:provider/provider.dart';

import 'package:golden_gym_system/controllers/provider.dart';
import 'package:golden_gym_system/db/local_db.dart';
import 'package:tuple/tuple.dart';

import '../utilities/datetime_format.dart';
import 'member_details.dart';

import 'package:rxdart/rxdart.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _textEditingController;
  late final TimeDebouncer _debouncer;

  @override
  void initState() {
    _debouncer = TimeDebouncer<String>(onChanged: (text) {
      context.read<SearchMembersProvider>().searchMembers(text);
    });
    _textEditingController = TextEditingController()
      ..addListener(() {
        final text = _textEditingController.text.trim();
        _debouncer.add(text);
      });
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _goToMember(Member member) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AddMemeberScreen(member: member)));
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = context.read<SearchMembersProvider>();
    return Scaffold(
      body: SafeArea(
        child: Selector<SearchMembersProvider, Tuple2<List<Member>, TColumnSort>>(
            selector: (_, provider) => Tuple2(provider.members, provider.sort),
            builder: (context, data, child) {
              final members = data.item1;
              final sort = data.item2;
              return NativeDataTable.builder(
                rowsPerPage: members.isEmpty ? 10 : members.length,
                itemCount: members.length,
                totalItems: members.length,
                header: Row(
                  children: [
                    BackButton(onPressed: () => Navigator.pop(context)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        decoration: const InputDecoration(hintText: "ادخل اسم العضو او الـ ID الخاص به"),
                      ),
                    ),
                  ],
                ),
                noItems: const Text("لم نجد اي عضو بتلك البيانات"),
                sortColumnIndex: sort.columnIndex,
                sortAscending: sort.mode == OrderingMode.asc,
                columns: [
                  DataColumn(label: const Text("ID"), onSort: searchProvider.changeMembers),
                  DataColumn(label: const Text("الاسم"), onSort: searchProvider.changeMembers),
                  DataColumn(label: const Text("نهاية الاشتراك"), onSort: searchProvider.changeMembers),
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
            }),
      ),
    );
  }
}

const kDuaration = Duration(milliseconds: 400);

class TimeDebouncer<T> {
  final Duration duration;
  final ValueChanged<T> onChanged;

  TimeDebouncer({
    required this.onChanged,
    this.duration = kDuaration,
  }) {
    _streamController = StreamController<T>();
  }

  late StreamController<T> _streamController;
  Stream<T> get _stream => _streamController.stream.asBroadcastStream();
  StreamSubscription<T>? _streamSubscription;

  void add(T value) {
    _streamController.sink.add(value);
    _streamSubscription ??= _stream.debounceTime(duration).listen((value) {
      onChanged.call(value);
    });
  }

  void dispose() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    _streamController.close();
  }
}
