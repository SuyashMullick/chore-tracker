import 'package:dev_flutter/Model/service.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class GroupViewModel extends ChangeNotifier {
  final List<Group> _groups = [];
  final List<User> _users = [];

  GroupViewModel() {
    _loadGroups();
  }

  Future<bool> _loadGroups() async {
    try {
      final groupDTOs = await Service.fetchGroups();
      _groups.clear();
      for (final dto in groupDTOs) {
        final group = Group.fromDTO(dto);
        for (final userDTO in dto.users) {
          final user = User.fromDTO(userDTO);
          group._addMember(user);
          if (!_users.any((u) => u.getId() == user.getId())) {
            _users.add(user);
          }
        }
        _groups.add(group);
      }

      notifyListeners();
      return true;
    } catch (e) {
      log("Error loading groups: $e");
      return false;
    }
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

enum UserGender { male, female, other }

class User {
  late int _id;
  late final String _username;
  late String _email;
  late String _firstName;
  late String _lastName;
  late UserGender _gender;

  User(
      {required int id,
      required String username,
      required String email,
      required firstName,
      required lastName,
      required gender}) {
    _id = id;
    _username = username;
    _email = email;
    _firstName = firstName;
    _lastName = lastName;
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
      firstName: userDto.firstName,
      lastName: userDto.lastName,
      gender: userDto.gender,
    );
  }

  static UserDTO toDTO(User user) {
    return UserDTO(
      id: user._id,
      username: user._username,
      email: user._email,
      firstName: user._firstName,
      lastName: user._lastName,
      gender: user._gender,
    );
  }

  @override
  String toString() {
    return _username;
  }

  @override
  bool operator ==(Object other) =>
      other is User &&
      other.runtimeType == runtimeType &&
      other._id == _id;

  @override
  int get hashCode => _id.hashCode;
}

class Group {
  late final int _id;
  int? _creatorId;
  late String _name;
  final List<User> _members = [];

  Group(
      {required String name,
      required int id,
      required List<User> members,
      creatorId}) {
    _name = name;
    _id = id;
    _creatorId = creatorId;
    for (User member in members) {
      if (!_members.contains(member)) {
        _members.add(member);
      }
    }
  }

  factory Group.fromDTO(GroupDTO groupDto) {
    return Group(
        name: groupDto.name,
        id: groupDto.id,
        creatorId: groupDto.creatorId,
        members:
            groupDto.users.map((userDto) => User.fromDTO(userDto)).toList());
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

  @override
  bool operator ==(Object other) =>
      other is Group &&
      other.runtimeType == runtimeType &&
      other._id == _id;

  @override
  int get hashCode => _id.hashCode;
}
