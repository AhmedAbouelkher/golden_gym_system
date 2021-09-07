import 'dart:developer';
import 'dart:io';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:moor/moor.dart';

import 'package:golden_gym_system/db/local_db.dart';
import 'package:golden_gym_system/utilities/general.dart';
import 'package:golden_gym_system/utilities/os.dart';

class UserExists implements Exception {}

class UserNotExists implements Exception {}

enum TableColumn {
  id,
  name,
  membershipEnd,
}

@immutable
class TColumnSort {
  final TableColumn column;
  final int columnIndex;
  final OrderingMode mode;

  TColumnSort({
    required this.column,
    required this.columnIndex,
    this.mode = OrderingMode.asc,
  }) : assert(column == TableColumn.values[columnIndex]);

  TColumnSort.sort({
    required this.column,
    required this.columnIndex,
    bool ascending = true,
  })  : mode = ascending ? OrderingMode.asc : OrderingMode.desc,
        assert(column == TableColumn.values[columnIndex]);

  @override
  String toString() => 'TColumnSort(column: $column, columnIndex: $columnIndex, mode: $mode)';
}

enum MembershipType {
  normal,
  fatLoss,
}

enum ForrmField {
  name,
  membershipStart,
  membershipEnd,
  membershipType,
  weight,
  height,
  muscleMass,
  burnRate,
  fatPersentage,
}

extension ToString on ForrmField {
  String toStr() => toString();
}

MembersCompanion memberfromFields(Map<ForrmField, dynamic> fields, [File? imageFile]) {
  return MembersCompanion.insert(
    name: fields[ForrmField.name],
    membershipStart: fields[ForrmField.membershipStart],
    membershipEnd: fields[ForrmField.membershipEnd],
    membershipType: fields[ForrmField.membershipType],
    weight: Value(fields[ForrmField.weight]),
    height: Value(fields[ForrmField.height]),
    muscleMass: Value(fields[ForrmField.muscleMass]),
    burnRate: Value(fields[ForrmField.burnRate]),
    fatPersentage: Value(fields[ForrmField.fatPersentage]),
    image: Value(imageFile?.path),
  );
}

MembersCompanion memberfromFieldss(Map<String, FormBuilderFieldState> fields, [File? imageFile]) {
  T? getFormValue<T>(ForrmField field, [bool isNum = false]) {
    final f = fields[field.toStr()]?.value;
    if (f == null) return null;
    if (!isNum) return f as T;
    return double.tryParse(f) as T;
  }

  return memberfromFields({
    ForrmField.name: getFormValue<String>(ForrmField.name),
    ForrmField.membershipStart: getFormValue<DateTime>(ForrmField.membershipStart),
    ForrmField.membershipEnd: getFormValue<DateTime>(ForrmField.membershipEnd),
    ForrmField.membershipType: enumToString(getFormValue<MembershipType>(ForrmField.membershipType)!),
    ForrmField.weight: getFormValue<double?>(ForrmField.weight, true),
    ForrmField.height: getFormValue<double?>(ForrmField.height, true),
    ForrmField.muscleMass: getFormValue<double?>(ForrmField.muscleMass, true),
    ForrmField.burnRate: getFormValue<double?>(ForrmField.burnRate, true),
    ForrmField.fatPersentage: getFormValue<double?>(ForrmField.fatPersentage, true),
  }, imageFile);
}

MembersCompanion updateMemberFromFields(Map<String, FormBuilderFieldState> fields, {required Member member}) {
  Value<T>? getFormValue<T>(ForrmField field, [bool isNum = false]) {
    final f = fields[field.toStr()]?.value;
    if (f == null) return null;
    if (!isNum) return Value(f as T);
    return Value(double.tryParse(f) as T);
  }

  final _member = member.toCompanion(false);

  final membershipType = Value(enumToString(getFormValue<MembershipType>(ForrmField.membershipType)!));
  return _member.copyWith(
    name: getFormValue<String>(ForrmField.name),
    membershipStart: getFormValue<DateTime>(ForrmField.membershipStart),
    membershipEnd: getFormValue<DateTime>(ForrmField.membershipEnd),
    membershipType: membershipType,
    weight: getFormValue<double?>(ForrmField.weight, true),
    height: getFormValue<double?>(ForrmField.height, true),
    muscleMass: getFormValue<double?>(ForrmField.muscleMass, true),
    burnRate: getFormValue<double?>(ForrmField.burnRate, true),
    fatPersentage: getFormValue<double?>(ForrmField.fatPersentage, true),
  );
}

