import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:le_chef/Models/Quiz.dart' as quizModel;
import '../../utils/apiendpoints.dart';
import '../../Models/Quiz.dart';
import '../../Screens/user/examResultbyID.dart';
import '../../main.dart';

class QuizService {
  static Future<void> addQuiz({
    required String title,
    required List<dynamic> questions,
    required int hours,
    required int minutes,
    required int? level,
    required int? unit,
    required bool isPaid,
    double? amountToPay,
  }) async {
    if (questions.isEmpty) {
      throw Exception('Questions list cannot be empty');
    }

    if (isPaid && amountToPay == null) {
      throw Exception('Amount to pay is required for paid quizzes');
    }

    final formattedQuestions = questions.map((question) {
      if (question is QuizQuestion) {
        return question.toJson();
      } else if (question is Map<String, dynamic>) {
        return {
          'question': question['question'] ?? '',
          'options': question['options'] ?? [],
          'answer': question['answer'] ?? '',
        };
      } else {
        throw Exception('Invalid question format');
      }
    }).toList();

    final body = jsonEncode({
      'title': title,
      'questions': formattedQuestions,
      'hours': hours,
      'minutes': minutes,
      'educationLevel': level,
      'Unit': unit,
      'paid': isPaid,
      if (isPaid) 'amountToPay': amountToPay,
    });

    final url =
        Uri.parse('${ApiEndPoints.baseUrl.trim()}${ApiEndPoints.quiz.addQuiz}');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'token': token!,
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print('${jsonDecode(response.body)['message']}');
    } else {
      print('${jsonDecode(response.body)['message']}');
    }
  }

  static Future<List<quizModel.Quiz>> getAllQuizzes(String tokenTHome) async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl.trim() + ApiEndPoints.quiz.getAllQuizzes);
    http.Response response = await http.get(url,
        headers: {'Content-Type': 'application/json', 'token': tokenTHome!});

    var data = jsonDecode(response.body);

    List temp = [];
    print('apiiii Get Exams $data');

    for (var i in data) {
      temp.add(i);
    }

    return quizModel.Quiz.itemsFromSnapshot(temp);
  }

  static Future<List> getExamUnits() async {
    var url =
        Uri.parse(ApiEndPoints.baseUrl.trim() + ApiEndPoints.quiz.getExamUnits);
    http.Response response = await http.get(url,
        headers: {'Content-Type': 'application/json', 'token': token!});

    var data = jsonDecode(response.body);

    List temp = [];
    print('apiiii Get all Units $data');

    // Access the 'units' list inside 'data'
    if (data.containsKey('units') && data['units'] is List) {
      temp = data['units'];
    } else {
      throw Exception(
          "Unexpected data format: 'units' key not found or is not a list.");
    }

    return temp;
  }

  //14-Delete quiz
  static Future<void> delQuiz(String id) async {
    var url = Uri.parse(
        '${ApiEndPoints.baseUrl.trim()}${ApiEndPoints.quiz.delQuiz}$id');
    http.Response response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json', 'token': token!},
    );
    if (response.statusCode == 200) {
      print('${jsonDecode(response.body)['message']}');
    } else {
      print('${jsonDecode(response.body)['message']}');
    }
  }

  //15-update quiz
  static Future<void> updateQuiz({
    required String id,
    required List<dynamic> questions,
    required int hours,
    required int minutes,
  }) async {
    final Map<String, dynamic> body = {
      'questions': questions
          .map((q) => {
                'question': q['question'],
                'options': q['options'],
                'answer': q['answer'],
              })
          .toList(),
      'hours': hours,
      'minutes': minutes,
    };

    var url = Uri.parse(
        '${ApiEndPoints.baseUrl.trim()}${ApiEndPoints.quiz.updateQuiz}$id');

    http.Response response = await http.put(url,
        headers: {'Content-Type': 'application/json', 'token': token!},
        body: jsonEncode(body));
    if (response.statusCode == 200) {
      print('${jsonDecode(response.body)['message']}');
    } else {
      print('${jsonDecode(response.body)['message']}');
    }
  }

  static Future<Map<String, dynamic>> submitQuiz(
    quizModel.Quiz quiz,
    answers,
    String quizID,
  ) async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl.trim() + ApiEndPoints.quiz.submitQuiz + quizID);

    http.Response response = await http.post(url,
        headers: {'Content-Type': 'application/json', 'token': token!},
        body: jsonEncode({'answers': answers}));

    if (response.statusCode == 201) {
      Get.to(ExamResult(
        answers: answers,
        quiz_result: jsonDecode(response.body),
        quiz: quiz,
      ));
      return jsonDecode(response.body);
    } else {
      throw Exception(
        showDialog(
            context: Get.context!,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/error-16_svgrepo.com.jpg',
                      width: 117,
                      height: 117,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Warning!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ibmPlexMono(
                        color: const Color(0xFF164863),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${jsonDecode(response.body)['message'] ?? 'Failed to submit quiz'}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ibmPlexMono(
                        color: const Color(0xFF888888),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }),
      );
    }
  }

  static Future<List<String>> getSubmittedQuizIds() async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl.trim() + ApiEndPoints.quiz.submittedQuizs);
    http.Response response = await http.get(url,
        headers: {'Content-Type': 'application/json', 'token': token!});

    if (response.statusCode == 200) {
      print('success exam  ${json.decode(response.body)}');
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> quizIds = data['quizIds'];
      return quizIds.cast<String>();
    } else if (response.statusCode == 404) {
      throw Exception('No submitted quizzes found');
    } else {
      throw Exception('Failed to load submitted quiz IDs');
    }
  }

  static Future<Map<String, dynamic>> getQuizById(String quizId) async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl.trim() + ApiEndPoints.quiz.Quizbyid + quizId);

    print('Fetching quiz from URL: $url');

    http.Response response = await http.get(url,
        headers: {'Content-Type': 'application/json', 'token': token!});

    if (response.statusCode == 200) {
      print('Response body for quiz $quizId: ${response.body}');
      final Map<String, dynamic> quizData = json.decode(response.body);

      // Extract fields with fallbacks
      final String title = quizData['title'] ?? 'Untitled Quiz';
      final int questionsLength =
          (quizData['questions'] as List<dynamic>?)?.length ?? 0;
      final int minutes = quizData['duration']?['minutes'] ?? 0;
      final int hours = quizData['duration']?['hours'] ?? 0;
      final String duration = '${hours}h ${minutes}m';

      return {
        'id': quizId,
        'title': title,
        'questionsLength': questionsLength,
        'duration': duration,
      };
    } else {
      print(
          'Failed to fetch quiz $quizId. Status code: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Failed to load quiz details');
    }
  }

  static Future<List<Map<String, dynamic>>> getQuizzesByIds(
      List<String> quizIds) async {
    final List<Map<String, dynamic>> quizzes = [];

    if (quizIds.isEmpty) {
      print('No quiz IDs provided.');
      return [];
    }

    for (final quizId in quizIds) {
      try {
        print('Fetching quiz with ID: $quizId');
        final quizInfo = await getQuizById(quizId);
        print('Fetched quiz: $quizInfo');
        quizzes.add(quizInfo);
      } catch (e) {
        print('Error fetching quiz $quizId: $e');
      }
    }

    print('Final quizzes list: $quizzes');
    return quizzes;
  }
}
