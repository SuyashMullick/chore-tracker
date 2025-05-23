import 'package:dev_flutter/Model/service.dart';
import 'package:flutter/material.dart';

class GroupViewModel extends ChangeNotifier {
  final List<Group> _groups = [];

  GroupViewModel() {
    _loadGroups();
  }

  _loadGroups() {
    // for test
    Group group1 = Group(desc: "SweetHome", id: 1);
    User user1 = User(name: "User 1");
    User user2 = User(name: "User 2");
    User user3 = User(name: "User 3");
    User user4 = User(name: "User 4");
    User user5 = User(name: "User 5");
    group1.addMember(user1);
    group1.addMember(user2);
    _groups.add(group1);

    Group group2 = Group(desc: "Group 2", id: 2);
    group2.addMember(user3);
    group2.addMember(user2);
    _groups.add(group2);

    Group group3 = Group(desc: "Group 3", id: 3);
    group3.addMember(user4);
    group3.addMember(user5);
    _groups.add(group3);

    notifyListeners();
  }

  List<Group> getGroups() {
    return _groups;
  }

  List<User> getAllMembers() {
    List<User> members = [];
    for (Group group in _groups) {
      for (User member in group.getMembers()) {
        if (!members.contains(member)) {
          members.add(member);
        }
      }
    }
    return members;
  }
}

class User {
  late final String _name;

  User({required name}) {
    _name = name;
  }

  getName() {
    return _name;
  }

  @override
  String toString() {
    return _name;
  }
}

class Group {
  late final _id;
  late final _desc;
  final List<User> _members = [];

  Group({required desc, required id}) {
    _desc = desc;
    _id = id;
  }

  factory Group.fromDTO(GroupDTO group) {
    return Group(
      desc: group.name,
      id: group.id,
    );
  }

  addMember(User member) {
    if (!_members.contains(member)) {
      _members.add(member);
    }
  }

  List<User> getMembers() {
    return _members;
  }

  isPartOfGroup(User member) {
    return _members.contains(member);
  }

  getDesc() {
    return _desc;
  }
}
