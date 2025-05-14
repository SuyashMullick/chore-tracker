import 'dart:convert';
import 'package:dev_flutter/ViewModel/group_viewmodel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


const baseURL = 'http://127.0.0.1:8000/api';

// class PlannedTask {
//   late final _task;
//   late final _date;
//   final List<Member> _assignees = [];

//   PlannedTask({required date, required task}) {
//     _task = task;
//     _date = date;
//   }
// }

class Task {
  late int _points;
  late String _name;
  String? _desc;
  late final Member _creator;

  Task({required name, required creator, required points, desc}) {
    _desc = desc;
    _name = name;
    _creator = creator;
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
    const url = '$baseURL/tasks/';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> tasks = json.decode(response.body);

        print(tasks);
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      print('Error: $e');
    }
    // for test
    _tasks.add(Task(name: "Cooking", creator: Member(), points: 4, desc: "Cooking pasta"));
    _tasks.add(Task(name: "Laundry", creator: Member(), points: 5, desc: "Washing"));
    _tasks.add(Task(name: "Planning", creator: Member(), points: 1, desc: "Planning dinner"));

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