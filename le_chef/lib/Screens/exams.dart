import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Shared/custom_app_bar.dart';
import 'package:le_chef/Widgets/total_exams-students_card.dart';

import '../Shared/customBottomNavBar.dart';
import '../Widgets/customExamWidgets.dart';
import '../main.dart';
import 'user/Home.dart';
import 'chats.dart';
import 'notification.dart';

class Exams extends StatefulWidget {
  const Exams({super.key});

  @override
  State<Exams> createState() => _ExamsState();
}

class _ExamsState extends State<Exams> {
  final int itemCount = 3;
  int selectedUnit = 1;
  bool isLocked = true;
  String? role = sharedPreferences.getString('role');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Exams'),
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            role == 'admin'
                ? totalStudent(context, 'Total Exams', '16k',
                    buttonText: 'Add Exam')
                : Center(
                    child: Image.asset(
                      'assets/Wonder Learners Graduating.png',
                      width: 300,
                      height: 300,
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(itemCount, (index) {
                  bool isSelected = selectedUnit == index + 1;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: isSelected
                          ? ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedUnit = index + 1;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF427D9D),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              child: Text(
                                'Unit ${index + 1}',
                                style: GoogleFonts.ibmPlexMono(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  selectedUnit = index + 1;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: Color(0xFF427D9D)),
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              child: Text(
                                'Unit ${index + 1}',
                                style: GoogleFonts.ibmPlexMono(
                                  color: const Color(0xFF164863),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 8,),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBFAFA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: customExamListTile(index, selectedUnit, context, isLocked)
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(
          onItemTapped: (index) {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
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
                  MaterialPageRoute(builder: (context) => const Chats()),
                );
                break;
              // case 2: No need for navigation as we are already on Chats screen
            }
          },
          context: context,
        ),
      ),
    );
  }
}
