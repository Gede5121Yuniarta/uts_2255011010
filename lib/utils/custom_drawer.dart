import 'package:flutter/material.dart';
import 'package:uts_2255011010/screens/cs_screen.dart';
import 'package:uts_2255011010/screens/division_screen.dart';
import 'package:uts_2255011010/screens/priority_screen.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(126, 21, 0, 255),
            ),
            child: Text(
              'Drawer',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.supervised_user_circle),
            title: Text('Customer Service'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const CustomerScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.priority_high),
            title: Text('Priorities Issues'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PriorityScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.diversity_1),
            title: Text('Division Department'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DivisionScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
