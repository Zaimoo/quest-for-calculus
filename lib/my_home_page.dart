// my_home_page.dart

import 'package:flutter/material.dart';
import 'mastery_levels.dart';
import 'navbar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String currentImage = 'assets/start.png';
  String oldImage = 'assets/start.png';
  bool isOldImage = true;

  void toggleImage() {
    setState(() {
      currentImage = isOldImage ? 'assets/start-pressed.png' : oldImage;
      isOldImage = !isOldImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Quest of Calculus',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Rosario',
              fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.blue.shade900,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/main-menu.png'),
            ),
            const SizedBox(height: 20),
            TextButton(
              style:
                  TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
              onPressed: () {
                toggleImage();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MasteryLevels()),
                );
              },
              child: Image.asset(currentImage),
            ),
          ],
        ),
      ),
    );
  }
}
