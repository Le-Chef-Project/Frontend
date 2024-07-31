import 'package:flutter/material.dart';

import '../Shared/customBottomNavBar.dart';
import '../Shared/customCard.dart';
import '../Shared/custom_app_bar.dart';
import '../Widgets/Card.dart';
import 'Home.dart';
import 'chats.dart';
import 'notification.dart';
import 'Payment.dart'; // Ensure to import the PaymentScreen

class Videos extends StatelessWidget {
  const Videos({super.key});

  @override
  Widget build(BuildContext context) {
    String title = "Lesson Title",
        subTitle = "Unit 3 - Lesson 2",
        duration = "23 min";

    bool isLocked = true; // Variable to control the visibility of the locked status

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(title: title),
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(color: Colors.white),
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: CustomCard(isLocked: isLocked, onTap: () { },),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF164863),
                    fontSize: 18,
                    fontFamily: 'IBM Plex Mono',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  subTitle,
                  style: const TextStyle(
                    color: Color(0xFF427D9D),
                    fontSize: 16,
                    fontFamily: 'IBM Plex Mono',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Padding(
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
                    child: GestureDetector(
                      onTap: () {
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
                                content: const Text(
                                  'This video is locked. You should pay video fees',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF083344),
                                    fontSize: 16,
                                    fontFamily: 'IBM Plex Mono',
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
                                                    builder: (context) => PaymentScreen(),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFF427D9D),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: const Text(
                                                'Pay Fees',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'IBM Plex Mono',
                                                  fontWeight: FontWeight.w600,
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
                                                side: const BorderSide(color: Color(0xFF427D9D)),
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  side: const BorderSide(width: 1, color: Color(0xFF427D9D)),
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
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {

                        }
                      },
                      child: CustomCardWithText(
                        title: title,
                        subtitle: subTitle,
                        duration: duration,
                        isLocked: isLocked,
                      ),
                    ),
                  );
                }),
              ),
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
            }
          },
          context: context,
        ),
      ),
    );
  }
}
