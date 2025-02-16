import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Models/Quiz.dart';
import 'package:le_chef/Screens/user/Home.dart';

import '../../Models/Result.dart';
import '../../Models/Result.dart';
import '../../Models/Result.dart';
import '../../Widgets/customExamWidgets.dart';
import '../../services/content/quiz_service.dart';
import 'examResultbyID.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late Future<List<Map<String, dynamic>>> _quizzesFuture;
  bool isLoading = true;
  String errorMessage = '';

  QuizData? quizData;

  @override
  void initState() {
    super.initState();
    _quizzesFuture = fetchQuizzes();
  }

  void _fetchAndNavigate(String quizId, Quiz quiz) async {
    try {
      // Fetch quiz data
      quizData = await QuizService.getQuizResult(quizId);

      // Update the UI to indicate loading is complete
      setState(() {
        isLoading = false;
      });
      final selectedOptionsMap =
          quizData!.selectedOptions.map((option) => option.toMap()).toList();

      // Navigate to the result page with the fetched result
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExamResult(
            truee: false,
            quiz: quiz,
            quiz_result: quizData!.quizData as Map<String, dynamic>,
            answers: selectedOptionsMap, // Corrected field name
          ),
        ),
      );
    } catch (e) {
      // Handle errors (e.g., show a snackbar or dialog)
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
      print('Error fetching quiz result: $errorMessage');
      // Show a SnackBar with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching quiz result: $errorMessage')),
      );
    }
  }

  Future<List<Map<String, dynamic>>> fetchQuizzes() async {
    try {
      // Fetch submitted quiz IDs
      List<String> quizIds = await QuizService.getSubmittedQuizIds();
      print('Fetched Quiz IDs: $quizIds');

      // Fetch quiz details for each ID
      List<Map<String, dynamic>> quizzes =
          await QuizService.getQuizzesByIds(quizIds);
      print('Fetching Quiz Details: $quizzes');
      return quizzes;
    } catch (e) {
      print('Error fetching quizzes: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _quizzesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load quizzes.',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Center(
              child: Text('No quizzes available.'),
            );
          } else if (snapshot.hasData) {
            final quizzes = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: quizzes.length,
              itemBuilder: (context, index) {
                final exam = quizzes[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBFAFA),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ExamListTile(
                        quiz: exam['quiz'],
                        questionsLength: exam['questionsLength'],
                        id: exam['id'],
                        title: exam['title'],
                        duration: exam['duration'],
                        context: context),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text('Unexpected error occurred.'),
            );
          }
        },
      ),
    );
  }

  ExamListTile(
      {required String id,
      required Quiz quiz,
      required BuildContext context,
      required String title,
      required int questionsLength,
      required String duration}) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.ibmPlexMono(
              color: const Color(0xFF164863),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
              onPressed: () {
                _fetchAndNavigate(id, quiz);
              },
              icon: const Icon(
                Icons.arrow_forward_ios,
              )),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            customExamContainer(
              questionsLength.toString(),
              questionsLength == 1 ? 'Question' : 'Questions',
            ),
            customExamContainer(
              duration ?? 'N/A',
              'Duration',
            ),
          ],
        ),
      ),
      onTap: () {},
    );
  }
}
