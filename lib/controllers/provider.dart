//? Fetch all members
//? Search members with name and code
//? Add new member
//? Edit member
//? Delete member

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:golden_gym_system/db/local_db.dart';
import 'package:golden_gym_system/utilities/general.dart';
import 'package:moor/moor.dart';

class UserExists implements Exception {}

class UserNotExists implements Exception {}

enum MembershipType {
  normal,
  fatLoss,
}

enum ForrmField {
  code,
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

class MembersProvider extends ChangeNotifier {
  final MemberDao _dao;

  MembersProvider(this._dao);

  Stream<List<Member>> fetchMemers() {
    return _dao.fetchMembers();
  }

  Stream<List<Member>> searchMembers(String query) {
    final isQNumeric = isNumeric(query);
    return _dao.fetchMembers(query: query, isNumeric: isQNumeric);
  }

  Future<bool> doCodeExist(int code) {
    return _dao.doesCodeExist(code);
  }

  Future<int> addNewMember(MembersCompanion member) async {
    final exist = await doCodeExist(member.code.value);
    if (exist) throw UserExists();
    return _dao.insertMember(member);
  }

  Future<int> deleteMember(Insertable<Member> member) {
    return _dao.deleteMember(member);
  }

  Future<bool> updateMember(MembersCompanion member) async {
    final exist = await doCodeExist(member.code.value);
    if (!exist) throw UserNotExists();
    final _member = member.copyWith(updatedAt: Value(DateTime.now()));
    return _dao.updateMember(_member);
  }

  Future<void> addDummyMember() async {
    final f = Faker();
    final createdAt = f.date.dateTime();
    final m = MembersCompanion(
      code: Value(f.randomGenerator.integer(9999, min: 1000)),
      name: Value(f.person.name()),
      membershipType: const Value('Normal'),
      membershipStart: Value(createdAt),
      membershipEnd: Value(createdAt.add(const Duration(days: 30))),
    );
    await addNewMember(m);
  }

  final Map<MembershipType, String> _membershipTypes = const {
    MembershipType.normal: 'عادي',
    MembershipType.fatLoss: 'تخسيس',
  };

  String membershipType(MembershipType type) => _membershipTypes[type]!;
}
