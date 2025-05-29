import 'package:dev_flutter/ViewModel/group_viewmodel.dart';
import 'package:dev_flutter/ViewModel/task_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer2<TaskViewModel, GroupViewModel>(
        builder: (context, taskViewModel, groupViewModel, _) {
          List<Task> tasks = taskViewModel.getAllTasks();
          List<Widget> widgets = [];
          for (var task in tasks) {
            widgets.add(
              Card(
                child: ListTile(
                  leading: const Icon(Icons.inventory_rounded),
                  title: Text(task.getName()),
                  subtitle: Text(task.getGroup().getName()),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => taskViewModel.removeTask(task),
                  ),
                ),
              ),
            );
          }
          return SizedBox.expand(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: widgets,
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CreateTaskDialog(
                              taskViewModel: taskViewModel,
                              groupViewModel: groupViewModel);
                        },
                      );
                    },
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CreateTaskDialog extends StatefulWidget {
  final TaskViewModel taskViewModel;
  final GroupViewModel groupViewModel;

  const CreateTaskDialog(
      {super.key, required this.taskViewModel, required this.groupViewModel});

  @override
  CreateTaskDialogState createState() => CreateTaskDialogState();
}

class CreateTaskDialogState extends State<CreateTaskDialog> {
  late final TextEditingController _taskDescEditingController;
  late final TextEditingController _taskNameEditingController;
  final _formKey = GlobalKey<FormState>();
  int? _selectedPoints;
  Group? _selectedGroup;

  @override
  void initState() {
    super.initState();
    _taskDescEditingController = TextEditingController();
    _taskNameEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _taskDescEditingController.dispose();
    _taskNameEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        title: const Text('Create a task'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(
            maxLength: 20,
            controller: _taskNameEditingController,
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'A name has to be set';
              }
              if (widget.taskViewModel.isTaskExisting(value, _selectedGroup)) {
                return 'Task with same name already exists';
              }
              return null;
            },
          ),
          DropdownButtonFormField<Group>(
            value: _selectedGroup,
            hint: const Text('Select a group'),
            items: widget.groupViewModel
                .getGroups()
                .map(
                  (group) => DropdownMenuItem(
                    value: group,
                    child: Text(group.getName()),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedGroup = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'A group must be selected';
              }
              return null;
            },
          ),
          TextField(
            maxLength: 100,
            controller: _taskDescEditingController,
            decoration: const InputDecoration(
              labelText: 'Description (optional)',
            ),
            maxLines: 2,
          ),
          DropdownButtonFormField<int>(
            value: _selectedPoints,
            hint: const Text('Points'),
            items: List.generate(
              10,
              (i) {
                int points = i + 1;
                return DropdownMenuItem(
                  value: points,
                  child: Text(points.toString()),
                );
              },
            ),
            onChanged: (value) {
              setState(() {
                _selectedPoints = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Points have to be selected';
              }
              return null;
            },
          )
        ]),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              if (_taskNameEditingController.text.isNotEmpty &&
                  _selectedPoints != null &&
                  _selectedGroup != null) {
                final Task newTask = Task(
                  name: _taskNameEditingController.text,
                  id: 0,
                  points: _selectedPoints,
                  group: _selectedGroup!,
                  desc: _taskDescEditingController.text,
                );
                widget.taskViewModel.addTask(newTask);
                _taskNameEditingController.clear();
                _taskDescEditingController.clear();
                _selectedPoints = null;
                _selectedGroup = null;
                Navigator.of(context).pop();
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
