import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Models/Quiz.dart';
import '../Shared/custom_elevated_button.dart';
import '../main.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key,});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final Map<int, int?> _selectedAnswers = {};
  Timer? _timer;
  int _start = 50 * 60;
  double _progress = 1.0;
  String? role = sharedPreferences.getString('role');
  final TextEditingController _questionController = TextEditingController();
  List<TextEditingController> _answerControllers = [];
  late final Quiz quiz;

  @override
  void initState() {
    super.initState();
    startTimer();
    _questionController.text = quiz.questions[selectedQuestion].questionText;
    _answerControllers = quiz.questions[selectedQuestion].options.map((answer) {
      return TextEditingController(text: answer);
    }).toList();
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
    for (int i = 0; i < quiz.questions.length; i++) {
      final selectedAnswerIndex = _selectedAnswers[i];
      if (selectedAnswerIndex != null) {
        final selectedAnswer = quiz.questions[i].options[selectedAnswerIndex];
        final correctAnswerIndex = quiz.questions[i].answer;
        if (selectedAnswer == correctAnswerIndex) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Question ${i + 1}: Correct!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Question ${i + 1}: Wrong. The correct answer is: ${quiz.questions[i].answer}')),
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
    _questionController.dispose();
    for (var controller in _answerControllers) {
      controller.dispose();
    }
  }

  int selectedQuestion = 0;


  @override
  Widget build(BuildContext context) {
    double boxSize = 30.0;
    // Calculate the total height needed for the grid

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
                      content: SizedBox(
                        width: 150,
                        height: 80,
                        child: Column(
                          children: [
                            Text(
                              'Warning!',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.ibmPlexMono(
                                color: const Color(0xFF164863),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'If you leave the quiz you will not \n be able to take it again !',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.ibmPlexMono(
                                color: const Color(0xFF888888),
                                fontSize: 16,
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
                                child: SizedBox(
                                  width: 140.50,
                                  height: 48,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF427D9D),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        'Complete quiz',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.ibmPlexMono(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      )),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: SizedBox(
                                    width: 140.50,
                                    height: 48,
                                    child: OutlinedButton(
                                        onPressed: () {},
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                              color: Color(0xFF427D9D)),
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                                width: 1,
                                                color: Color(0xFF427D9D)),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: Text(
                                          'Leave',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.ibmPlexMono(
                                            color: const Color(0xFF427D9D),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            height: 0,
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
                                  onPressed: _submitAnswers,
                                  buttonStyle: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF427D9D),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12))),
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
                physics: const NeverScrollableScrollPhysics(), // Disable scrolling
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10,
                  childAspectRatio: 1,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: quiz.questions.length,
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
                      onPressed: () {
                        selectedQuestion != 0
                            ? setState(() {
                                selectedQuestion--;
                              })
                            : selectedQuestion = 0;
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFF888888),
                      ),
                    ),
                  ),
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
                      onPressed: () {
                        selectedQuestion != 39
                            ? setState(() {
                                selectedQuestion++;
                              })
                            : selectedQuestion = 39;
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFF888888),
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
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                role == 'admin' ? Theme(
                                  data: ThemeData(
                                    textSelectionTheme: const TextSelectionThemeData(
                                      selectionColor: Color(0xFF164863),
                                      selectionHandleColor: Color(0xFF164863),
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
                                    onSubmitted: (val){
                                      setState(() {
                                        quiz.questions[selectedQuestion].questionText = val;
                                      });
                                    },
                                  ),
                                ) :Text(
                                  quiz.questions[selectedQuestion].questionText,
                                  style: GoogleFonts.ibmPlexMono(
                                    color: const Color(0xFF164863),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                role == 'admin' ? Positioned(
                                  height: MediaQuery.of(context).size.height * 0.1,
                                  bottom: -35,
                                    right: 2,
                                    child:
                                      Image.asset('assets/solar_pen-outline.png', color: Colors.black,),
                                    ): const SizedBox.shrink()
                              ],
                            ),
                            const SizedBox(height: 12.0),
                            ...quiz.questions[selectedQuestion]
                                .options
                                .asMap()
                                .entries
                                .map((entry) {
                              int answerIndex = entry.key;
                              String answerText = entry.value;
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child: ListTile(
                                    title: role == 'admin' ? Theme(
                                      data: ThemeData(
                                        textSelectionTheme: const TextSelectionThemeData(
                                          selectionColor: Color(0xFF164863),
                                          selectionHandleColor: Color(0xFF164863),
                                        ),
                                      ),
                                      child: TextField(
                                        controller: _answerControllers[answerIndex],
                                        cursorColor: const Color(0xFF164863),
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
                                        onSubmitted: (val){
                                          quiz.questions[selectedQuestion].options[answerIndex] = val;
                                        },
                                      ),
                                    ) : Text(
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5),
                      child: SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: ElevatedButton(onPressed: (){
                          role == 'admin' ? showDialog(context: context, builder: (BuildContext context){
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              icon: const Icon(Icons.check_circle_outline, color: Color(0xFF2ED573), size: 150,),
                              title: Text('Success!', style: GoogleFonts.ibmPlexMono(color: const Color(0xFF164863),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,),),
                              content: Text('Exam Updated Successfully', style: GoogleFonts.ibmPlexMono(color: const Color(0xFF888888),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,),),

                            );
                          }) : Navigator.pop(context);//Todo submit exam for student
                          
                          Future.delayed(const Duration(seconds: 2), (){
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                        },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF427D9D),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))), child: Text('Submit', style: GoogleFonts.ibmPlexMono(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                        ),),
                        ),
                      ),
                    )
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
