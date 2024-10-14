import 'package:flutter/material.dart';
import 'package:le_chef/Shared/custom_elevated_button.dart';

import '../../Models/Quiz.dart';
import '../../theme/custom_button_style.dart';
import 'AddQuestion.dart';

class AddExam extends StatefulWidget {
  @override
  _AddExamState createState() => _AddExamState();
}

class _AddExamState extends State<AddExam> {
  final _formKey = GlobalKey<FormState>();
  final _hourController = TextEditingController();
  final _minuteController = TextEditingController();

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  List<QuizQuestion> Add_Quiz_list = [];

  String? _validateHours(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter hours';
    }
    final int? hours = int.tryParse(value);
    if (hours == null || hours < 0 || hours > 23) {
      return 'Enter a valid hour (0-23)';
    }
    return null;
  }

  String? _validateMinutes(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter minutes';
    }
    final int? minutes = int.tryParse(value);
    if (minutes == null || minutes < 0 || minutes > 59) {
      return 'Enter valid minutes (0-59)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select Exam Time'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 48),
              child: Text(
                'Press (+) If you want to add question.',
                style: TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 12,
                  fontFamily: 'IBM Plex Mono',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: double.infinity,
                height: 180,
                padding: const EdgeInsets.all(16),
                decoration:
                    BoxDecoration(color: Color.fromARGB(255, 234, 232, 232)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Exam Time',
                        style: TextStyle(
                          color: Color(0xFF164863),
                          fontSize: 14,
                          fontFamily: 'Heebo',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Hours Input Field
                          SizedBox(
                            width: 80,
                            child: TextFormField(
                              controller: _hourController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Hours',
                                labelStyle: TextStyle(
                                  color: Color(0xFF888888),
                                  fontSize: 12,
                                  fontFamily: 'Heebo',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              validator: _validateHours,
                            ),
                          ),
                          SizedBox(width: 20),
                          // Minutes Input Field
                          SizedBox(
                            width: 80,
                            child: TextFormField(
                              controller: _minuteController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Minutes',
                                labelStyle: TextStyle(
                                  color: Color(0xFF888888),
                                  fontSize: 12,
                                  fontFamily: 'Heebo',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              validator: _validateMinutes,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //question
          ],
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(16.0),
          child: CustomElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final int hours = int.parse(_hourController.text);
                final int minutes = int.parse(_minuteController.text);
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                      title: Text('Selected Time'),
                      content: hours > 0
                          ? Text(
                              'You selected $hours hours and $minutes minutes')
                          : Text('You selected $minutes minutes')),
                );
              }
            },
            text: 'Submit',
            buttonStyle: CustomButtonStyles.fillPrimaryTL5,
          ),
        ),
        floatingActionButton: SizedBox(
          width: 69, // Set the width of the FloatingActionButton
          height: 69, // Set the height of the FloatingActionButton
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddQuestion()),
              );
            },
            backgroundColor: Color(0xFFDDF2FD),
            shape: CircleBorder(),
            child: Icon(
              Icons.add,
              color: Color(0xFF164863),
              size: 44,
            ),
          ),
        ),
      ),
    );
  }
}
