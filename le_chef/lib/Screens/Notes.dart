import 'package:flutter/material.dart';
import 'package:le_chef/Screens/chats.dart';
import 'package:le_chef/Shared/customBottomNavBar.dart';

import '../Shared/custom_app_bar.dart';
import '../theme/custom_text_style.dart';
import '../theme/theme_helper.dart';
import 'Home.dart';
import 'notification.dart';

class Notes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(title: 'Notes'),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(" Today",
                          style: CustomTextStyles.titleSmallff0e7491),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Note(context),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(" Yesterday",
                          style: CustomTextStyles.titleSmallff0e7491),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Note(context),
              ],
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
                // case 2: No need for navigation as we are already on Chats screen
              }
            },
            context: context,
          ),
        ),
      ),
    );
  }
}

Widget Note(BuildContext context) {
  return SingleChildScrollView(
    child: Column(
      children: [
        ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemCount: 2,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
              child: Container(
                width: 324,
                height: 92,
                decoration: ShapeDecoration(
                  color: Color(0xFFFBFAFA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x19000000),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Color(0x16000000),
                      blurRadius: 3,
                      offset: Offset(0, 3),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Color(0x0C000000),
                      blurRadius: 4,
                      offset: Offset(0, 7),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Color(0x02000000),
                      blurRadius: 5,
                      offset: Offset(0, 13),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Color(0x00000000),
                      blurRadius: 6,
                      offset: Offset(0, 21),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(color: Color(0xFFF9F9F9)),
                          top: BorderSide(color: Color(0xFFF9F9F9)),
                          right: BorderSide(color: Color(0xFFF9F9F9)),
                          bottom:
                              BorderSide(width: 1, color: Color(0xFFF9F9F9)),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left: 12),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      'Just now',
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        color: Color(0xFF888888),
                                        fontSize: 12,
                                        fontFamily: 'IBM Plex Mono',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                                      style: TextStyle(
                                        color: Color(0xFF164863),
                                        fontSize: 14,
                                        fontFamily: 'IBM Plex Mono',
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        )
      ],
    ),
  );
}
