import 'package:flutter/material.dart';
import 'package:le_chef/Screens/chats.dart';
import 'package:le_chef/Shared/customBottomNavBar.dart';
import 'package:le_chef/Shared/custom_elevated_button.dart';

import '../Shared/custom_app_bar.dart';
import '../theme/custom_button_style.dart';
import 'Home.dart';
import 'notification.dart';

class ExamInfo extends StatelessWidget {
  const ExamInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(title: 'Exam Info'),
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize:
                  MainAxisSize.max, // Aligns children at the start vertically

              children: [
                Container(
                  margin: const EdgeInsets.only(
                      top: 20.0),
                  width: 187,
                  height: 187,
                  decoration: const ShapeDecoration(
                    gradient: RadialGradient(
                      center: Alignment(0, 1),
                      radius: 0,
                      colors: [Color(0xFF9FBEC7), Color(0xFF0E7190)],
                    ),
                    shape: OvalBorder(
                      side: BorderSide(width: 5, color: Color(0xFF9BBEC8)),
                    ),
                  ), // Optional: Add some top margin for spacing
                  child: const Center(
                    // Center the text inside the container
                    child: Text(
                      '20',
                      style: TextStyle(
                        color: Color(0xFFFBFAFA),
                        fontSize: 64,
                        fontFamily: 'IBM Plex Mono',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const SizedBox(
                  width: 323,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              'Your Quiz is 20 Questions in 50 minutes..\n\nPay attention that you can enter to the quiz ',
                          style: TextStyle(
                            color: Color(0xFF164863),
                            fontSize: 16,
                            fontFamily: 'IBM Plex Mono',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: 'ONLY ONE TIME',
                          style: TextStyle(
                            color: Color(0xFF427D9D),
                            fontSize: 16,
                            fontFamily: 'IBM Plex Mono',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: '.',
                          style: TextStyle(
                            color: Color(0xFF164863),
                            fontSize: 16,
                            fontFamily: 'IBM Plex Mono',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'Are You Ready ?',
                  style: TextStyle(
                    color: Color(0xFF427D9D),
                    fontSize: 22,
                    fontFamily: 'IBM Plex Mono',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                CustomElevatedButton(
                  width: 328,
                  height: 50,
                  text: 'Start Quiz',
                  buttonStyle: CustomButtonStyles.fillPrimaryTL5,
                )
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
                  MaterialPageRoute(builder: (context) => const Chats()),
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
