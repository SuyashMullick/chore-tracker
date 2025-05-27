import 'package:dev_flutter/Model/service.dart';
import 'package:dev_flutter/ViewModel/group_viewmodel.dart';
import 'package:flutter/material.dart';


class Task {
  late int _points;
  late String _name;
  late Group _group;
  String? _desc;

  factory Task.fromDTO(TaskDTO task) {
    return Task(
      name: task.name,
      group: Group.fromDTO(task.group),
      points: task.points,
      desc: task.note
    );
  }

  static TaskDTO toDTO(Task task) {
    return TaskDTO(
      id: task.id,
      points: task.points,
      name: task.name,
      note: task.description,
      group: GroupDTO(
        id: task.groupId,
        name: task.groupName,
        creatorId: task.creatorId,
        users: task.members.map((user) => UserDTO(id: user.id, name: user.name)).toList(),
      ),
    );
  }

  Task({required name, required Group group, required points, desc}) {
    _desc = desc;
    _name = name;
    _group = group;
    setPoints(points);
  }

  void setPoints(int points) {
    if (points < 1 || points > 10) {
      throw ArgumentError("The points have to be between 1 and 10.");
    }
    _points = points;
  }

  Group getGroup() {
    return _group;
  }

  getPoints() {
    return _points;
  }
  
  getDesc() {
    return _desc;
  }

  getName() {
    return _name;
  }
}

class TaskViewModel extends ChangeNotifier {
  final List<Task> _tasks = [];

  TaskViewModel() {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    _tasks.addAll(await Service.loadTasks());

    notifyListeners();
  }

  isTaskExisting(String taskName, Group? group) {
    if (group == null) {
      return false;
    }
    for (Task task in _tasks) {
      if (task.getName() == taskName && task.getGroup() == group) {
        return true;
      }
    }
    return false;
  }

  addTask(Task task) {
    _tasks.add(task);
    // task has to be added to db
    notifyListeners();
  }

  bool removeTask(Task task) {
    bool success = false;
    if (_tasks.contains(task)) {
      success = _tasks.remove(task);
    }
    // task has to be deleted on db
    notifyListeners();
    return success;
  }

  List<Task> getAllTasks() {
    return _tasks;
  }
}