class QuizData {
  final Map<String, dynamic>
      quizData; // Combined quiz summary and question statuses
  final List<SelectedOption> selectedOptions; // Keep selected options separate

  QuizData({
    required this.quizData,
    required this.selectedOptions,
  });

  // Convert the object to a Map (optional, for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'quizData': quizData,
      'selectedOptions': selectedOptions
          .map((option) => option.toMap())
          .toList(), // Convert here
    };
  }
}

class SelectedOption {
  final String questionId;
  final int selectedOption;

  SelectedOption({
    required this.questionId,
    required this.selectedOption,
  });
  // Convert the object to a Map (optional, for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'selectedOption': selectedOption,
    };
  }

  // Factory method to handle null values
  factory SelectedOption.fromMap(Map<String, dynamic> map) {
    return SelectedOption(
      questionId: map['questionId'] ?? 'unknown', // Provide a default value
      selectedOption: map['selectedLetter'] ?? 0, // Provide a default value
    );
  }
}
