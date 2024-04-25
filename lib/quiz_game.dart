import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:quest_for_calculus/leaderboard.dart';
import 'package:quest_for_calculus/model/question_model.dart';
import 'package:quest_for_calculus/my_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizGame extends StatefulWidget {
  final String difficulty;

  const QuizGame({Key? key, required this.difficulty}) : super(key: key);

  @override
  _QuizGameState createState() => _QuizGameState();
}

class _QuizGameState extends State<QuizGame> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Level> levels = [];
  int currentLevelIndex = 0;
  int currentQuestionIndex = 0;
  int lives = 3;
  int score = 0;

  @override
  void initState() {
    super.initState();
    loadLevels();
  }

  void setDifficulty(difficulty) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('difficulty', difficulty);
  }

  void loadLevels() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('questions').get();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString('difficulty') == 'intermediate' ||
          prefs.getString('difficulty') == 'expert' &&
              widget.difficulty == 'INTERMEDIATE') {
        currentLevelIndex = 1;
      } else if (prefs.getString('difficulty') == 'expert' &&
          widget.difficulty == 'EXPERT') {
        currentLevelIndex = 2;
      }

      setState(() {
        List<Question> allQuestions = snapshot.docs
            .map((doc) => Question.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
        levels = _groupQuestionsByDifficulty(allQuestions);
        loadQuestions();
      });
    } catch (e) {
      print(e);
    }
  }

  List<Level> _groupQuestionsByDifficulty(List<Question> questions) {
    Map<String, List<Question>> groupedQuestions = {};
    questions.forEach((question) {
      String difficulty = question.difficulty;
      if (!groupedQuestions.containsKey(difficulty)) {
        groupedQuestions[difficulty] = [];
      }
      groupedQuestions[difficulty]!.add(question);
    });

    return groupedQuestions.entries
        .map((entry) => Level(difficulty: entry.key, questions: entry.value))
        .toList();
  }

  void loadQuestions() {
    List<Question> questions = levels[currentLevelIndex].questions;
    setState(() {
      questions.shuffle();
    });
  }

  void handleAnswer(int choiceIndex) {
    if (lives <= 0) {
      return;
    }

    bool isCorrect = levels[currentLevelIndex]
            .questions[currentQuestionIndex]
            .correctAnswerIndex ==
        choiceIndex;

    if (isCorrect) {
      setState(() {
        score +=
            levels[currentLevelIndex].questions[currentQuestionIndex].points;
      });
      showCorrectAnswerAnimation();
      moveToNextQuestion();
    } else {
      setState(() {
        lives--;
      });
      if (lives > 0) {
        showWrongAnswerDialog();
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => MyHomePage(),
          ),
          ModalRoute.withName('/homepage'),
        );
        showEndGameDialog();
      }
    }
  }

  void moveToNextQuestion() {
    print(levels.length);
    if (currentQuestionIndex < levels[currentLevelIndex].questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      moveToNextLevel();
    }
  }

  void moveToNextLevel() {
    if (currentLevelIndex < levels.length - 1) {
      setState(() {
        currentLevelIndex++;
        currentQuestionIndex = 0;
        loadQuestions();
      });
    } else {
      if (currentLevelIndex == 0) {
        setDifficulty('intermediate');
      } else if (currentLevelIndex == 1) {
        setDifficulty('expert');
      }
      showEndGameDialog();
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
              TextField(
                decoration: InputDecoration(labelText: 'Enter your name'),
                onSubmitted: (name) {
                  saveScore(name);
                  setDifficulty(
                      currentLevelIndex == 1 ? 'intermediate' : 'expert');
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Leaderboards(),
                    ),
                    ModalRoute.withName('/leaderboards'),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void saveScore(String playerName) {
    firestore.collection('leaderboards').doc('$playerName : $score').set({
      'name': playerName,
      'score': score,
    });
  }

  @override
  Widget build(BuildContext context) {
    if (levels.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz Game - ${widget.difficulty}'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Game - ${widget.difficulty}'),
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
                              'Question ${currentQuestionIndex + 1}/${levels[currentLevelIndex].questions.length}',
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
                                      levels[currentLevelIndex]
                                          .questions[currentQuestionIndex]
                                          .question,
                                      style: TextStyle(
                                          fontFamily: 'Rosario', fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Math.tex(
                                      levels[currentLevelIndex]
                                          .questions[currentQuestionIndex]
                                          .equation,
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
                children: levels[currentLevelIndex]
                    .questions[currentQuestionIndex]
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

class Level {
  final String difficulty;
  final List<Question> questions;

  Level({required this.difficulty, required this.questions});

  factory Level.fromMap(Map<String, dynamic> map) {
    return Level(
      difficulty: map['difficulty'],
      questions: List<Question>.from(
          map['questions'].map((question) => Question.fromMap(question))),
    );
  }
}
