import 'package:dev_flutter/ViewModel/group_viewmodel.dart';
import 'package:dev_flutter/ViewModel/task_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  TaskPageState createState() => TaskPageState();
}

class TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskViewModel(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TaskViewModel>(
          builder: (context, taskViewModel, _) {
            List<Task> tasks = taskViewModel.getAllTasks();
            List<Widget> widgets = [];
            for (var task in tasks) {
              widgets.add(
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.task),
                    title: Text(task.getDesc()),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => taskViewModel.removeTask(task),
                    ),
                  ),
                ),
              );
            }
            return Stack(
              children: [
                Column(children: widgets),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CreateTaskDialog(taskViewModel: taskViewModel);
                        },
                      );
                    },
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CreateTaskDialog extends StatefulWidget {
  final TaskViewModel taskViewModel;

  const CreateTaskDialog({super.key, required this.taskViewModel});

  @override
  CreateTaskDialogState createState() => CreateTaskDialogState();
}

class CreateTaskDialogState extends State<CreateTaskDialog> {
  late final TextEditingController _taskDescEditingController;
  late final TextEditingController _taskNameEditingController;
  late final TextEditingController _taskPointsController;
  final _formKey = GlobalKey<FormState>();
  int? selectedPoints;

  @override
  void initState() {
    super.initState();
    _taskDescEditingController = TextEditingController();
    _taskNameEditingController = TextEditingController();
    _taskPointsController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        title: const Text('New Task'),
        content: Column(children: [
          TextFormField(
            controller: _taskNameEditingController,
            decoration: const InputDecoration(
              labelText: 'Name of the task',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'A name has to be set';
              }
              return null;
            },
          ),
          TextField(
            controller: _taskDescEditingController,
            decoration: const InputDecoration(
              labelText: 'Description of the task (optional)',
            ),
            maxLines: 2,
          ),
          DropdownButtonFormField<int>(
            value: selectedPoints,
            hint: const Text('Select the points for the task'),
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
                selectedPoints = value;
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
                  selectedPoints != null) {
                final Task newTask = Task(
                  name: _taskNameEditingController.text,
                  points: selectedPoints,
                  creator: Member(),
                  desc: _taskDescEditingController.text,
                );
                widget.taskViewModel.addTask(newTask);
                _taskNameEditingController.clear();
                _taskDescEditingController.clear();
                _taskPointsController.clear();
                selectedPoints = null;
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
