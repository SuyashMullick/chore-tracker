import 'package:dev_flutter/Model/service.dart';
import 'package:dev_flutter/ViewModel/group_viewmodel.dart';
import 'package:flutter/material.dart';


class PlannedTask {
  late final _task;
  late final List<User> _assignees;

  PlannedTask({required assignees, required task}) {
    _task = task;
    _assignees = assignees;
  }

  getName() {
    return _task.getName();
  }
}

class Task {
  late int _points;
  late String _name;
  late Group _group;
  String? _desc;

  factory Task.fromDTO(TaskDTO task, GroupDTO group) {
    return Task(
      name: task.name,
      group: Group(desc: group.name),
      points: task.points,
      desc: task.note
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
  List<Task> _tasks = [];

  TaskViewModel() {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    // call service here later

    // for test
    GroupViewModel groupViewModel = GroupViewModel();
    List<Group> groups = groupViewModel.getGroups();
    Group group1 = groups[0];
    Group group2 = groups[1];
    _tasks.add(Task(name: "Cooking", group: group1, points: 4, desc: "Cooking pasta"));
    _tasks.add(Task(name: "Laundry", group: group2, points: 5, desc: "Washing"));
    _tasks.add(Task(name: "Planning", group: group2, points: 1, desc: "Planning dinner"));

    notifyListeners();
  }

  isTaskExisting(String taskName) {
    for (Task task in _tasks) {
      if (task.getName() == taskName) {
        return true;
      }
    }
    return false;
  }

  addTask(Task task) {
    _tasks.add(task);
    // task has to be added to db?
    notifyListeners();
  }

  removeTask(Task task) {
    bool success = false;
    if (_tasks.contains(task)) {
      success = _tasks.remove(task);
    }
    // task has to be deleted on db?
    notifyListeners();
    return success;
  }

  List<Task> getAllTasks() {
    return _tasks;
  }
}