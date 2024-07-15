import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Shared/customBottomNavBar.dart';
import '../Shared/customCard.dart';
import '../Shared/custom_app_bar.dart';
import '../Widgets/Card.dart';

class Videos extends StatelessWidget {
  const Videos({super.key});

  @override
  Widget build(BuildContext context) {

    String title = "Lesson Title", subTitle = "Unit 3 - Lesson 2", duration = "23 min";

    return Scaffold(
      appBar: CustomAppBar(title: "Video title"),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: CustomCard(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                title,
                style: TextStyle(
                  color: Color(0xFF164863),
                  fontSize: 18,
                  fontFamily: 'IBM Plex Mono',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                subTitle,
                style: TextStyle(
                  color: Color(0xFF427D9D),
                  fontSize: 16,
                  fontFamily: 'IBM Plex Mono',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'More Videos',
                style: TextStyle(
                  color: Color(0xFF164863),
                  fontSize: 18,
                  fontFamily: 'IBM Plex Mono',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
            ),
            Column(
              children: List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: CustomCardWithText(
                    title: title,
                    subtitle: subTitle,
                    duration: duration,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: custumBottomNavBar(),
    );
  }
}
