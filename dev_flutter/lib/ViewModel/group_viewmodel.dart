import 'package:flutter/material.dart';

class GroupViewModel extends ChangeNotifier {
  final List<Group> _groups = [];

  GroupViewModel() {
    _loadGroups();
  }

  _loadGroups() {
    // for test
    Group group1 = Group(desc: "Group 1");
    group1.addMember(Member(name: "User 1"));
    group1.addMember(Member(name: "User 2"));
    _groups.add(group1);

    Group group2 = Group(desc: "Group 2");
    group2.addMember(Member(name: "User 3"));
    group2.addMember(Member(name: "User 2"));
    _groups.add(group2);

    notifyListeners();
  }

  List<Member> getAllMembers() {
    List<Member> members = [];
    for (Group group in _groups) {
        members.addAll(group.getMembers());
    }
    return members;
  }
}

class Member {
  final _id = 0;
  late final _name;

  Member({required name}) {
    _name = name;
  }

  getName() {
    return _name;
  }

  getId() {
    return _id;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is Member && other._id == other.getId();
  }

  @override
  int get hashCode => _id.hashCode;
}

class Group {
  final _id = 0;
  late final _desc;
  final List<Member> _members = [];

  Group({required desc}) {
    _desc = desc;
  }

  addMember(Member member) {
    if (!_members.contains(member)) {
      _members.add(member);
    }
  }

  List<Member> getMembers() {
    return _members;
  }

  isPartOfGroup(Member member) {
    // checks if member with same id exists
    return _members.contains(member);
  }

  getDesc() {
    return _desc;
  }
}
