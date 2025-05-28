import 'package:dev_flutter/Model/service.dart';
import 'package:flutter/material.dart';

class GroupViewModel extends ChangeNotifier {
  final List<Group> _groups = [];
  final List<User> _users = [];

  GroupViewModel() {
    _loadGroups();
  }

  Future<bool> _loadUsers() async {
    User user1 = User(username: "User 1", id: 1, email: "abc@email.com", first_name: "User", last_name: "1", gender: "male");
    _users.add(user1);
    User user2 = User(username: "User 2", id: 2, email: "abc@email.com", first_name: "User", last_name: "2", gender: "female");
    _users.add(user2);
    User user3 = User(username: "User 3", id: 3, email: "abc@email.com", first_name: "User", last_name: "3", gender: "other");
    _users.add(user3);
    User user4 = User(username: "User 4", id: 4, email: "abc@email.com", first_name: "User", last_name: "4", gender: "male");
    _users.add(user4);
    User user5 = User(username: "User 5", id: 5, email: "abc@email.com", first_name: "User", last_name: "5", gender: "femmale");
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

enum UserGender {
  male,
  female,
  other
}

class User {
  late int _id;
  late final String _username;
  late String _email;
  late String _first_name;
  late String _last_name;
  late UserGender _gender;


  User({required int id, required String username, required String email, required first_name, required last_name, required gender}) {
    _id = id;
    _username = username;
    _email = email;
    _first_name = first_name;
    _last_name = last_name;
    _gender = gender;
  }

  void setId(int id) {
    _id = id;
  }

  int getId() {
    return _id;
  }

  String getUsername() {
    return _username;
  }

   factory User.fromDTO(UserDTO userDto) {
    return User(
      id: userDto.id,
      username: userDto.username,
      email: userDto.email,
      first_name: userDto.firstName,
      last_name: userDto.lastName,
      gender: userDto.gender,
    );
  }

  static UserDTO toDTO(User user) {
    return UserDTO(
      id: user._id,
      username: user._username,
      email: user._email,
      firstName: user._first_name,
      lastName: user._last_name,
      gender: user._gender,
    );
  }

  @override
  String toString() {
    return _username;
  }
}

class Group {
  late final int _id;
  int? _creatorId;
  late String _name;
  final List<User> _members = [];

  Group({required String name, required int id, creatorId}) {
    _name = name;
    _id = id;
    _creatorId = creatorId;
  }

  factory Group.fromDTO(GroupDTO groupDTO) {
    return Group(
      name: groupDTO.name,
      id: groupDTO.id,
      creatorId: groupDTO.creatorId,
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
