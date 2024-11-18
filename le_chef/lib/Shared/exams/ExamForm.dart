import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Api/apimethods.dart';

import '../../Models/Quiz.dart';
import '../../Widgets/quiz_time.dart';
import '../custom_elevated_button.dart';
import '../../main.dart';

class QuizPage extends StatefulWidget {
  final Quiz quiz;

  const QuizPage({super.key, required this.quiz});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final Map<int, int?> _selectedAnswers = {};
  Timer? _timer;
  int _start = 0;
  double _progress = 1.0;
  String? role = sharedPreferences!.getString('role');
  final TextEditingController _questionController = TextEditingController();
  List<TextEditingController> _answerControllers = [];
  List<Map<String, dynamic>> answers =
      []; // This will store answers for submission
  bool isSubmitted = false;

  final _formKey = GlobalKey<FormState>();
  final _hourOneController = TextEditingController();
  final _hourTwoController = TextEditingController();
  final _minuteOneController = TextEditingController();
  final _minuteTwoController = TextEditingController();
  int count = 0;

  @override
  void initState() {
    super.initState();
    _start = widget.quiz.duration.inSeconds;
    if (role != 'admin') {
      startTimer();
    }
    _questionController.text =
        widget.quiz.questions[selectedQuestion].questionText;
    _answerControllers =
        widget.quiz.questions[selectedQuestion].options.map((answer) {
      return TextEditingController(text: answer);
    }).toList();

    // Add listeners to update the underlying data when text changes
    _questionController.addListener(() {
      widget.quiz.questions[selectedQuestion].questionText =
          _questionController.text;
    });

    for (var i = 0; i < _answerControllers.length; i++) {
      _answerControllers[i].addListener(() {
        widget.quiz.questions[selectedQuestion].options[i] =
            _answerControllers[i].text;
      });
    }
  }

  void updateControllers() {
    _questionController.text =
        widget.quiz.questions[selectedQuestion].questionText;

    for (var controller in _answerControllers) {
      controller.dispose();
    }

    _answerControllers =
        widget.quiz.questions[selectedQuestion].options.map((answer) {
      return TextEditingController(text: answer);
    }).toList();

    for (var i = 0; i < _answerControllers.length; i++) {
      final index = i;
      _answerControllers[i].addListener(() {
        widget.quiz.questions[selectedQuestion].options[index] =
            _answerControllers[index].text;
      });
    }
  }

