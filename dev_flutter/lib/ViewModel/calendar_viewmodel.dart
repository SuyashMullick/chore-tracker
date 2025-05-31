import 'dart:collection';
import 'package:dev_flutter/Model/service.dart';
import 'package:dev_flutter/ViewModel/group_viewmodel.dart';
import 'package:dev_flutter/ViewModel/task_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:weekview_calendar/weekview_calendar.dart';

int getHashCode(DateTime date) {
  return DateTime(date.year, date.month, date.day).hashCode;
}

class CalendarViewModel extends ChangeNotifier {
  final LinkedHashMap<DateTime, List<PlannedTask>> _tasks =
      LinkedHashMap(equals: isSameDay, hashCode: getHashCode);

  CalendarViewModel() {
    _loadCalendar();
  }

  List<PlannedTask> getUnfinishedTasksForDay(DateTime day) {
    return getPlannedTasksForDay(day).where((task) {
      return task._status != PlannedTaskStatus.finished;
    }).toList();
  }

  void updateStatusOfTask(PlannedTask plannedTask, PlannedTaskStatus status) {
    Service.updatePlannedTaskState(plannedTask, status);
    plannedTask.setStatus(status);

    notifyListeners();
  }

  Future<void> planTask(DateTime date, Task task, List<User> assignees,
      User assigner, points) async {
    if (_tasks[date] == null) {
      _tasks[date] = [];
    }
    PlannedTask tempPlannedTask = PlannedTask(
        id: 0, // temp ID
        startTime: date,
        task: task,
        assignees: assignees,
        assigner: assigner,
        points: points);

    _tasks[date]?.add(tempPlannedTask);
    notifyListeners();

    PlannedTask? savedPlannedTask =
        await Service.createPlannedTask(tempPlannedTask);
    if (savedPlannedTask == null) {
      _tasks[date]?.remove(tempPlannedTask);
      notifyListeners();
      return;
    }

    int index = _tasks[date]!.indexOf(tempPlannedTask);
    _tasks[date]![index] = savedPlannedTask;
    notifyListeners();
  }

  void removeTask(DateTime date, PlannedTask task) {
    if (_tasks[date] == null) {
      return;
    }
    _tasks[date]?.remove(task);

    notifyListeners();
  }

  List<PlannedTask> getPlannedTasksForDay(DateTime day) {
    return _tasks[day] ?? [];
  }

  Future<void> _loadCalendar() async {
    List<PlannedTask> plannedTasks = await Service.loadCalendarTasks();
    for (PlannedTask plannedTask in plannedTasks) {
      if (_tasks[plannedTask._startTime] == null) {
        _tasks[plannedTask._startTime] = [];
      }
      _tasks[plannedTask._startTime]?.add(plannedTask);
    }

    notifyListeners();
  }
}

enum PlannedTaskStatus {
  open,
  done,
  finished,
}

class PlannedTask {
  late final Task _task;
  late final int _id;
  late final List<User> _assignees;
  late final User _assigner;
  PlannedTaskStatus _status = PlannedTaskStatus.open;
  late int _points;
  late final DateTime _startTime;

  factory PlannedTask.fromDTO(PlannedTaskDTO plannedtaskDTO) {
    return PlannedTask(
      id: plannedtaskDTO.id,
      assignees: plannedtaskDTO.assignees
          .map((userDto) => User.fromDTO(userDto))
          .toList(),
      assigner: User.fromDTO(plannedtaskDTO.assigner),
      task: Task.fromDTO(plannedtaskDTO.task),
      points: plannedtaskDTO.points,
      startTime: plannedtaskDTO.startTime,
      status: plannedtaskDTO.status,
    );
  }

  static PlannedTaskDTO toDTO(PlannedTask plannedTask) {
    return PlannedTaskDTO(
      id: plannedTask._id,
      task: Task.toDTO(plannedTask._task),
      points: plannedTask._points,
      assignees:
          plannedTask._assignees.map((user) => User.toDTO(user)).toList(),
      assigner: User.toDTO(plannedTask._assigner),
      status: plannedTask._status,
      startTime: plannedTask._startTime,
    );
  }

  PlannedTask(
      {required int id,
      required List<User> assignees,
      required assigner,
      required Task task,
      required int points,
      required DateTime startTime,
      status}) {
    _id = id;
    _task = task;
    _assignees = assignees;
    _assigner = assigner;
    _points = points;
    _startTime = startTime;
    if (status != null) {
      _status = status;
    }
  }

  int getId() {
    return _id;
  }

  PlannedTaskStatus getStatus() {
    return _status;
  }

  void setStatus(PlannedTaskStatus status) {
    _status = status;
  }

  String getName() {
    return _task.getName();
  }
}
