import 'dart:collection';
import 'dart:convert';
import 'package:dev_flutter/ViewModel/group_viewmodel.dart';
import 'package:dev_flutter/ViewModel/task_viewmodel.dart';
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
        Task(name: "Vacuum cleaning", points: 1, creator: Member()));
    addTask(today, Task(name: "Cooking", points: 1, creator: Member()));
    addTask(today.subtract(const Duration(days: 3)),
        Task(name: "Feed the cat", points: 2, creator: Member()));
    addTask(
        today.subtract(const Duration(days: 3)),
        Task(
            name: "Send invitations for birthday",
            points: 10,
            creator: Member()));
    addTask(today.subtract(const Duration(days: 3)),
        Task(name: "Drive kids to school", points: 1, creator: Member()));

    notifyListeners();
  }
}
