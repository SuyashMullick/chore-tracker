// ignore_for_file: prefer_const_constructors

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
  // TODO: Change this
  //CalendarFormat _calendarFormat = { "month", "twoWeeks", "week" } as CalendarFormat;

  @override
  Widget build(BuildContext context) {
    return Consumer2<CalendarViewModel, TaskViewModel>(
      builder: (context, calendarViewModel, taskViewModel, _) {
        return Column(
          children: [
            WeekviewCalendar(
              firstDay: DateTime.utc(2010, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              //calendarFormat: _calendarFormat,
              weekNumbersVisible: true,
              // TODO: Change format of calendar to day, week or month, then change in headerstyle
              calendarFormat: CalendarFormat.week, 
              startingDayOfWeek: StartingDayOfWeek.monday,
              selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
              // Change the style of the header of the calendar
              headerStyle: HeaderStyle(
                // "month" -> "week" since we don't have a way to change calendar formats right now
                formatButtonShowsNext: false,
              ),
              calendarStyle: CalendarStyle(
                weekNumberTextStyle: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 90, 90, 90)),
                // Current day is highlighted with a circle
                todayDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                // Selected day is highlighted with a circle
                selectedDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.deepPurple, width: 2.0),
                  color: Colors.transparent,
                ),
                selectedTextStyle: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              eventLoader: (day) =>
                  calendarViewModel.getUnfinishedTasksForDay(day),
              onFormatChanged: (calendarFormat) {
                // TODO: Change here
                //_calendarFormat = calendarFormat;
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
              child: Builder(
                builder: (context) {
                  final tasksForDay =
                      calendarViewModel.getUnfinishedTasksForDay(_selectedDay);

                  return ListView.builder(
                    itemCount: tasksForDay.length + 1,
                    itemBuilder: (context, index) {
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
                                  );
                                },
                              );
                            },
                            child: const Text("Plan new task"),
                          ),
                        );
                      } else {
                        final task = tasksForDay[index];
                        final taskName = task.getName();
                        final status = calendarViewModel.getTaskStatus(
                            _selectedDay, taskName);

                        return Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(10),
                            color: status == "open"
                                ? Colors.white
                                : status == "done"
                                    ? const Color.fromARGB(255, 220, 220, 220)
                                    : Colors.green.shade100,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    taskName,
                                    style: TextStyle(
                                      color: status == "open"
                                          ? Colors.blue
                                          : status == "done"
                                              ? Colors.grey
                                              : Colors.green,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: status,
                                      dropdownColor: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      iconEnabledColor: Colors.black,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      items: {
                                        "open",
                                        "done",
                                        if (status == "done" ||
                                            status == "finished")
                                          "finished",
                                      }.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value[0].toUpperCase() +
                                              value.substring(1)),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        if (newValue != null) {
                                          calendarViewModel.updateTaskStatus(
                                            _selectedDay,
                                            taskName,
                                            newValue,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  );
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
  final DateTime date;

  const PlanTaskDialog(
      {super.key,
      required this.date,
      required this.calendarViewModel,
      required this.taskViewModel});

  @override
  CreateTaskDialogState createState() => CreateTaskDialogState();
}

class CreateTaskDialogState extends State<PlanTaskDialog> {
  late final TextEditingController _taskEditingController;
  final _formKey = GlobalKey<FormState>();
  Task? _selectedTask;

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
            )
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
                    .planTask(widget.date, _selectedTask!, [Member()]);
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
