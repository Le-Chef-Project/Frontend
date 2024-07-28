import 'dart:async';

import 'package:flutter/material.dart';
import 'package:le_chef/Screens/chats.dart';
import 'package:le_chef/Shared/customBottomNavBar.dart';
import 'package:le_chef/Shared/custom_elevated_button.dart';

import '../Models/Quiz.dart';
import '../theme/custom_button_style.dart';
import 'Home.dart';
import 'notification.dart';

class ExamForm extends StatefulWidget {
  @override
  State<ExamForm> createState() => _ExamFormState();
}

class _ExamFormState extends State<ExamForm> {
  final Map<int, int?> _selectedAnswers = {};
  Timer? _timer;
  int _start = 50 * 60; // Countdown start value in seconds (50 minutes)
  double _progress = 1.0;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          _timer?.cancel();
        });
      } else {
        setState(() {
          _start--;
          _progress = _start / (50 * 60);
        });
      }
    });
  }

  void _submitAnswers() {
    for (int i = 0; i < quizQuestions.length; i++) {
      final selectedAnswerIndex = _selectedAnswers[i];
      if (selectedAnswerIndex != null) {
        final selectedAnswer = quizQuestions[i].answers[selectedAnswerIndex];
        final correctAnswerIndex = quizQuestions[i].correctAnswerIndex;
        if (selectedAnswerIndex == correctAnswerIndex) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Question ${i + 1}: Correct!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Question ${i + 1}: Wrong. The correct answer is: ${quizQuestions[i].answers[correctAnswerIndex]}')),
          );
        }
      }
    }
    // Optionally, you can reset the selections or navigate to a different page.
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int minutes = (_start ~/ 60);
    int seconds = (_start % 60);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Exam Form'),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Image.asset(
                        'assets/error-16_svgrepo.com.jpg',
                        width: 117,
                        height: 117,
                      ),
                      content: Container(
                        width: 150,
                        height: 80,
                        child: Column(
                          children: [
                            Text(
                              'Warning!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF164863),
                                fontSize: 16,
                                fontFamily: 'IBM Plex Mono',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'If you leave the quiz you will not \n be able to take it again !',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF888888),
                                fontSize: 16,
                                fontFamily: 'IBM Plex Mono',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        Expanded(
                          child: Row(
                            // mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  width: 140.50,
                                  height: 48,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Complete quiz',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'IBM Plex Mono',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF427D9D),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      )),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Container(
                                    width: 140.50,
                                    height: 48,
                                    child: OutlinedButton(
                                        onPressed: () {},
                                        child: Text(
                                          'Leave',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF427D9D),
                                            fontSize: 16,
                                            fontFamily: 'IBM Plex Mono',
                                            fontWeight: FontWeight.w600,
                                            height: 0,
                                          ),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              color: Color(0xFF427D9D)),
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                width: 1,
                                                color: Color(0xFF427D9D)),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ))),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  });
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width:
                            150, // Set the width of the CircularProgressIndicator
                        height:
                            150, // Set the height of the CircularProgressIndicator
                        child: CircularProgressIndicator(
                          value: _progress,
                          strokeWidth: 4,
                          color: Color.fromRGBO(66, 125, 157, 1),
                        ),
                      ),
                      Container(
                        width: 135,
                        height: 135,
                        decoration: ShapeDecoration(
                          gradient: RadialGradient(
                            center: Alignment(0, 1),
                            radius: 0,
                            colors: [Color(0xFF427D9D), Color(0xFF6A96A3)],
                          ),
                          shape: OvalBorder(),
                        ),
                        child: Center(
                          child: Text(
                            '$minutes:${seconds.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontFamily: 'IBM Plex Mono',
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //qize questions
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: quizQuestions.length,
                  itemBuilder: (context, index) {
                    final question = quizQuestions[index];
                    return Container(
                      width: 500,
                      height: 460,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: ShapeDecoration(
                        color: Color.fromRGBO(216, 233, 238, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      margin: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question.questionText,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8.0),
                            ...question.answers.asMap().entries.map((entry) {
                              int answerIndex = entry.key;
                              String answerText = entry.value;
                              return ListTile(
                                title: Text(answerText),
                                leading: Radio<int?>(
                                  value: answerIndex,
                                  groupValue: _selectedAnswers[index],
                                  onChanged: (int? value) {
                                    setState(() {
                                      _selectedAnswers[index] = value;
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                            SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                  child: CustomElevatedButton(
                    height: 50,
                    width: 300,
                    text: "Submit",
                    onPressed: _submitAnswers,
                    buttonStyle: CustomButtonStyles.fillPrimaryTL5,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          onItemTapped: (index) {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Notifications()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Chats()),
                );
                break;
            }
          },
          context: context,
        ),
      ),
    );
  }
}
