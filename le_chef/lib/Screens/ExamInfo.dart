import 'package:flutter/material.dart';
import 'package:le_chef/Screens/chats.dart';
import 'package:le_chef/Shared/customBottomNavBar.dart';
import 'package:le_chef/Shared/custom_elevated_button.dart';

import '../Shared/custom_app_bar.dart';
import '../theme/custom_button_style.dart';
import '../theme/custom_text_style.dart';
import '../theme/theme_helper.dart';
import 'Home.dart';
import 'notification.dart';

class ExamInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Exam Info'),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisSize:
                  MainAxisSize.max, // Aligns children at the start vertically

              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: 20.0), // Optional: Add some top margin for spacing
                  child: Center(
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
                  width: 187,
                  height: 187,
                  decoration: ShapeDecoration(
                    gradient: RadialGradient(
                      center: Alignment(0, 1),
                      radius: 0,
                      colors: [Color(0xFF9FBEC7), Color(0xFF0E7190)],
                    ),
                    shape: OvalBorder(
                      side: BorderSide(width: 5, color: Color(0xFF9BBEC8)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: 244,
                  child: Text(
                    'Your Quiz is 20 Questions \n\n Pay attention that you \n can enter to the quiz \nonly one time.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF164863),
                      fontSize: 18,
                      fontFamily: 'IBM Plex Mono',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Are You Ready ?',
                  style: TextStyle(
                    color: Color(0xFF427D9D),
                    fontSize: 22,
                    fontFamily: 'IBM Plex Mono',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
                SizedBox(
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
