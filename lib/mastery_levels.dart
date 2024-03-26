import 'package:flutter/material.dart';
import 'quiz_game.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MasteryLevels extends StatelessWidget {
  const MasteryLevels({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getMasteryLevel(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // or any other loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          String masteryLevel = snapshot.data!;
          print(masteryLevel);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Mastery Levels'),
              backgroundColor: Colors.blue.shade900,
              foregroundColor: Colors.white,
            ),
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Stack(children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.blue.shade900,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    const Positioned(
                      bottom: 75,
                      left: 35,
                      child: Image(
                        height: 120,
                        image: AssetImage('assets/beginner-brain.png'),
                      ),
                    ),
                    Positioned(
                        top: 130,
                        left: 15,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 51, 51),
                                minimumSize: const Size(170, 40)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const QuizGame(difficulty: 'BEGINNER'),
                                ),
                              );
                            },
                            child: const Text(
                              'BEGINNER',
                              style: TextStyle(
                                  fontFamily: 'Rosario',
                                  fontWeight: FontWeight.w700),
                            )))
                  ]),
                  Stack(children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.blue.shade900,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    const Positioned(
                      bottom: 75,
                      left: 30,
                      child: Image(
                        height: 120,
                        image: AssetImage('assets/intermediate-brain.png'),
                      ),
                    ),
                    Positioned(
                        top: 130,
                        left: 15,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 51, 51),
                                minimumSize: const Size(170, 40)),
                            onPressed: () {
                              if (masteryLevel == 'intermediate' ||
                                  masteryLevel == 'expert') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const QuizGame(
                                        difficulty: 'INTERMEDIATE'),
                                  ),
                                );
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title:
                                              const Text('Difficulty Locked!'),
                                          content: const Text(
                                              "You haven't unlocked this level yet! Please complete the previous levels first!"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('OK'))
                                          ],
                                        ));
                              }
                            },
                            child: const Text(
                              'INTERMEDIATE',
                              style: TextStyle(
                                  fontFamily: 'Rosario',
                                  fontWeight: FontWeight.w700),
                            )))
                  ]),
                  Stack(children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.blue.shade900,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    const Positioned(
                      bottom: 70,
                      left: 35,
                      child: Image(
                        height: 120,
                        image: AssetImage('assets/expert-brain.png'),
                      ),
                    ),
                    Positioned(
                        top: 130,
                        left: 15,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 51, 51),
                                minimumSize: const Size(170, 40)),
                            onPressed: () {
                              if (masteryLevel == 'expert') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const QuizGame(difficulty: 'EXPERT'),
                                  ),
                                );
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title:
                                              const Text('Difficulty Locked!'),
                                          content: const Text(
                                              "You haven't unlocked this level yet! Please complete the previous levels first!"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('OK'))
                                          ],
                                        ));
                              }
                            },
                            child: const Text(
                              'EXPERT',
                              style: TextStyle(
                                  fontFamily: 'Rosario',
                                  fontWeight: FontWeight.w700),
                            )))
                  ]),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<String> getMasteryLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('difficulty') ?? 'beginner';
  }
}
