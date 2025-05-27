import 'package:flutter/material.dart';

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
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile.png'),
            ),
            SizedBox(height: 16),
            Text(
              'User ID: user123',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Gender: Female',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(height: 4),
                    Text('Individual\n40 pts', textAlign: TextAlign.center),
                  ],
                ),
                SizedBox(width: 40),
                Column(
                  children: [
                    SizedBox(height: 4),
                    Text('Teamwork\n25 pts', textAlign: TextAlign.center),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Total Points: 65',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
          ],
        ),
      ),
    ),
  );
}
}