class Quiz {
  final String id;
  final String title;
  final List<QuizQuestion> questions;
  final Duration duration;
  final DateTime createdAt;

  Quiz({
    required this.id,
    required this.title,
    required this.questions,
    required this.duration,
    required this.createdAt,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['_id'],
      title: json['title'] ?? '',
      questions: (json['questions'] as List)
          .map((q) => QuizQuestion.fromJson(q))
          .toList(),
      duration: Duration(
        hours: json['duration']['hours'] ?? '',
        minutes: json['duration']['minutes'] ?? '',
      ),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'questions': questions.map((q) => q.toJson()).toList(),
      'duration': {
        'hours': duration.inHours,
        'minutes': duration.inMinutes % 60,
      },
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static List<Quiz> itemsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Quiz.fromJson(data);
    }).toList();
  }

}

class QuizQuestion {
  late final String questionText;
  final List<String> options;
  final String answer;

  QuizQuestion({
    required this.questionText,
    required this.options,
    required this.answer,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      questionText: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      answer: json['answer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionText': questionText,
      'options': options,
      'points': answer,
    };
  }
}
