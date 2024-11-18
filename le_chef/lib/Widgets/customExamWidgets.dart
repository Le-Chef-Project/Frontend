import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Api/apimethods.dart';
import 'package:le_chef/Models/Quiz.dart';
import 'package:le_chef/Widgets/dialog_with_two_buttons.dart';

import '../Shared/exams/ExamForm.dart';
import '../Screens/user/payment.dart';
import '../Shared/exams/ExamInfo.dart';
import '../main.dart';

Widget customExamContainer(string, type) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: const Color(0xFFDDF2FD),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
      child: Text(
        '$string $type',
        style: GoogleFonts.ibmPlexMono(
          color: const Color(0xFF2A324B),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

Widget customExamListTile(
    int index, BuildContext context, bool isLocked, Quiz exam) {
  print('Exam from custom tile $exam');
  print('Exam from custom tile ${exam.title}');

  return ListTile(
    title: Text(
      exam.title,
      style: GoogleFonts.ibmPlexMono(
        color: const Color(0xFF164863),
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    subtitle: Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          customExamContainer(exam.questions.length.toString(),
              exam.questions.length == 1 ? 'Question' : 'Questions'),
          customExamContainer(exam.formattedDuration, '')
        ],
      ),
    ),
    trailing: role == 'admin'
        ? IconButton(
            onPressed: () {
              showModalBottomSheet(
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                builder: (context) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color of the modal
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          offset: const Offset(0, -2),
                          blurStyle: BlurStyle.inner,
                          spreadRadius: 1.3),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 72),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => QuizPage(
                                            quiz: exam,
                                          )));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF427D9D),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Update',
                              style: GoogleFonts.ibmPlexMono(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: ElevatedButton(
                            onPressed: () {
                              dialogWithButtons(
                                  context: context,
                                  icon: Image.asset(
                                    'assets/trash-1.png',
                                  ),
                                  title: 'Delete!',
                                  content:
                                      'Are you sure that you want to Delete Exam!',
                                  button1Text: 'Delete',
                                  button1Action: () async {
                                    Navigator.pop(context);
                                    await ApisMethods.delQuiz(exam.id);
                                    dialogWithButtons(
                                        context: context,
                                        icon: Image.asset(
                                          'assets/trash-1.png',
                                        ),
                                        title: 'Exam is deleted successfully.');
                                    Future.delayed(const Duration(seconds: 1),
                                        () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    });
                                  },
                                  button2Text: 'Cancel',
                                  button2Action: () => Navigator.pop(context),
                                  buttonColor: Colors.red,
                                  outlineButtonColor: Colors.red);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEA5B5B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Delete',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 72),
                      ],
                    ),
                  ),
                ),
                context: context,
              );
            },
            icon: const Icon(
              Icons.more_horiz,
            ))
        : Column(
          children: [
            Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLocked) const Icon(Icons.lock_outline, color: Color(0xFF164863)),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios, color: Color(0xFF164863)),
                ],
              ),
            const SizedBox(height: 10,),
            if (isLocked) Text(
                  '${exam.amountToPay.toString()} EGP', style: GoogleFonts.ibmPlexMono(
              color: const Color(0xFF427D9D),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),)
          ],
        ),
    onTap: () {
      if (role != 'admin') {
        if (isLocked) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Icon(
                  Icons.lock_outline,
                  color: Color(0xFF164863),
                  size: 100,
                ),
                content: Text(
                  'This quiz is locked.. You should pay quiz fees',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ibmPlexMono(
                    color: const Color(0xFF083344),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                actions: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: 140.50,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PaymentScreen()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF427D9D),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Pay Fees',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.ibmPlexMono(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: SizedBox(
                            width: 140.50,
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                side:
                                    const BorderSide(color: Color(0xFF427D9D)),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 1, color: Color(0xFF427D9D)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF427D9D),
                                  fontSize: 16,
                                  fontFamily: 'IBM Plex Mono',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ExamInfo(quiz: exam)),
          );
        }
      }
    },
  );
}
