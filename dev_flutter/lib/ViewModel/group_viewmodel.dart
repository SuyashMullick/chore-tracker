import 'package:dev_flutter/Model/service.dart';
import 'package:flutter/material.dart';

class GroupViewModel extends ChangeNotifier {
  final List<Group> _groups = [];
  final List<User> _users = [];

  GroupViewModel() {
    _loadGroups();
  }

  Future<bool> _loadUsers() async {
    User user1 = User(name: "User 1", id: 1);
    _users.add(user1);
    User user2 = User(name: "User 2", id: 2);
    _users.add(user2);
    User user3 = User(name: "User 3", id: 3);
    _users.add(user3);
    User user4 = User(name: "User 4", id: 4);
    _users.add(user4);
    User user5 = User(name: "User 5", id: 5);
    _users.add(user5);

    return true;
  }

  Future<bool> _loadGroups() async {
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

    return true;
  }

  List<Group> getGroups() {
    return _groups;
  }

  void addMembers(Group group, List<User> users) {
    if (_groups.contains(group)) {
      group._addMembers(users);

      notifyListeners();
    }
  }

  void refreshView() {
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

  void addGroup(Group group) {
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
  late int _id;

  User({required String name, required int id}) {
    _name = name;
  }

  int getId() {
    return _id;
  }

  String getName() {
    return _name;
  }

   factory User.fromDTO(UserDTO userDto) {
    return User(
      name: userDto.name,
      id: userDto.id,
    );
  }

  static UserDTO toDTO(User user) {
    return UserDTO(
      id: user._id,
      name: user._name,
    );
  }

  @override
  String toString() {
    return _name;
  }
}

class Group {
  late final int _id;
  late final int _creatorId;
  late String _name;
  final List<User> _members = [];

  Group({required String name, required int id}) {
    _name = name;
    _id = id;
  }

  factory Group.fromDTO(GroupDTO group) {
    return Group(
      name: group.name,
      id: group.id,
    );
  }

  static GroupDTO toDTO(Group group) {
    return GroupDTO(
      id: group._id,
      name: group._name,
      creatorId: group._creatorId,
      users: group._members.map((member) => User.toDTO(member)).toList(),
    );
  }

  int getId() {
    return _id;
  }

  void _addMembers(List<User> users) {
    for (var user in users) {
      _addMember(user);
    }
  }

  void _addMember(User user) {
    if (!_members.contains(user)) {
      _members.add(user);
    }
  }

  void setName(String name) {
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

  bool isPartOfGroup(User user) {
    return _members.contains(user);
  }

  String getName() {
    return _name;
  }
}
