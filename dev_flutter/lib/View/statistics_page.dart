// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart' as pie;
import 'package:fl_chart/fl_chart.dart' as fl;

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  StatisticsPageState createState() => StatisticsPageState();
}

class StatisticsPageState extends State<StatisticsPage> {
  bool isWeekly = true;

  final List<Map<String, dynamic>> weeklyUsers = [
    {'name': 'Mike', 'points': 100, 'gender': 'Male'},
    {'name': 'Alice', 'points': 90, 'gender': 'Female'},
    {'name': 'Tina', 'points': 60, 'gender': 'Female'},
  ];

  final List<Map<String, dynamic>> monthlyUsers = [
    {'name': 'Mike', 'points': 300, 'gender': 'Male'},
    {'name': 'Alice', 'points': 330, 'gender': 'Female'},
    {'name': 'Tina', 'points': 120, 'gender': 'Female'},
  ];

  final List<int> monthlyWeeks = [100, 150, 200, 300]; // Week1 - Week4


@override
Widget build(BuildContext context) {
  final users = isWeekly ? weeklyUsers : monthlyUsers;
  users.sort((a, b) => b['points'].compareTo(a['points']));

  return Scaffold(
    backgroundColor: Colors.transparent,
    body: Center( 
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 600,
            minHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 248, 241, 249),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ToggleButtons(
                    isSelected: [isWeekly, !isWeekly],
                    onPressed: (index) {
                      setState(() {
                        isWeekly = index == 0;
                      });
                    },
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Weekly'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Monthly'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Leaderboard',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (_, index) {
                        final user = users[index];
                        return ListTile(
                          title: Text(user['name']),
                          trailing: Text('${user['points']} pts'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Statistics',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  if (isWeekly)
                    _buildPieChart(users)
                  else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildPieChart(users)),
                        const SizedBox(width: 20),
                        Expanded(
                            child: SizedBox(
                                height: 200,
                                child: _buildBarChart(monthlyWeeks))),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}


  Widget _buildPieChart(List<Map<String, dynamic>> users) {
    final genderMap = <String, double>{};
    for (var user in users) {
      genderMap[user['gender']] =
          (genderMap[user['gender']] ?? 0) + user['points'].toDouble();
    }

    return pie.PieChart(
      dataMap: genderMap,
      chartRadius: 160,
      chartType: pie.ChartType.ring,
      chartValuesOptions: const pie.ChartValuesOptions(
        showChartValuesInPercentage: true,
      ),
      legendOptions: const pie.LegendOptions(
        legendPosition: pie.LegendPosition.right,
        showLegends: true,
      ),
    );
  }

  Widget _buildBarChart(List<int> weeklyPoints) {
    return fl.BarChart(
      fl.BarChartData(
        barGroups: List.generate(weeklyPoints.length, (index) {
          return fl.BarChartGroupData(
            x: index,
            barRods: [
              fl.BarChartRodData(
                toY: weeklyPoints[index].toDouble(),
                color: Colors.blueAccent,
                width: 20,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }),
        titlesData: fl.FlTitlesData(
          bottomTitles: fl.AxisTitles(
            sideTitles: fl.SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, _) {
                const weekLabels = ['W1', 'W2', 'W3', 'W4'];
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(weekLabels[value.toInt()]),
                );
              },
            ),
          ),
          leftTitles: fl.AxisTitles(
            sideTitles: fl.SideTitles(showTitles: false),
          ),
          topTitles:
              fl.AxisTitles(sideTitles: fl.SideTitles(showTitles: false)),
          rightTitles:
              fl.AxisTitles(sideTitles: fl.SideTitles(showTitles: false)),
        ),
        gridData: fl.FlGridData(show: true),
        borderData: fl.FlBorderData(show: false),
      ),
    );
  }
}
