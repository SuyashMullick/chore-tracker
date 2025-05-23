import 'package:dev_flutter/ViewModel/calendar_viewmodel.dart';
import 'package:dev_flutter/ViewModel/task_viewmodel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const baseURL = 'http://127.0.0.1:8000/api';

class PlannedTaskDTO {
  final int id;
  final int points;
  final TaskDTO task;
  final List<UserDTO> assignees;
  final PlannedTaskState state;
  final DateTime startTime;

  PlannedTaskDTO({
    required this.id,
    required this.task,
    required this.points,
    required this.assignees,
    required this.state,
    required this.startTime,
  });

  factory PlannedTaskDTO.fromJson(Map<String, dynamic> json) {
    return PlannedTaskDTO(
      id: json['id'],
      task: TaskDTO.fromJson(json['task_template']),
      points: json['custom_points'],
      assignees: [UserDTO(id: json['assignee_id'], name: "User 1")], // hard coded for now, until backend ready
      state: json['state'],
      startTime: json['start_time'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'points': points,
      'task_template': task,
      'assignees': jsonEncode(assignees.map((u) => u.toJson()).toList()),
      'state': state,
      'start_time': startTime,
    };
  }
}

class UserDTO {
  final int id;
  final String name;

  UserDTO({
    required this.id,
    required this.name,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      id: json['id'],
      name: json['name'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class TaskDTO {
  final int id;
  final int points;
  final String name;
  final GroupDTO group;
  final String note;

  TaskDTO({
    required this.id,
    required this.points,
    required this.name,
    required this.note,
    required this.group,
  });

  factory TaskDTO.fromJson(Map<String, dynamic> json) {
    return TaskDTO(
      id: json['id'],
      points: json['points'],
      name: json['task_name'],
      note: json['description'],
      group: GroupDTO(creatorId: 1, name: "Test group", id: json['group']), // hard coded, temporary
      //GroupDTO.fromJson(json['group']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'points': points,
      'task_name': name,
      'description': note,
      'group': group.id,
    };
  }
}

class GroupDTO {
  final int id;
  final String name;
  final int creatorId;

  GroupDTO({
    required this.id,
    required this.name,
    required this.creatorId,
  });

  factory GroupDTO.fromJson(Map<String, dynamic> json) {
    return GroupDTO(
      id: json['id'],
      name: json['group_name'],
      creatorId: json['creator_id'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_name': name,
      'creator_id': creatorId,
    };
  }
}

class Service {
  static Future<List<Task>> loadTasks() async {
    const url = '$baseURL/tasks/';
    try {
      final response = await http.get(Uri.parse(url));
      List<Task> tasks = [];

      if (response.statusCode == 200) {
        List<dynamic> tasksJson = json.decode(response.body);
        for (var taskJson in tasksJson) {
          TaskDTO taskDTO = TaskDTO.fromJson(taskJson);
          Task task = Task.fromDTO(taskDTO);
          tasks.add(task);
        }
        return tasks;
      
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

   static Future<List<PlannedTask>> loadCalendarTasks() async {
    const url = '$baseURL/plannedTasks/';
    try {
      final response = await http.get(Uri.parse(url));
      List<PlannedTask> plannedTasks = [];

      if (response.statusCode == 200) {
        List<dynamic> tasksJson = json.decode(response.body);
        for (var taskJson in tasksJson) {
          PlannedTaskDTO taskDTO = PlannedTaskDTO.fromJson(taskJson);
          PlannedTask task = PlannedTask.fromDTO(taskDTO);
          plannedTasks.add(task);
        }
        return plannedTasks;
      
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
    return [];
  }

  static void createTask(Task task) async {
    // make task to TaskDTO, then use toJson, then send put request

  //   final response = await http.post(
  //   url,
  //   headers: {
  //     'Content-Type': 'application/json',
  //   },
  //   body: json.encode(task.toJson()),  // Convert to JSON string
  // );

  }

  static void createPlannedTask(PlannedTask plannedTask) async {


  }

  static void updatePlannedTaskState(PlannedTask plannedTask) async {
    // mark as done, finished
  }
}