  void navigateToQuestion(int newIndex) {
    if (newIndex >= 0 && newIndex < widget.quiz.questions.length) {
      setState(() {
        selectedQuestion = newIndex;
        updateControllers();
      });
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          _timer?.cancel();
          if (isSubmitted == false) {
            _submitAnswers();
          }
        });
      } else {
        setState(() {
          _start--;
          _progress = _start / widget.quiz.duration.inSeconds;
        });
      }
    });
  }

  void _submitEdit() async {
    if (role == 'admin') {
      _updateQuizTime();
      print('Current questions state:');
      for (var question in widget.quiz.questions) {
        print('Question: ${question.questionText}');
        print('Options: ${question.options}');
        print('Answer: ${question.answer}');
        print('hours: ${widget.quiz.duration.inHours}');
        print('mint: ${widget.quiz.duration.inMinutes}');
      }
      List<Map<String, dynamic>> questions = widget.quiz.questions.map((quiz) {
        return {
          'question': quiz.questionText,
          'options': quiz.options,
          'answer': quiz.answer,
        };
      }).toList();

      try {
        print('Waiting to update quiz...');
        await ApisMethods.updateQuiz(
          id: widget.quiz.id,
          questions: questions,
          hours: widget.quiz.duration.inHours,
          minutes: widget.quiz.duration.inMinutes,
        );

        print('Updated quiz successfully');

        if (mounted) {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF2ED573),
                  size: 150,
                ),
                title: Text(
                  'Success!',
                  style: GoogleFonts.ibmPlexMono(
                    color: const Color(0xFF164863),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                content: Text(
                  'Exam Updated Successfully',
                  style: GoogleFonts.ibmPlexMono(
                    color: const Color(0xFF888888),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          );

          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pop(context);
            Navigator.pop(context);
          });
        }
      } catch (e) {
        print('Error during update: ${e.toString()}');
        // Show error dialog if widget is still mounted
        if (!mounted) return;

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Failed to update quiz: ${e.toString()}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void _submitAnswers() async {
    print('Submit button pressed');

    // Reset answers list to avoid duplicates
    answers.clear();

    // Check if all questions are answered
    for (int i = 0; i < widget.quiz.questions.length; i++) {
      final selectedAnswerIndex = _selectedAnswers[i];
      /*if (selectedAnswerIndex == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Please answer all questions before submitting')),
        );
        return;
      }*/

      // Add each answer to the answers list
      answers.add({
        'questionId': widget.quiz.questions[i].id,
        'selectedOption':
            selectedAnswerIndex, // Using the selected index directly
      });
    }

    final response =
    ApisMethods.submitQuiz(widget.quiz, answers, widget.quiz.id);
    setState(() {
      isSubmitted = true;
    });

    // At this point, all questions have been answered
    print(' showing answers' '$answers'); // For debugging
  }

  void _updateQuizTime() {
    // Get the individual digits and default to '0' if empty
    String hourFirst = _hourOneController.text.trim().isEmpty
        ? '0'
        : _hourOneController.text.trim();
    String hourSecond = _hourTwoController.text.trim().isEmpty
        ? '0'
        : _hourTwoController.text.trim();
    String minuteFirst = _minuteOneController.text.trim().isEmpty
        ? '0'
        : _minuteOneController.text.trim();
    String minuteSecond = _minuteTwoController.text.trim().isEmpty
        ? '0'
        : _minuteTwoController.text.trim();

    // Calculate hours and minutes
    int hours = int.parse(hourFirst + hourSecond);
    int minutes = int.parse(minuteFirst + minuteSecond);

    // Validate minutes
    if (minutes >= 60) {
      // Add overflow to hours
      hours += minutes ~/ 60;
      minutes = minutes % 60;
    }

    // Calculate total duration in seconds
    final totalSeconds = (hours * 3600) + (minutes * 60);

    setState(() {
      // Update the quiz duration
      widget.quiz.duration = Duration(seconds: totalSeconds);
      // Reset the timer with new duration
      _start = totalSeconds;
      _progress = 1.0;
    });

    // Close the dialog
    Navigator.pop(context);
  }

  String? _validateTime(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Allow empty values as we'll handle them in _updateQuizTime
    }
    final int? digit = int.tryParse(value);
    if (digit == null || digit < 0 || digit > 9) {
      return 'Enter 0-9';
    }
    return null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
    _questionController.dispose();
    for (var controller in _answerControllers) {
      controller.dispose();
    }
  }

  int selectedQuestion = 0;

  @override
  Widget build(BuildContext context) {
    double boxSize = 30.0;

    int minutes = (_start ~/ 60);
    int seconds = (_start % 60);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Exam Form'),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              role == 'admin'
                  ? Navigator.pop(context)
                  : showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          contentPadding: EdgeInsets.zero,
                          title: Image.asset(
                            'assets/error-16_svgrepo.com.jpg',
                            width: 117,
                            height: 117,
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Warning!',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.ibmPlexMono(
                                  color: const Color(0xFF164863),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'If you leave the quiz you will not \nbe able to take it again!',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.ibmPlexMono(
                                  color: const Color(0xFF888888),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      120, // Set a fixed width instead of using Expanded
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF427D9D),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      'Complete quiz',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.ibmPlexMono(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                SizedBox(
                                  width:
                                      120, // Set a fixed width instead of using Expanded
                                  height: 48,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // First, pop the dialog
                                      Navigator.pop(context);
                                      Navigator.pop(
                                          context); // Then, pop the page
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          color: Color(0xFF427D9D)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      'Leave',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.ibmPlexMono(
                                        color: const Color(0xFF427D9D),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      },
                    );
            },
          ),
        ),
        body: Column(
          children: [
            // Timer
            Container(
              width: 317,
              height: 138,
              padding: const EdgeInsets.all(16),
              decoration: ShapeDecoration(
                color: const Color(0xFFFBFAFA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 106,
                    height: 106,
                    padding: const EdgeInsets.only(
                      top: 5,
                      left: 5,
                      right: 4.44,
                      bottom: 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 96.56,
                          height: 97,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 150,
                                height: 150,
                                child: CircularProgressIndicator(
                                  value: _progress,
                                  strokeWidth: 4,
                                  color: const Color.fromRGBO(66, 125, 157, 1),
                                ),
                              ),
                              Container(
                                width: 85,
                                height: 85,
                                decoration: const ShapeDecoration(
                                  gradient: RadialGradient(
                                    center: Alignment(0, 1),
                                    radius: 0,
                                    colors: [
                                      Color(0xFF427D9D),
                                      Color(0xFF6A96A3)
                                    ],
                                  ),
                                  shape: OvalBorder(),
                                ),
                                child: Center(
                                  child: Text(
                                    '$minutes:${seconds.toString().padLeft(2, '0')}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
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
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: SizedBox(
                      height: 102,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const VerticalDivider(
                            color: Color(0xFF888888),
                            thickness: 1,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    role == 'admin'
                                        ? 'Edit Time'
                                        : 'Submit answers',
                                    style: const TextStyle(
                                      color: Color(0xFF888888),
                                      fontSize: 14,
                                      fontFamily: 'IBM Plex Mono',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                CustomElevatedButton(
                                  width: 139,
                                  height: 50,
                                  text: role == 'admin' ? 'Edit' : "Submit",
                                  onPressed: role != 'admin'
                                      ? _submitAnswers
                                      : () {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor: Colors.white,
                                                  title: const Center(
                                                      child: Text(
                                                          'Select new time')),
                                                  titleTextStyle:
                                                      GoogleFonts.ibmPlexMono(
                                                    color: const Color(0xFF164863),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  content: Container(
                                                    width: double.infinity,
                                                    height: 180,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16),
                                                    decoration: ShapeDecoration(
                                                      color: const Color(0xFFFBFAFA),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                    ),
                                                    child: Form(
                                                      key: _formKey,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 14.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                Text(
                                                                  'Hours',
                                                                  style:
                                                                      GoogleFonts
                                                                          .heebo(
                                                                    color: const Color(
                                                                        0xFF888888),
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  'Minutes',
                                                                  style:
                                                                      GoogleFonts
                                                                          .heebo(
                                                                    color: const Color(
                                                                        0xFF888888),
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 15),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              // Hours Input Field
                                                              Expanded(
                                                                child:
                                                                    ScrollableTimeInput(
                                                                  controller:
                                                                      _hourOneController,
                                                                  validator:
                                                                      _validateTime,
                                                                  maxValue:
                                                                      9, // For first minute digit
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 12,
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    ScrollableTimeInput(
                                                                  controller:
                                                                      _hourTwoController,
                                                                  validator:
                                                                      _validateTime,
                                                                  maxValue:
                                                                      9, // For first minute digit
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                                  child: Text(
                                                                    '-',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: GoogleFonts
                                                                        .inter(
                                                                      color: const Color(
                                                                          0xFFCFD4DC),
                                                                      fontSize:
                                                                          60,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      height:
                                                                          0.02,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              // Minutes Input Field
                                                              Expanded(
                                                                child:
                                                                    ScrollableTimeInput(
                                                                  controller:
                                                                      _minuteOneController,
                                                                  validator:
                                                                      _validateTime,
                                                                  maxValue:
                                                                      5, // For first minute digit
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 12,
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    ScrollableTimeInput(
                                                                  controller:
                                                                      _minuteTwoController,
                                                                  validator:
                                                                      _validateTime,
                                                                  maxValue:
                                                                      9, // For first minute digit
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  actions: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      const Color(
                                                                          0xFF427D9D),
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                  ),
                                                                  minimumSize: const Size(
                                                                      double
                                                                          .minPositive,
                                                                      48)),
                                                          child: const Text(
                                                            'Save Changes',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'IBM Plex Mono',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 12),
                                                        // Add spacing between buttons
                                                        OutlinedButton(
                                                          onPressed: () {
                                                            _minuteOneController
                                                                .clear();
                                                            _minuteTwoController
                                                                .clear();
                                                            _hourOneController
                                                                .clear();
                                                            _hourTwoController
                                                                .clear();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          style: OutlinedButton
                                                              .styleFrom(
                                                            side: const BorderSide(
                                                                color: Color(
                                                                    0xFF427D9D)),
                                                            backgroundColor:
                                                                Colors.white,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              side: const BorderSide(
                                                                  width: 1,
                                                                  color: Color(
                                                                      0xFF427D9D)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                            ),
                                                          ),
                                                          child: const Text(
                                                            'Cancel',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF427D9D),
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'IBM Plex Mono',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                  buttonStyle: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF427D9D),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      minimumSize:
                                          const Size(double.minPositive, 60)),
                                  // buttonStyle:
                                  //     CustomButtonStyles.fillPrimaryTL5,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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

            const SizedBox(
              height: 10,
            ),
            // Question display
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
                          color: const Color.fromRGBO(216, 233, 238, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                role == 'admin'
                                    ? Theme(
                                        data: ThemeData(
                                          textSelectionTheme:
                                              const TextSelectionThemeData(
                                            selectionColor: Color(0xFF164863),
                                            selectionHandleColor:
                                                Color(0xFF164863),
                                          ),
                                        ),
                                        child: TextField(
                                          controller: _questionController,
                                          maxLines: null,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                          ),
                                          cursorColor: const Color(0xFF164863),
                                          style: GoogleFonts.ibmPlexMono(
                                            color: const Color(0xFF164863),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          onSubmitted: (val) {
                                            setState(() {
                                              widget
                                                  .quiz
                                                  .questions[selectedQuestion]
                                                  .questionText = val;
                                            });
                                          },
                                        ),
                                      )
                                    : Text(
                                        widget.quiz.questions[selectedQuestion]
                                            .questionText,
                                        style: GoogleFonts.ibmPlexMono(
                                          color: const Color(0xFF164863),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                role == 'admin'
                                    ? Positioned(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        bottom: -35,
                                        right: 2,
                                        child: Image.asset(
                                          'assets/solar_pen-outline.png',
                                          color: Colors.black,
                                        ),
                                      )
                                    : const SizedBox.shrink()
                              ],
                            ),
                            const SizedBox(height: 12.0),
                            ...widget.quiz.questions[selectedQuestion].options
                                .asMap()
                                .entries
                                .map((entry) {
                              int answerIndex = entry.key;
                              String answerText = entry.value;
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child: ListTile(
                                    title: role == 'admin'
                                        ? Theme(
                                            data: ThemeData(
                                              textSelectionTheme:
                                                  const TextSelectionThemeData(
                                                selectionColor:
                                                    Color(0xFF164863),
                                                selectionHandleColor:
                                                    Color(0xFF164863),
                                              ),
                                            ),
                                            child: TextField(
                                              controller: _answerControllers[
                                                  answerIndex],
                                              cursorColor:
                                                  const Color(0xFF164863),
                                              maxLines: null,
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                              ),
                                              style: GoogleFonts.ibmPlexMono(
                                                color: const Color(0xFF164863),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              onSubmitted: (val) {
                                                widget
                                                    .quiz
                                                    .questions[selectedQuestion]
                                                    .options[answerIndex] = val;
                                              },
                                            ),
                                          )
                                        : Text(
                                            answerText,
                                            style: GoogleFonts.ibmPlexMono(
                                              color: const Color(0xFF164863),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                    leading: Radio<int?>(
                                      value: answerIndex,
                                      groupValue:
                                          _selectedAnswers[selectedQuestion],
                                      onChanged: (int? value) {
                                        setState(() {
                                          _selectedAnswers[selectedQuestion] =
                                              value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                    role == 'admin'
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18.0, vertical: 5),
                            child: SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.06,
                              child: ElevatedButton(
                                onPressed: () {
                                  _submitEdit();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF427D9D),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                child: Text(
                                  'Submit',
                                  style: GoogleFonts.ibmPlexMono(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
