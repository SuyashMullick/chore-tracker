// ignore_for_file: prefer_const_constructors

import 'package:dev_flutter/ViewModel/calendar_viewmodel.dart';
import 'package:dev_flutter/ViewModel/group_viewmodel.dart';
import 'package:dev_flutter/ViewModel/task_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekview_calendar/weekview_calendar.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  Widget build(BuildContext context) {
    return Consumer3<CalendarViewModel, TaskViewModel, GroupViewModel>(
      builder: (context, calendarViewModel, taskViewModel, groupViewModel, _) {
        return Column(
          children: [
            Container(
              color: Colors.grey.shade100,
              child: WeekviewCalendar(
                firstDay: DateTime.utc(2010, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                weekNumbersVisible: true,
                calendarFormat: _calendarFormat,
                startingDayOfWeek: StartingDayOfWeek.monday,
                selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                // Change the style of the header of the calendar
                headerStyle: HeaderStyle(
                  formatButtonShowsNext: false,
                ),
                calendarStyle: CalendarStyle(
                  weekNumberTextStyle: const TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 90, 90, 90)),
                  // Current day is highlighted with a circle
                  todayDecoration: BoxDecoration(
                    color: const Color.fromARGB(255, 66, 164, 234),
                    shape: BoxShape.circle,
                  ),
                  // Selected day is highlighted with a circle
                  selectedDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: const Color.fromARGB(255, 66, 58, 183),
                        width: 2.0),
                    color: Colors.transparent,
                  ),
                  selectedTextStyle: TextStyle(
                    color: Color.fromARGB(255, 66, 58, 183),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                eventLoader: (day) =>
                    calendarViewModel.getUnfinishedTasksForDay(day),
                onFormatChanged: (calendarFormat) {
                  switch (calendarFormat) {
                    case CalendarFormat.month:
                      setState(() {
                        _calendarFormat = CalendarFormat.month;
                      });
                      break;
                    case CalendarFormat.twoWeeks:
                      setState(() {
                        _calendarFormat = CalendarFormat.twoWeeks;
                      });
                      break;
                    case CalendarFormat.week:
                      setState(() {
                        _calendarFormat = CalendarFormat.week;
                      });
                      break;
                  }
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
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  final tasksForDay = calendarViewModel
                      .getPlannedTasksForDay(_selectedDay)
                      .where((task) =>
                          task.getStatus() != PlannedTaskStatus.finished)
                      .toList()
                    ..sort((a, b) {
                      if (a.getStatus() == PlannedTaskStatus.done &&
                          b.getStatus() != PlannedTaskStatus.done) {
                        return 1;
                      } else if (a.getStatus() != PlannedTaskStatus.done &&
                          b.getStatus() == PlannedTaskStatus.done) {
                        return -1;
                      } else {
                        return 0;
                      }
                    });

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
                                        groupViewModel: groupViewModel);
                                  },
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 4),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 237, 237, 237),
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 237, 237, 237)),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Text("Plan new task",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 66, 58, 183),
                                    )),
                              ),
                            ),
                          );
                        }
                        final task = tasksForDay[index];
                        final taskName = task.getName();
                        final status = task.getStatus();

                        return Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          padding: EdgeInsets.all(2),
                          height: 50.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.shade400, width: 2),
                            borderRadius: BorderRadius.circular(10),
                            color: status == PlannedTaskStatus.open
                                ? Colors.white
                                : status == PlannedTaskStatus.done
                                    ? const Color.fromARGB(184, 240, 240, 240)
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
                                        color: status == PlannedTaskStatus.open
                                            ? Color.fromARGB(255, 47, 144, 183)
                                            : status == PlannedTaskStatus.done
                                                ? Colors.grey
                                                : Colors.green,
                                        fontWeight: FontWeight.bold),
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
                                    child: DropdownButton<PlannedTaskStatus>(
                                      value: status,
                                      dropdownColor: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      iconEnabledColor: Colors.black,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      items: {
                                        PlannedTaskStatus.open,
                                        PlannedTaskStatus.done,
                                        if (status == PlannedTaskStatus.done ||
                                            status ==
                                                PlannedTaskStatus.finished)
                                          PlannedTaskStatus.finished,
                                      }.map((PlannedTaskStatus value) {
                                        return DropdownMenuItem<
                                            PlannedTaskStatus>(
                                          value: value,
                                          child: Text(value.name.toUpperCase()),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        if (newValue != null) {
                                          calendarViewModel.updateStatusOfTask(
                                              task, newValue);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
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
  final _formKey = GlobalKey<FormState>();
  Task? _selectedTask;
  List<User> _selectedMembers = [];
  int? _selectedPoints;
  bool okPressed = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        title: const Text("Plan a task"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(DateFormat('dd.MM.yyyy').format(widget.date)),
            DropdownButtonFormField<Task>(
              value: _selectedTask,
              hint: const Text('Select a task'),
              items: widget.taskViewModel
                  .getAllTasks()
                  .map(
                    (task) => DropdownMenuItem(
                      value: task,
                      child: Text(task.getName()),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMembers = [];
                  _selectedTask = value;
                  _selectedPoints = _selectedTask?.getPoints();
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'A task has to be chosen';
                }
                return null;
              },
            ),
            Stack(
              children: [
                DropdownButtonFormField(
                  onChanged: (x) {},
                  items: _selectedTask != null
                      ? widget.groupViewModel
                          .getGroupMembers(_selectedTask!.getGroup())
                          .map((member) {
                          return DropdownMenuItem(
                            value: member,
                            child: StatefulBuilder(
                              builder: (context, setCbxState) {
                                return Row(
                                  children: [
                                    Checkbox(
                                      value: _selectedMembers.contains(member),
                                      onChanged: (isSelected) {
                                        if (isSelected == true) {
                                          _selectedMembers.add(member);
                                        } else {
                                          _selectedMembers.remove(member);
                                        }
                                        setCbxState(() {});
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
                        }).toList()
                      : [],
                ),
                Positioned(
                  top: 14,
                  child: Text(
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                      color: okPressed && _selectedMembers.isEmpty
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                    _selectedMembers.isEmpty
                        ? 'Select assignees'
                        : _selectedMembers
                            .map((user) => user.getName())
                            .join(' , '),
                  ),
                ),
              ],
            ),
            DropdownButtonFormField<int>(
              value: _selectedPoints,
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
              setState(() => okPressed = true);
              if (!_formKey.currentState!.validate() ||
                  _selectedMembers.isEmpty) {
                return;
              }
              if (_selectedTask != null) {
                widget.calendarViewModel.planTask(widget.date, _selectedTask!,
                    _selectedMembers, _selectedPoints);
              }
              okPressed = false;
              _selectedPoints = null;
              _selectedMembers = [];
              _selectedTask = null;
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
