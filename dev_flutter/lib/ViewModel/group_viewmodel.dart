import 'package:dev_flutter/Model/service.dart';
import 'package:flutter/material.dart';

class GroupViewModel extends ChangeNotifier {
  final List<Group> _groups = [];
  final List<User> _users = [];

  GroupViewModel() {
    _loadGroups();
  }

  _loadUsers() {
    User user1 = User(name: "User 1");
    _users.add(user1);
    User user2 = User(name: "User 2");
    _users.add(user2);
    User user3 = User(name: "User 3");
    _users.add(user3);
    User user4 = User(name: "User 4");
    _users.add(user4);
    User user5 = User(name: "User 5");
    _users.add(user5);
  }

  _loadGroups() {
    // for test
    _loadUsers();
    Group group1 = Group(name: "SweetHome", id: 1);

    group1._addMember(_users[0]);
    group1._addMember(_users[1]);
    _groups.add(group1);

    Group group2 = Group(name: "Group 2", id: 2);
    group2._addMember(_users[2]);
    group2._addMember(_users[1]);
    _groups.add(group2);

    Group group3 = Group(name: "Group 3", id: 3);
    group3._addMember(_users[4]);
    group3._addMember(_users[3]);
    _groups.add(group3);

    notifyListeners();
  }

  List<Group> getGroups() {
    return _groups;
  }

  addMembers(Group group, List<User> users) {
    if (_groups.contains(group)) {
      group._addMembers(users);

      notifyListeners();
    }
  }

  refreshView() {
    notifyListeners();
  }

  bool removeMember(Group group, User user) {
    bool result = false;
    if (_groups.contains(group)) {
      result = group._removeMember(user);

      notifyListeners();
    }
    return result;
  }

  addGroup(Group group) {
    if (!_groups.contains(group)) {
      _groups.add(group);

      notifyListeners();
    }
  }

  bool removeGroup(Group group) {
    bool result = _groups.remove(group);

    notifyListeners();
    return result;
  }

  List<User> getGroupMembers(Group group) {
    if (_groups.contains(group)) {
      return group.getMembers();
    }
    return [];
  }

  List<User> getUsers() {
    return _users;
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
  late String _name;
  final List<User> _members = [];

  Group({required name, required id}) {
    _name = name;
    _id = id;
  }

  factory Group.fromDTO(GroupDTO group) {
    return Group(
      name: group.name,
      id: group.id,
    );
  }

  _addMembers(List<User> users) {
    for (var user in users) {
      _addMember(user);
    }
  }

  _addMember(User user) {
    if (!_members.contains(user)) {
      _members.add(user);
    }
  }

  setName(String name) {
    if (name.isNotEmpty) {
      _name = name;
    }
  }

  bool _removeMember(User user) {
    return _members.remove(user);
  }

  List<User> getMembers() {
    return _members;
  }

  isPartOfGroup(User user) {
    return _members.contains(user);
  }

  getName() {
    return _name;
  }
}
