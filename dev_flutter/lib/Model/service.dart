import 'package:dev_flutter/ViewModel/task_viewmodel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const baseURL = 'http://127.0.0.1:8000/api';

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
      name: json['name'],
      note: json['note'],
      group: GroupDTO.fromJson(json['group']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'points': points,
      'name': name,
      'note': note,
      'group': group.toJson(),
    };
  }
}

class GroupDTO {
  final int id;
  final String name;

  GroupDTO({
    required this.id,
    required this.name,
  });

  factory GroupDTO.fromJson(Map<String, dynamic> json) {
    return GroupDTO(
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
}
