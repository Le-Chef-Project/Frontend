import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Widgets/customExamWidgets.dart';
import '../../services/content/quiz_service.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late Future<List<Map<String, dynamic>>> _quizzesFuture;

  @override
  void initState() {
    super.initState();
    _quizzesFuture = fetchQuizzes();
  }

  Future<List<Map<String, dynamic>>> fetchQuizzes() async {
    try {
      // Fetch submitted quiz IDs
      List<String> quizIds = await QuizService.getSubmittedQuizIds();
      print('Fetched Quiz IDs: $quizIds');

      // Fetch quiz details for each ID
      List<Map<String, dynamic>> quizzes =
          await QuizService.getQuizzesByIds(quizIds);
      print('Fetched Quiz Details: $quizzes');
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
      required BuildContext context,
      required String title,
      required int questionsLength,
      required String duration}) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.ibmPlexMono(
          color: const Color(0xFF164863),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
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
