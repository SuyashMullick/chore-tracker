import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  StatisticsPageState createState() => StatisticsPageState();
}

class StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return const Card(
      shadowColor: Colors.transparent,
      margin: EdgeInsets.all(8.0),
      child: SizedBox.expand(
        child: Center(child: Text('Statistics')),
      ),
    );
  }
}
