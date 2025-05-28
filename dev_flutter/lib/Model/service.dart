import 'package:dev_flutter/ViewModel/calendar_viewmodel.dart';
import 'package:dev_flutter/ViewModel/task_viewmodel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';

const baseURL = 'http://127.0.0.1:8000/api';
// const baseURL = 'http://10.0.2.2:8000/api'; // for android emulator

class PlannedTaskDTO {
  final int id;
  final TaskDTO task;
  final List<UserDTO> assignees;
  final UserDTO assigner;
  final DateTime startTime;
  final int points;
  final PlannedTaskStatus status;

  PlannedTaskDTO({
    required this.id,
    required this.task,
    required this.assignees,
    required this.assigner,
    required this.points,
    required this.status,
    required this.startTime,
  });

  factory PlannedTaskDTO.fromJson(Map<String, dynamic> json) {
    return PlannedTaskDTO(
      id: json['id'],
      task: TaskDTO.fromJson(json['task_template']),
      assignees: [
        UserDTO(id: json['assignee'], name: "User 1"),
      ], // hard coded for now, until backend ready
      assigner: UserDTO.fromJson(json['assigner']),
      points: json['custom_points'],
      status: PlannedTaskStatus.values.firstWhere(
        (e) => e.toString() == 'PlannedTaskStatus.${json['state']}',
        orElse: () => PlannedTaskStatus.open,
      ),
      startTime: json['start_time'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'points': points,
      'task_template': task,
      'assignees': jsonEncode(assignees.map((u) => u.toJson()).toList()),
      'state': status.toString().split('.').last,
      'start_time': startTime,
    };
  }
}

class UserDTO {
  final int id;
  final String name;

  UserDTO({required this.id, required this.name});

  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(id: json['id'], name: json['name']);
  }
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class TaskDTO {
  final int id;
  final int points;
  final String name;
  final GroupDTO group;
  final String? note;

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
      group: GroupDTO(
        // hard coded, temporary
        creatorId: 1,
        name: "SweetHome",
        id: json['group'],
        users: [UserDTO(id: 1, name: 'User1')],
      ),
      //json['members']),
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
  final int? creatorId;
  final List<UserDTO> users;

  GroupDTO({
    required this.id,
    required this.name,
    this.creatorId,
    required this.users,
  });

  factory GroupDTO.fromJson(Map<String, dynamic> json) {
    return GroupDTO(
      id: json['id'],
      name: json['group_name'],
      creatorId: json['creator_id'],
      users: json['members'].map((json) => UserDTO.fromJson(json)).toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_name': name,
      'creator_id': creatorId,
      'members': users,
    };
  }
}

class Service {
  static Future<List<Task>> loadTasks() async {
    const url = '$baseURL/created-tasks/';
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
      log('Error: $e');
      return [];
    }
  }

  static Future<List<PlannedTask>> loadCalendarTasks() async {
    const url = '$baseURL/planned-tasks/';
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
      log('Error: $e');
      return [];
    }
  }

  static Future<bool> createTask(Task task) async {
    const url = '$baseURL/created-tasks/';
    try {
      // Convert domain Task to TaskDTO and then to JSON
      final TaskDTO taskDTO = Task.toDTO(task);
      final Map<String, dynamic> taskJson = taskDTO.toJson();

      // POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(taskJson),
      );

      // Check response status
      if (response.statusCode == 201) {
        task.setId(jsonDecode(response.body)['id']);
        return true;
      } else {
        log('Failed to create task. Status code: ${response.statusCode}');
        log('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      log('Error creating task: $e');
      return false;
    }
  }

  static Future<bool> createPlannedTask(PlannedTask plannedTask) async {
    const url = '$baseURL/planned-tasks/';

    try {
      // Convert domain PlannedTask to PlannedTaskDTO and then to JSON
      final PlannedTaskDTO plannedTaskDTO = PlannedTask.toDTO(plannedTask);
      final Map<String, dynamic> plannedTaskJson = plannedTaskDTO.toJson();

      // POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(plannedTaskJson),
      );

      // Check response status
      if (response.statusCode == 201) {
        return true;
      } else {
        log('Failed to create planned task. Status: ${response.statusCode}');
        log('Response: ${response.body}');
        return false;
      }
    } catch (e) {
      log('Error creating planned task: $e');
      return false;
    }
  }

  static Future<bool> updatePlannedTaskState(
    PlannedTask plannedTask,
    PlannedTaskStatus newStatus,
  ) async {
    final url = '$baseURL/planned-tasks/${plannedTask.getId()}/';

    try {
      // Create update payload
      final updateData = {'state': newStatus.toString().split('.').last};

      // PATCH request
      final response = await http.patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updateData),
      );

      // Check response status
      if (response.statusCode == 200) {
        return true;
      } else {
        log('Failed to update task state. Status: ${response.statusCode}');
        log('Response: ${response.body}');
        return false;
      }
    } catch (e) {
      log('Error updating task state: $e');
      return false;
    }
  }
}
