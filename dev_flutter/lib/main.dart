import 'package:dev_flutter/View/calendar_page.dart';
import 'package:dev_flutter/View/group_page.dart';
import 'package:dev_flutter/View/profile_page.dart';
import 'package:dev_flutter/View/statistics_page.dart';
import 'package:dev_flutter/View/task_page.dart';
import 'package:dev_flutter/ViewModel/calendar_viewmodel.dart';
import 'package:dev_flutter/ViewModel/group_viewmodel.dart';
import 'package:dev_flutter/ViewModel/task_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 122, 84, 186)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color.fromARGB(255, 66, 164, 234),
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

  final List<Widget> backgrounds = [
    Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.png'),
          fit: BoxFit.cover,
        ),
      ),
    ),
    Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.png'),
          fit: BoxFit.cover,
        ),
      ),
    ),
    Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.png'),
          fit: BoxFit.cover,
        ),
      ),
    ),
    Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.png'),
          fit: BoxFit.cover,
        ),
      ),
    ),
    Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.png'),
          fit: BoxFit.cover,
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: const Color.fromARGB(255, 66, 164, 234),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_month_rounded),
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Badge(
                isLabelVisible: false, child: Icon(Icons.inventory_rounded)),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Badge(
                isLabelVisible: false, child: Icon(Icons.castle_rounded)),
            //Icons.castle_rounded
            //Icons.cottage_rounded
            //Icons.group_rounded,
            label: 'Groups',
          ),
          NavigationDestination(
            icon: Badge(
                isLabelVisible: false, child: Icon(Icons.insert_chart_rounded)),
            label: 'Statistics',
          ),
          NavigationDestination(
            icon: Badge(isLabelVisible: false, child: Icon(Icons.badge_rounded)),
            label: 'Profile',
          ),
        ],
      ),
      body: Stack(
        children: [
          backgrounds[currentPageIndex],

          // Adds transition effect when switching pages
          /*AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            child: KeyedSubtree(
              key: ValueKey<int>(currentPageIndex),
              child: backgrounds[currentPageIndex],
            ),
          ),*/
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => CalendarViewModel()),
              ChangeNotifierProvider(create: (_) => TaskViewModel()),
              ChangeNotifierProvider(create: (_) => GroupViewModel()),
            ],
            child: <Widget>[
              const CalendarPage(),
              const TaskPage(),
              const GroupPage(),
              const StatisticsPage(),
              const ProfilePage(),
            ][currentPageIndex],
          ),
        ],
      ),
    );
  }
}
