import 'dart:convert';

class Quiz {
  final String id;
  final String title;
  final List<QuizQuestion> questions;
  Duration duration;
  final int level;
  final int unit;
  final bool isPaid;
  final DateTime createdAt;
  final double? amountToPay;

  Quiz({
    required this.id,
    required this.title,
    required this.questions,
    required this.duration,
    required this.level,
    required this.unit,
    required this.isPaid,
    required this.createdAt,
    this.amountToPay,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    final durationData = json['duration'] as Map<String, dynamic>? ?? {};
    final hours = (durationData['hours'] ?? 0).toInt();
    final minutes = (durationData['minutes'] ?? 0).toInt();

    return Quiz(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      questions: (json['questions'] as List? ?? [])
          .map((q) => QuizQuestion.fromJson(q))
          .toList(),
      duration: Duration(
        hours: hours,
        minutes: minutes,
      ),
      level: json['educationLevel'] ?? 0,
      unit: json['Unit'] ?? 0,
      isPaid: json['paid'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      amountToPay: json['paid'] == true ? json['amountToPay']?.toDouble() : null,
    );
  }

  static List<Quiz> itemsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      print('Processing snapshot item: $data');
      return Quiz.fromJson(data);
    }).toList();
  }

  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    print('Formatting duration: $duration (hours: $hours, minutes: $minutes)');

    if (hours > 0 && minutes > 0) {
      return '$hours h $minutes m';
    } else if (hours > 0) {
      return '$hours Hours';
    } else {
      return '$minutes Minutes';
    }
  }
}

class QuizQuestion {
  String questionText;
  List<String> options;
  final String answer;
  String? id;

  QuizQuestion({
    required this.questionText,
    required this.options,
    required this.answer,
    this.id,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      questionText: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      answer: json['answer'] ?? '',
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': questionText,
      'options': options,
      'answer': answer,
      '_id': id,
    };
  }
}

class QuizResponse {
  final List<Quiz> quizzes;
  final List<String> quizPaidContentIds;

  QuizResponse({
    required this.quizzes,
    required this.quizPaidContentIds,
  });

  factory QuizResponse.fromJson(Map<String, dynamic> json) {
    return QuizResponse(
      quizzes: (json['quizzes'] as List? ?? [])
          .map((quiz) => Quiz.fromJson(quiz))
          .toList(),
      quizPaidContentIds: List<String>.from(json['quizPaidContentIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quizzes': quizzes.map((quiz) => {
        '_id': quiz.id,
        'title': quiz.title,
        'questions': quiz.questions.map((q) => q.toJson()).toList(),
        'duration': {
          'hours': quiz.duration.inHours,
          'minutes': quiz.duration.inMinutes % 60,
        },
        'educationLevel': quiz.level,
        'Unit': quiz.unit,
        'paid': quiz.isPaid,
        'createdAt': quiz.createdAt.toIso8601String(),
        'amountToPay': quiz.amountToPay,
      }).toList(),
      'quizPaidContentIds': quizPaidContentIds,
    };
  }
}
