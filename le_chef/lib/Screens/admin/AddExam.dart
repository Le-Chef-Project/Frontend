import 'package:flutter/material.dart';
import 'package:le_chef/Api/apimethods.dart';
import 'package:le_chef/Shared/custom_elevated_button.dart';
import 'package:le_chef/Widgets/dialog_with_two_buttons.dart';
import '../../Models/Quiz.dart';
import '../../theme/custom_button_style.dart';
import 'AddQuestion.dart';

class AddExam extends StatefulWidget {
  final List<QuizQuestion>? quizList;

  AddExam({this.quizList});

  @override
  _AddExamState createState() => _AddExamState();
}

class _AddExamState extends State<AddExam> {
  final _formKey = GlobalKey<FormState>();
  final _hourController = TextEditingController();
  final _minuteController = TextEditingController();
  final TextEditingController TitleController = TextEditingController();

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    TitleController.dispose();
    super.dispose();
  }

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

  // Function to handle submitting the form
  void _submitQuiz() async {
    if (_formKey.currentState!.validate() && TitleController.text.isNotEmpty) {
      String title = TitleController.text;
      List<Map<String, dynamic>> questions = widget.quizList!.map((quiz) {
        return {
          'question': quiz.questionText,
          'options': quiz.answers,
          'answer': quiz.answers[quiz.correctAnswerIndex],
        };
      }).toList();

      int hours = int.parse(_hourController.text);
      int minutes = int.parse(_minuteController.text);

      await ApisMethods.AddQuiz(title, questions, hours, minutes);
    }

    dialogWithButtons(context: context,
        icon: Image.asset('assets/error-16_svgrepo.com.jpg'),
        title: 'Are you sure you finish putting Exam ?',
        button1Text: 'Finish Exam',
        button1Action: () {
            dialogWithButtons(context: context, icon: Icon(Icons.check_circle_outline, color: Colors.green, size: 117,), title: 'Success !', content: 'Exam posted to students.');
            Future.delayed((Duration(seconds: 2)), (){
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            });
            }, button2Text: 'Cancel', button2Action: () => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    final List<QuizQuestion> quizList = widget.quizList ?? [];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Select Exam Time'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Quiz Title',
                      style: TextStyle(
                        color: Color(0xFF164863),
                        fontSize: 14,
                        fontFamily: 'IBM Plex Mono',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: ShapeDecoration(
                        color: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: TextField(
                        controller: TitleController,
                        decoration: InputDecoration(
                          hintText: 'Title',
                          border: InputBorder.none, // No border
                          focusedBorder:
                          InputBorder.none, // No border when focused
                          enabledBorder:
                          InputBorder.none, // No border when enabled
                        ),
                      ),
                    ),
                  ),
                ],
              ),

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
                  decoration: BoxDecoration(color: Colors.grey[100]),
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
              quizList.isNotEmpty
                  ? ListView.builder(
                shrinkWrap: true,
                // Add this line
                physics:
                NeverScrollableScrollPhysics(),
                // Prevents it from scrolling independently
                itemCount: quizList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      color: Colors.grey[100],
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // The main heading
                          Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            // Aligns delete icon to the right

                            children: [
                              Text(
                                '${index + 1}. ${quizList[index].questionText}',
                                style: TextStyle(
                                  color: Color(0xFF164863),
                                  fontSize: 14,
                                  fontFamily: 'IBM Plex Mono',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                              IconButton(
                                icon:
                                Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    widget.quizList!.removeAt(
                                        index); // Remove the question at the given index
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          // The nested ListView with constrained height
                          SizedBox(
                            height:
                            200, // Set a fixed height for the inner ListView
                            child: ListView.builder(
                              shrinkWrap: true, // Add this line as well
                              itemCount: quizList[index].answers.length,
                              itemBuilder: (context, innerIndex) {
                                return _buildListItem(
                                    '${innerIndex + 1}. ${quizList[index]
                                        .answers[innerIndex]}.');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
                  : Center(
                child: Text(
                  'No questions added yet.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(24.0),
          child: CustomElevatedButton(
            onPressed: _submitQuiz,
            // Submit the form and add the quiz
            text: 'Submit',
            buttonStyle: CustomButtonStyles.fillPrimaryTL5,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddQuestion(
                        quizList: quizList,
                      )),
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
    );
  }

  // Helper method to build each list item
  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            text,
            style: TextStyle(
              color: Color(0xFF164863),
              fontSize: 14,
              fontFamily: 'IBM Plex Mono',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
        ),
      ),
    );
  }
}
