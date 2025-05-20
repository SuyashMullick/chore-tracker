import 'package:dev_flutter/ViewModel/calendar_viewmodel.dart';
import 'package:dev_flutter/ViewModel/group_viewmodel.dart';
import 'package:dev_flutter/ViewModel/task_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekview_calendar/weekview_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Consumer3<CalendarViewModel, TaskViewModel, GroupViewModel>(
      builder: (context, calendarViewModel, taskViewModel, groupViewModel, _) {
        return Column(
          children: [
            WeekviewCalendar(
              firstDay: DateTime.utc(2010, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: CalendarFormat.week,
              eventLoader: (day) {
                return calendarViewModel.getPlannedTasksForDay(day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: calendarViewModel
                        .getPlannedTasksForDay(_selectedDay)
                        .length +
                    1,
                itemBuilder: (context, index) {
                  final tasksForDay =
                      calendarViewModel.getPlannedTasksForDay(_selectedDay);
                  if (index == tasksForDay.length) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return PlanTaskDialog(
                                  date: _focusedDay,
                                  calendarViewModel: calendarViewModel,
                                  taskViewModel: taskViewModel,
                                  groupViewModel: groupViewModel);
                            },
                          );
                        },
                        child: const Text("Plan new task"),
                      ),
                    );
                  } else {
                    return ListTile(title: Text(tasksForDay[index].getName()));
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class PlanTaskDialog extends StatefulWidget {
  final CalendarViewModel calendarViewModel;
  final TaskViewModel taskViewModel;
  final GroupViewModel groupViewModel;
  final DateTime date;

  const PlanTaskDialog(
      {super.key,
      required this.date,
      required this.calendarViewModel,
      required this.taskViewModel,
      required this.groupViewModel});

  @override
  CreateTaskDialogState createState() => CreateTaskDialogState();
}

class CreateTaskDialogState extends State<PlanTaskDialog> {
  late final TextEditingController _taskEditingController;
  final _formKey = GlobalKey<FormState>();
  Task? _selectedTask;
  List<Member> _selectedMembers = [];

  @override
  void initState() {
    super.initState();
    _taskEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        title: const Text("Plan a task"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.date.toString()),
            DropdownButtonFormField<Task>(
              value: _selectedTask,
              hint: const Text('Select a task'),
              items: widget.taskViewModel
                  .getAllTasks()
                  .map((task) => DropdownMenuItem(
                        value: task,
                        child: Text(task.getName()),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTask = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'A task has to be chosen';
                }
                return null;
              },
            ),
            DropdownButtonFormField(
              onChanged:
                  (x) {}, // This is required but not used in this custom implementation
              items: widget.groupViewModel.getAllMembers().map((member) {
                return DropdownMenuItem(
                  value: member,
                  child: StatefulBuilder(
                    builder: (context, setStateCbx) {
                      return Row(
                        children: [
                          // select/deselect members
                          Checkbox(
                            value: _selectedMembers.contains(member),
                            onChanged: (isSelected) {
                              if (isSelected == true) {
                                _selectedMembers.add(member);
                              } else {
                                _selectedMembers.remove(member);
                              }
                              setStateCbx(() {});
                              setState(() {});
                            },
                          ),
                          const SizedBox(width: 10),
                          Text(member.getName()),
                        ],
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ],
        ),
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
              if (_selectedTask != null) {
                widget.calendarViewModel
                    .planTask(widget.date, _selectedTask!, _selectedMembers);
              }
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
