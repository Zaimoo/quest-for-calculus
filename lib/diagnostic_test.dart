import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:quest_for_calculus/model/question_model.dart';
import 'package:quest_for_calculus/my_home_page.dart';

class DiagnosticTest extends StatefulWidget {
  const DiagnosticTest({super.key});

  @override
  State<DiagnosticTest> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<DiagnosticTest> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Question> questions = [];
  int currentQuestionIndex = 0;
  int lives = 3;
  int score = 0;

  void loadQuestions() async {
    QuerySnapshot snapshot = await firestore.collection('diagnostic').get();
    setState(() {
      questions = snapshot.docs
          .map((doc) => Question.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  void moveToNextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  void showWrongAnswerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Wrong Answer!'),
        content: Text('Try again.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void showCorrectAnswerAnimation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Correct Answer!'),
        content: Icon(Icons.check, color: Colors.green, size: 50),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Next Question'),
          ),
        ],
      ),
    );
  }

  void showEndGameDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Your final score: $score'),
              ElevatedButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => MyHomePage(),
                    ),
                    ModalRoute.withName('/homepage'),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void handleAnswer(int choiceIndex) {
    bool isCorrect =
        questions[currentQuestionIndex].correctAnswerIndex == choiceIndex;

    if (isCorrect) {
      setState(() {
        score += questions[currentQuestionIndex].points;
      });
      showCorrectAnswerAnimation();
      moveToNextQuestion();
    } else {
      setState(() {
        lives--;
      });
      showWrongAnswerDialog();
    }

    if (lives == 0) {
      showEndGameDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Diagnostic Test'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Diagnostic Test'),
      ),
      backgroundColor: Colors.grey.shade900,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Lives: $lives',
                    style: TextStyle(
                      fontFamily: 'Rosario',
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Score: $score',
                    style: TextStyle(
                      fontFamily: 'Rosario',
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      child: Image(image: AssetImage('assets/whiteboard.png')),
                    ),
                    Positioned(
                      top: 30,
                      child: Container(
                        width: 400,
                        height: 300,
                        child: Column(
                          children: [
                            Text(
                              'Question ${currentQuestionIndex + 1}/${questions.length}',
                              style: TextStyle(
                                fontFamily: 'Rosario',
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 60),
                            Container(
                              width: 300,
                              height: 200,
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      questions[currentQuestionIndex].question,
                                      style: TextStyle(
                                          fontFamily: 'Rosario', fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Math.tex(
                                      questions[currentQuestionIndex].equation,
                                      mathStyle: MathStyle.text,
                                      textStyle: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Wrap(
                spacing: 10, // Adjust spacing between buttons
                runSpacing: 10, // Adjust spacing between rows
                alignment: WrapAlignment.center, // Center the buttons
                children: questions[currentQuestionIndex]
                    .choices
                    .asMap()
                    .entries
                    .map((entry) {
                  Color buttonColor;
                  switch (entry.key) {
                    case 0:
                      buttonColor = Colors.red;
                      break;
                    case 1:
                      buttonColor = Colors.blue;
                      break;
                    case 2:
                      buttonColor = Colors.green;
                      break;
                    case 3:
                      buttonColor = Colors.yellow;
                      break;
                    default:
                      buttonColor = Colors.grey;
                      break;
                  }
                  return SizedBox(
                    width: 180, // Set button width
                    height: 150, // Set button height
                    child: TextButton(
                      onPressed: () => handleAnswer(entry.key),
                      style: TextButton.styleFrom(
                        backgroundColor: buttonColor, // Set button color
                        foregroundColor: Colors.black,
                        textStyle: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Rosario',
                            fontWeight: FontWeight.w700), // Set text size
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Set border radius
                        ),
                      ),
                      child: Text(entry.value),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
