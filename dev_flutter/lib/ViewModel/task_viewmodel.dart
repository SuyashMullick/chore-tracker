import 'dart:convert';
import 'package:dev_flutter/ViewModel/group_viewmodel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


const baseURL = 'http://127.0.0.1:8000/api';

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