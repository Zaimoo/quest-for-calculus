class Question {
  final String question;
  final List<String> choices;
  final int correctAnswerIndex;
  final int points;
  final String difficulty;
  final String equation;

  Question({
    required this.question,
    required this.equation,
    required this.choices,
    required this.correctAnswerIndex,
    required this.points,
    required this.difficulty,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      question: map['question'],
      equation: map['equation'],
      choices: List<String>.from(map['choices']),
      correctAnswerIndex: map['correctAnswerIndex'],
      points: map['points'],
      difficulty: map['difficulty'],
    );
  }
}
