import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return const Card(
      shadowColor: Colors.transparent,
      margin: EdgeInsets.all(8.0),
      child: SizedBox.expand(
        child: Center(child: Text('Profile')),
      ),
    );
  }
}
