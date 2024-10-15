import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:le_chef/Screens/admin/AddExam.dart';
import 'package:le_chef/Shared/custom_app_bar.dart';
import 'package:le_chef/Shared/custom_elevated_button.dart';

import '../../Models/Quiz.dart';
import '../../theme/custom_button_style.dart';

class AddQuestion extends StatefulWidget {
  final List<QuizQuestion> quizList;

  AddQuestion({required this.quizList});

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _choiceControllers = [
    TextEditingController()
  ];
  int _selectedAnswerIndex = 0;

  void _addChoice() {
    setState(() {
      _choiceControllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFBFAFA),
        appBar: CustomAppBar(title: 'Add Question'),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Container(
              width: 360,
              height: 850,
              decoration: ShapeDecoration(
                color: Color(0xFFFBFAFA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Write The Question',
                    style: TextStyle(
                      color: Color(0xFF164863),
                      fontSize: 14,
                      fontFamily: 'IBM Plex Mono',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: TextField(
                      controller: _questionController,
                      decoration: InputDecoration(
                        hintText: 'Write here...',
                        border: InputBorder.none, // No border
                        focusedBorder:
                            InputBorder.none, // No border when focused
                        enabledBorder:
                            InputBorder.none, // No border when enabled
                      ),
                      maxLines: 3,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Choices',
                    style: TextStyle(
                      color: Color(0xFF164863),
                      fontSize: 16,
                      fontFamily: 'IBM Plex Mono',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: _choiceControllers.asMap().entries.map((entry) {
                      int index = entry.key;
                      TextEditingController controller = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 8),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              hintText: 'Choice ${index + 1}',
                              border: InputBorder.none, // No border
                              focusedBorder:
                                  InputBorder.none, // No border when focused
                              enabledBorder: InputBorder.none,
                              // No border when enabled
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: _addChoice,
                      child: Text('Add Choice +',
                          style: TextStyle(color: Colors.white)),
                      style: CustomButtonStyles.fillPrimaryTL5,
                    ),
                  ),
                  SizedBox(height: 70),
                  Text(
                    'Select Correct answer..',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0, // spacing between circles
                    runSpacing: 8.0, // spacing between rows
                    children: List.generate(_choiceControllers.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedAnswerIndex = index;
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: _selectedAnswerIndex == index
                              ? Colors.green
                              : Colors.grey[300],
                          child: Text(
                            String.fromCharCode(65 + index),
                            style: TextStyle(
                              color: _selectedAnswerIndex == index
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      );
                    }),
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(16.0),
          child: CustomElevatedButton(
            onPressed: () {
              if (_questionController.text.isNotEmpty &&
                  _choiceControllers.toList().isNotEmpty &&
                  _selectedAnswerIndex.toString().isNotEmpty) {
                List<String> choices = _choiceControllers
                    .map((controller) => controller.text)
                    .toList();
                QuizQuestion newQuestion = QuizQuestion(
                  questionText: _questionController.text,
                  answers: choices,
                  correctAnswerIndex: _selectedAnswerIndex,
                );

                widget.quizList.add(newQuestion);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddExam(
                      quizList: widget.quizList,
                    ),
                  ),
                );
              }
            },
            text: 'Submit',
            buttonStyle: CustomButtonStyles.fillPrimaryTL5,
          ),
        ),
      ),
    );
  }
}
