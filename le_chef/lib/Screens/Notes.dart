import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Screens/chats.dart';
import 'package:le_chef/Shared/customBottomNavBar.dart';

import '../Shared/custom_app_bar.dart';
import '../theme/custom_text_style.dart';
import 'user/Home.dart';
import 'notification.dart';

class Notes extends StatelessWidget {
  const Notes({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(title: 'Notes'),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(" Today",
                          style: CustomTextStyles.titleSmallff0e7491),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Note(context),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(" Yesterday",
                          style: CustomTextStyles.titleSmallff0e7491),
                    ],
                  ),
                ),
                const SizedBox(
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
      ),
    );
  }
}

Widget Note(BuildContext context) {
  return Column(
    children: [
      ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemCount: 2,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            child: Container(
              width: 324,
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: ShapeDecoration(
                color: const Color(0xFFFBFAFA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                shadows: const [
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
                  ),
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
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Color(0xFFF9F9F9)),
                        top: BorderSide(color: Color(0xFFF9F9F9)),
                        right: BorderSide(color: Color(0xFFF9F9F9)),
                        bottom: BorderSide(width: 1, color: Color(0xFFF9F9F9)),
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
                                    style: GoogleFonts.ibmPlexMono(
                                      color: const Color(0xFF888888),
                                      fontSize: 12,
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
                                    style: GoogleFonts.ibmPlexMono(
                                      color: const Color(0xFF164863),
                                      fontSize: 14,
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
      ),
    ],
  );
}
