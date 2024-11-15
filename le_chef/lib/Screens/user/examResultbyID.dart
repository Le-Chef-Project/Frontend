import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Models/Quiz.dart';
import 'package:le_chef/Shared/custom_app_bar.dart';

import '../../Widgets/score.dart';

class ExamResult extends StatefulWidget {
  final Map<String, dynamic> quiz_result;
  final Quiz quiz;
  const ExamResult({
    super.key,
    required this.quiz_result,
    required this.quiz,
  });

  @override
  State<ExamResult> createState() => _ExamResultState();
}

class _ExamResultState extends State<ExamResult> {
  List unanswerQuestions = [];
  List correctQuestions = [];
  List wrongQuestions = [];
  int selectedQuestion = 0;
  double boxSize = 30.0;
  void navigateToQuestion(int newIndex) {
    if (newIndex >= 0 && newIndex < widget.quiz.questions.length) {
      setState(() {
        selectedQuestion = newIndex;
      });
    }
  }

  void addunanswerQuestions() {
    unanswerQuestions = widget.quiz_result['questionStatuses']
        .where((question) => question['status'] == 'unanswered')
        .map((question) => question['questionId'])
        .toList();
  }

  void addcorrectQuestions() {
    correctQuestions = widget.quiz_result['questionStatuses']
        .where((question) => question['status'] == 'correct')
        .map((question) => question['questionId'])
        .toList();
  }

  void addwrongQuestions() {
    wrongQuestions = widget.quiz_result['questionStatuses']
        .where((question) => question['status'] == 'wrong')
        .map((question) => question['questionId'])
        .toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addunanswerQuestions();
    addcorrectQuestions();
    addwrongQuestions();
  }

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
            const SizedBox(
              height: 20,
            ),
            // Question boxes
            Container(
              width: 360,
              height: 160,
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                // Disable scrolling
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10,
                  childAspectRatio: 1,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: widget.quiz.questions.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedQuestion = index;
                      });
                    },
                    child: Container(
                      width: boxSize,
                      height: boxSize,
                      decoration: ShapeDecoration(
                        color: selectedQuestion == index
                            ? const Color(0xFF427D9D)
                            : const Color(0xFFF1F2F6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                              color: selectedQuestion == index
                                  ? Colors.white
                                  : const Color(0xFF888888),
                              fontSize: 12),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  Container(
                    width: 48.28,
                    height: 46,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF1F2F6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    child: IconButton(
                      onPressed: selectedQuestion > 0
                          ? () {
                              setState(() {
                                selectedQuestion--;
                                navigateToQuestion(selectedQuestion);
                              });
                            }
                          : null,
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: selectedQuestion > 0
                            ? const Color(0xFF888888)
                            : const Color(0xFFCCCCCC), // Disabled color
                      ),
                    ),
                  ),
                  // Forward button
                  Container(
                    width: 48.28,
                    height: 46,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF1F2F6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    child: IconButton(
                      onPressed:
                          selectedQuestion < widget.quiz.questions.length - 1
                              ? () {
                                  setState(() {
                                    selectedQuestion++;
                                    navigateToQuestion(selectedQuestion);
                                  });
                                }
                              : null,
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color:
                            selectedQuestion < widget.quiz.questions.length - 1
                                ? const Color(0xFF888888)
                                : const Color(0xFFCCCCCC), // Disabled color
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        width: 500,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: ShapeDecoration(
                          color: Colors.grey[100],
                          /* unanswerQuestions.contains(
                                  widget.quiz.questions[selectedQuestion].id)
                              ? Colors.yellow
                              : correctQuestions.contains(widget
                                      .quiz.questions[selectedQuestion].id)
                                  ? Colors.green
                                  : Colors.red,*/
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Text(
                                  widget.quiz.questions[selectedQuestion]
                                      .questionText,
                                  style: GoogleFonts.ibmPlexMono(
                                    color: const Color(0xFF164863),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12.0),
                            ...widget.quiz.questions[selectedQuestion].options
                                .asMap()
                                .entries
                                .map((entry) {
                              int answerIndex = entry.key;
                              String answerText = entry.value;
                              // Using numeric index (1-based) instead of letters
                              String indexNumber = (answerIndex + 1).toString();
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: answerIndex ==
                                            widget
                                                .quiz
                                                .questions[selectedQuestion]
                                                .options
                                                .indexOf(widget
                                                    .quiz
                                                    .questions[selectedQuestion]
                                                    .answer)
                                        ? unanswerQuestions.contains(widget.quiz
                                                .questions[selectedQuestion].id)
                                            ? Colors.yellow
                                            : correctQuestions.contains(widget
                                                    .quiz
                                                    .questions[selectedQuestion]
                                                    .id)
                                                ? Colors.green
                                                : Colors.red
                                        : Colors.white,
                                  ),
                                  child: ListTile(
                                    leading: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: Colors
                                            .white, // const Color(0xFF164863),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Text(
                                          indexNumber,
                                          style: GoogleFonts.ibmPlexMono(
                                            color: const Color(0xFF164863),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      answerText,
                                      style: GoogleFonts.ibmPlexMono(
                                        color: const Color(0xFF164863),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
