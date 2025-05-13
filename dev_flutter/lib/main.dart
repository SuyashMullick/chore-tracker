import 'package:dev_flutter/viewmodels.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekview_calendar/weekview_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.lightBlue,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_month),
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.task)),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.group)),
            label: 'Groups',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.graphic_eq)),
            label: 'Statistics',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.person)),
            label: 'Profile',
          ),
        ],
      ),
      body: <Widget>[
        /// Calendar
        const WeekViewPage(),

        /// Tasks page
        ChangeNotifierProvider(
          create: (context) => TaskViewModel(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Consumer<TaskViewModel>(builder: (context, taskViewModel, _) {
              List<Task> tasks = taskViewModel.getAllTasks();
              List<Widget> widgets = [];
              for (var task in tasks) {
                widgets.add(Card(
                  child: ListTile(
                      leading: const Icon(Icons.task), title: Text(task.getDesc())),
                ));
              }
              return Column(
                children: widgets,
              );
            }),
          ),
        ),

        /// Group page
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: Icon(Icons.task),
                  title: Text('Member 1'),
                  subtitle: Text('This is a member'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.task),
                  title: Text('Member 2'),
                  subtitle: Text('This is a member'),
                ),
              ),
            ],
          ),
        ),

        /// Statistics page
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
                child: Text('Statistics', style: theme.textTheme.titleLarge)),
          ),
        ),

        /// Profile page
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
                child: Text('Profile', style: theme.textTheme.titleLarge)),
          ),
        ),
      ][currentPageIndex],
    );
  }
}

class WeekViewPage extends StatefulWidget {
  const WeekViewPage({super.key});

  @override
  WeekViewPageState createState() => WeekViewPageState();
}

class WeekViewPageState extends State<WeekViewPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CalendarViewModel(),
      child: Expanded(
        child: Column(
          children: [
            Expanded(
              child: Consumer<CalendarViewModel>(
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
                      return ListTile(title: Text(task.getDesc()));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
