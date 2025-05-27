import 'package:dev_flutter/Model/service.dart';
import 'package:dev_flutter/ViewModel/group_viewmodel.dart';
import 'package:flutter/material.dart';


class Task {
  late int _id;
  int? _creatorId;
  late int _points;
  late String _name;
  late Group _group;
  String? _desc;

  factory Task.fromDTO(TaskDTO task) {
    return Task(
      name: task.name,
      id: task.id,
      group: Group.fromDTO(task.group),
      points: task.points,
      desc: task.note,
      creatorId: task.creatorId,
    );
  }

  static TaskDTO toDTO(Task task) {
    return TaskDTO(
      id: task._id,
      points: task._points,
      name: task._name,
      note: task._desc,
      creatorId: task._creatorId,
      group: Group.toDTO(task._group),
    );
  }

  Task({required String name, required Group group, required points, required id, desc, creatorId}) {
    _desc = desc;
    _id = id;
    _name = name;
    _group = group;
    _creatorId = creatorId;
    setPoints(points);
  }

  void setId(int id) {
    _id = id;
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

  int getPoints() {
    return _points;
  }
  
  String? getDesc() {
    return _desc;
  }

  String getName() {
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

  bool isTaskExisting(String taskName, Group? group) {
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

  Future<bool> addTask(Task task) async {
    _tasks.add(task);
    // add task to db
    bool success = await Service.createTask(task);
    notifyListeners();

    return success;
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