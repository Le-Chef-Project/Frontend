class QuizQuestion {
  final String questionText;
  final List<String> answers;
  final int correctAnswerIndex;

  QuizQuestion({
    required this.questionText,
    required this.answers,
    required this.correctAnswerIndex,
  });
}

final List<QuizQuestion> quizQuestions = [
  QuizQuestion(
    questionText:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum lacus sapien, vulputate quis ex a, pulvinar pellentesque",
    answers: [
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    ],
    correctAnswerIndex: 2,
  ),
  QuizQuestion(
    questionText: "What is 2 + 2?",
    answers: ["3", "4", "5", "6"],
    correctAnswerIndex: 1,
  ),
  // Add more questions here
];
