import 'package:dev_flutter/ViewModel/calendar_viewmodel.dart';
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
    return ChangeNotifierProvider(
      create: (context) => CalendarViewModel(),
      child: Column(
        children: [
          Consumer<CalendarViewModel>(
            builder: (context, calendarViewModel, _) {
              return WeekviewCalendar(
                firstDay: DateTime.utc(2010, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: CalendarFormat.week,
                eventLoader: (day) {
                  return calendarViewModel.getTasksForDay(day);
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
              );
            },
          ),
          Expanded(
            child: Consumer<CalendarViewModel>(
              builder: (context, calendarViewModel, _) {
                List<Task> tasksForDay =
                    calendarViewModel.getTasksForDay(_selectedDay);
                return ListView.builder(
                  itemCount: tasksForDay.length,
                  itemBuilder: (context, index) {
                    final task = tasksForDay[index];
                    return ListTile(title: Text(task.getName()));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}