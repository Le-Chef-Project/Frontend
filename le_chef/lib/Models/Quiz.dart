class Quiz {
  final String id;
  final String title;
  final List<QuizQuestion> questions;
  final Duration duration;
  final int level;
  final int unit;
  final bool isPaid;
  final DateTime createdAt;

  Quiz({
    required this.id,
    required this.title,
    required this.questions,
    required this.duration,
    required this.level,
    required this.unit,
    required this.isPaid,
    required this.createdAt,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      questions: (json['questions'] as List? ?? [])
          .map((q) => QuizQuestion.fromJson(q))
          .toList(),
      duration: Duration(
        hours: json['hours'] ?? 0,
        minutes: json['minutes'] ?? 0,
      ),
      level: json['educationLevel'] ?? 0,
      unit: json['Unit'] ?? 0,
      isPaid: json['paid'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'questions': questions.map((q) => q.toJson()).toList(),
      'hours': duration.inHours,
      'minutes': duration.inMinutes % 60,
      'educationLevel': level,
      'Unit': unit,
      'paid': isPaid,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static List<Quiz> itemsFromSnapshot(List snapshot) {
    return snapshot.map((data) => Quiz.fromJson(data)).toList();
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
      'question': questionText,
      'options': options,
      'answer': answer,
    };
  }
}