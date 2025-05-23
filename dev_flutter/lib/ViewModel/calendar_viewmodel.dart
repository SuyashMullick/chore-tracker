import 'dart:collection';
import 'dart:convert';
import 'package:dev_flutter/ViewModel/group_viewmodel.dart';
import 'package:dev_flutter/ViewModel/task_viewmodel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:weekview_calendar/weekview_calendar.dart';


int getHashCode(DateTime date) {
  return DateTime(date.year, date.month, date.day).hashCode;
}

class CalendarViewModel extends ChangeNotifier {
  final LinkedHashMap<DateTime, List<PlannedTask>> _tasks =
      LinkedHashMap(equals: isSameDay, hashCode: getHashCode);

  final Map<String, String> _taskStatuses = {};

  CalendarViewModel() {
    _loadCalendar();
  }

  String _taskKey(DateTime day, String taskName) {
    final dayString = day.toIso8601String().substring(0, 10);
    return '$dayString|$taskName';
  }

  String getTaskStatus(DateTime day, String taskName) {
    return _taskStatuses[_taskKey(day, taskName)] ?? "open";
  }

  void updateTaskStatus(DateTime day, String taskName, String newStatus) {
    _taskStatuses[_taskKey(day, taskName)] = newStatus;
    notifyListeners();
  }

  List<PlannedTask> getUnfinishedTasksForDay(DateTime day) {
    return getPlannedTasksForDay(day).where((task) {
      final status = getTaskStatus(day, task.getName());
      return status != "finished";
    }).toList();
  }

  void planTask(date, Task task, List<User> assignees) {
    if (_tasks[date] == null) {
      _tasks[date] = [];
    }
    PlannedTask plannedTask = PlannedTask(task: task, assignees: assignees);
    _tasks[date]?.add(plannedTask);

    notifyListeners();
  }

  void removeTask(date, startTime, endTime, PlannedTask task) {
    if (_tasks[date] == null) {
      return;
    }
    _tasks[date]?.remove(task);

    notifyListeners();
  }

  List<PlannedTask> getPlannedTasksForDay(DateTime day) {
    return _tasks[day] ?? [];
  }


  void _loadCalendar() {
    GroupViewModel groupViewModel = GroupViewModel();
    List<Group> groups = groupViewModel.getGroups();
    Group group1 = groups[0];
    Group group2 = groups[1];
    
    // here later the data would be requested from the server
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    planTask(today.add(const Duration(days: 1)),
        Task(name: "Vacuum cleaning", points: 1, group: group1), [User(name: "user123")]);
    planTask(today, Task(name: "Cooking", points: 1, group: group1), [User(name: "user123")]);
    planTask(today.subtract(const Duration(days: 3)),
        Task(name: "Feed the cat", points: 2, group: group1), [User(name: "user123")]);
    planTask(
        today.subtract(const Duration(days: 3)),
        Task(
            name: "Send invitations for birthday",
            points: 10,
           group: group2),  [User(name: "user123")]);
    planTask(today.subtract(const Duration(days: 3)),
        Task(name: "Drive kids to school", points: 1, group: group1), [User(name: "user1")]);

    notifyListeners();
  }
}
