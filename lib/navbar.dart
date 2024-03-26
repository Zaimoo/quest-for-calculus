import 'package:flutter/material.dart';
import 'package:quest_for_calculus/diagnostic_test.dart';
import 'package:quest_for_calculus/leaderboard.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Basic Calculus and Practice & Preparation',
              style: TextStyle(fontFamily: 'Rosario'),
            ),
          ),
          const Divider(
            height: 20,
            thickness: 1,
            indent: 10,
            endIndent: 10,
            color: Colors.grey,
          ),
          ListTile(
            leading: const Icon(Icons.video_camera_back),
            title: Text(
              'Tutorials',
              style:
                  TextStyle(fontFamily: 'Rosario', fontWeight: FontWeight.w700),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text(
              ' Take a Diagnostic Test',
              style:
                  TextStyle(fontFamily: 'Rosario', fontWeight: FontWeight.w700),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DiagnosticTest()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.lightbulb),
            title: const Text(
              'Test Results',
              style:
                  TextStyle(fontFamily: 'Rosario', fontWeight: FontWeight.w700),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DiagnosticTest()),
              );
            },
          ),
          const Divider(
            height: 20,
            thickness: 1,
            indent: 10,
            endIndent: 10,
            color: Colors.grey,
          ),
          ListTile(
            leading: const Icon(Icons.leaderboard),
            title: const Text(
              'Leaderboards',
              style:
                  TextStyle(fontFamily: 'Rosario', fontWeight: FontWeight.w700),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Leaderboards()),
              );
            },
          ),
        ],
      ),
    );
  }
}
