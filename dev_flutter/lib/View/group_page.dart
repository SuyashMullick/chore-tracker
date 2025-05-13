import 'package:dev_flutter/ViewModel/group_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  GroupPageState createState() => GroupPageState();
}

class GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GroupViewModel(),
      child: const Padding(
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
    );
  }
}
