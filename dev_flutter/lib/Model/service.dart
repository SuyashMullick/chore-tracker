import 'package:http/http.dart' as http;
import 'dart:convert';

const baseURL = 'http://127.0.0.1:8000/api';

class TaskDTO {
  final int id;
  final int points;
  final String name;
  final int groupId;
  final String note;

  TaskDTO({
    required this.id,
    required this.points,
    required this.name,
    required this.note,
    required this.groupId,
  });

  factory TaskDTO.fromJson(Map<String, dynamic> json) {
    return TaskDTO(
      id: json['id'],
      points: json['points'],
      name: json['name'],
      note: json['note'],
      groupId: json['groupId'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'points': points,
      'name': name,
      'note': note,
      'groupId': groupId,
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
  static Future<void> loadTasks() async {
    const url = '$baseURL/tasks/';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> tasksJson = json.decode(response.body);
        
      
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
