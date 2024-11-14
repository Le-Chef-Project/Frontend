import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:le_chef/Shared/custom_app_bar.dart';

import '../../Widgets/score.dart';

class ExamResult extends StatefulWidget {
  final Map<String, dynamic> quiz_result;
  const ExamResult({super.key, required this.quiz_result});

  @override
  State<ExamResult> createState() => _ExamResultState();
}

class _ExamResultState extends State<ExamResult> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Quiz Score'),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              child: QuizScoreCard(
                  correctAnswers: widget.quiz_result['correctAnswers'],
                  wrongAnswers: widget.quiz_result['wrongAnswers'],
                  totalQuestions: widget.quiz_result['totalQuestions'],
                  unanswered: widget.quiz_result['unansweredQuestions']),
            ),
          ],
        ),
      ),
    );
  }
}