TColumnSort kColumnSort = TColumnSort(column: TableColumn.membershipEnd, columnIndex: 2);

class SearchMembersProvider extends ChangeNotifier {
  final MemberDao _dao;
  TColumnSort? _sort;

  SearchMembersProvider(this._dao);

  TColumnSort get sort => _sort ?? kColumnSort;

  String _query = '';
  String get query => _query;
  bool _isNumericQ = false;

  List<Member> _members = [];
  List<Member> get members => _members;

  void changeMembers(int columnIndex, bool ascending) async {
    final column = TableColumn.values[columnIndex];
    final _sorrt = TColumnSort.sort(column: column, columnIndex: columnIndex, ascending: ascending);
    _members = await _dao.searchMembers(query: _query, isNumeric: _isNumericQ);
    _sort = _sorrt;
    notifyListeners();
  }

  void searchMembers(String query) async {
    _query = query;
    _isNumericQ = isNumeric(_query);
    _members = await _dao.searchMembers(query: _query, isNumeric: _isNumericQ);
    notifyListeners();
  }
}

class MembersProvider extends ChangeNotifier {
  final MemberDao _dao;
  TColumnSort? _sort;

  MembersProvider(this._dao);

  TColumnSort get sort => _sort ?? kColumnSort;

  Stream<List<Member>>? _members;
  Stream<List<Member>>? get members => _members;

  void initMembers() {
    _members = _dao.fetchMembers();
    notifyListeners();
  }

  void changeMembers(TColumnSort sort) {
    _members = _dao.fetchMembers(sort: sort);
    _sort = sort;
    notifyListeners();
  }

  void changeMembersN(int columnIndex, bool ascending) {
    final column = TableColumn.values[columnIndex];
    final _sorrt = TColumnSort.sort(column: column, columnIndex: columnIndex, ascending: ascending);
    _members = _dao.fetchMembers(sort: _sorrt);
    _sort = _sorrt;
    notifyListeners();
  }

  List<Member> _searchedMembers = [];
  List<Member> get searchResults => _searchedMembers;
  void searchMembers(String query) async {
    final isQNumeric = isNumeric(query);
    _searchedMembers = await _dao.searchMembers(query: query, isNumeric: isQNumeric);
    notifyListeners();
  }

  Future<bool> doCodeExist(int code) {
    return _dao.doesCodeExist(code);
  }

  Future<int> deleteMember(Insertable<Member> member, [File? image]) async {
    try {
      if (image != null) await deleteImage(image);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return _dao.deleteMember(member);
  }

  Stream<Member> watchMember(int id) => _dao.watchMember(id);

  Future<bool> updateMember(MembersCompanion member, [File? image]) async {
    final exist = await doCodeExist(member.id.value);
    if (!exist) throw UserNotExists();
    final imageHasChanged = image?.path != null && member.image.value != image?.path;
    MembersCompanion _member = member.copyWith(updatedAt: Value(DateTime.now()));
    if (image != null && imageHasChanged) {
      try {
        if (member.image.value != null) await deleteImage(File(member.image.value!));
        final newImage = await copyImage(image);
        _member = _member.copyWith(image: Value(newImage?.path));
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
    return _dao.updateMember(_member);
  }

  Future<void> addDummyMember() async {
    final f = Faker();
    final createdAt = f.date.dateTime();
    // final file = File('/Users/ahmedmahmoud/Desktop/img.png');
    // final copiedImage = await copyImage(file);
    final m = MembersCompanion(
      name: Value(f.person.name()),
      membershipType: const Value('Normal'),
      membershipStart: Value(createdAt),
      membershipEnd: Value(createdAt.add(const Duration(days: 30))),
      // image: Value(copiedImage?.path),
    );
    await addNewMember(m);
  }

  final Map<MembershipType, String> _membershipTypes = const {
    MembershipType.normal: 'عادي',
    MembershipType.fatLoss: 'تخسيس',
  };

  String membershipType(MembershipType type) => _membershipTypes[type]!;
}

extension NewUser on MembersProvider {
  Future<int> addNewMember(MembersCompanion member) async {
    final image = member.image.value;
    if (image != null) {
      final copiedImage = await copyImage(File(image));
      member = member.copyWith(image: Value(copiedImage?.path));
    }
    return _dao.insertMember(member);
  }
}
