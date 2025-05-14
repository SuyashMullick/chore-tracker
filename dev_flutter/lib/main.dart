import 'package:dev_flutter/View/calendar_page.dart';
import 'package:dev_flutter/View/group_page.dart';
import 'package:dev_flutter/View/profile_page.dart';
import 'package:dev_flutter/View/statistics_page.dart';
import 'package:dev_flutter/View/task_page.dart';
import 'package:dev_flutter/ViewModel/calendar_viewmodel.dart';
import 'package:dev_flutter/ViewModel/task_viewmodel.dart';
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
        const CalendarPage(),
        const TaskPage(),
        const GroupPage(),
        const StatisticsPage(),
        const ProfilePage(),
      ][currentPageIndex],
    );
  }
}
