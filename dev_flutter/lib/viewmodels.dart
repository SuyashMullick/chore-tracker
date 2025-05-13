import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:weekview_calendar/weekview_calendar.dart';

const baseURL = 'http://127.0.0.1:8000/api';

int getHashCode(DateTime date) {
  return DateTime(date.year, date.month, date.day).hashCode;
}

class CalendarViewModel extends ChangeNotifier {
  final LinkedHashMap<DateTime, List<Task>> _tasks =
      LinkedHashMap(equals: isSameDay, hashCode: getHashCode);

  CalendarViewModel() {
    loadCalendar();
  }

  void addTask(date, Task task) {
    if (_tasks[date] == null) {
      _tasks[date] = [];
    }
    _tasks[date]?.add(task);
  }

  void removeTask(date, startTime, endTime, Task task) {
    if (_tasks[date] == null) {
      return;
    }
    _tasks[date]?.remove(task);
  }

  List<Task> getTasksForDay(DateTime day) {
    return _tasks[day] ?? [];
  }

  void loadCalendar() {
    // here later the data would be requested from the server
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    addTask(today.add(const Duration(days: 1)),
        Task(desc: "Vacuum cleaning", creator: Member()));
    addTask(today, Task(desc: "Cooking", creator: Member()));
    addTask(today.subtract(const Duration(days: 3)),
        Task(desc: "Feed the cat", creator: Member()));
    addTask(today.subtract(const Duration(days: 3)),
        Task(desc: "Send invitations for birthday", creator: Member()));
    addTask(today.subtract(const Duration(days: 3)),
        Task(desc: "Drive kids to school", creator: Member()));

    notifyListeners();
  }
}

// to do: make group viewmodel with members and integrate it into tab for group

class Task {
  int? _points;
  String? _desc;
  final List<Member> _assignees = [];
  final Member creator;

  Task({required desc, required this.creator}) {
    _desc = desc;
  }

  getDesc() {
    return _desc;
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
    _tasks.add(Task(creator: Member(), desc: "Cooking"));
    _tasks.add(Task(creator: Member(), desc: "Washing"));
    _tasks.add(Task(creator: Member(), desc: "Planning dinner"));

    notifyListeners();
  }

  List<Task> getAllTasks() {
    return _tasks;
  }
}

class Member {
  final id = 0;
  final name = "";
}

class Group {
  final id = 0;
  final desc = "";
}
