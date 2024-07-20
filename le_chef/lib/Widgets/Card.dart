import 'package:flutter/material.dart';
import '../Screens/Payment.dart'; // Import your PaymentScreen

class CustomCardWithText extends StatelessWidget {
  final String title;
  final String subtitle;
  final String duration;
  final bool isLocked; // Variable to control the visibility of the locked status

  CustomCardWithText({
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isLocked) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Icon(
                  Icons.lock_outline,
                  color: Color(0xFF164863),
                  size: 100,
                ),
                content: Text(
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
                          child: Container(
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
                              child: Text(
                                'Pay Fees',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'IBM Plex Mono',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF427D9D),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Container(
                            width: 140.50,
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Cancel',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF427D9D),
                                  fontSize: 16,
                                  fontFamily: 'IBM Plex Mono',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Color(0xFF427D9D)),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 1, color: Color(0xFF427D9D)),
                                  borderRadius: BorderRadius.circular(12),
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
          // Navigate or perform actions for unlocked state
        }
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80,  // Increased width
              height: 80,  // Increased height
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.image_rounded, size: 60, color: Colors.grey[400]),  // Increased icon size
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Color(0xFF164863),
                      fontSize: 16,
                      fontFamily: 'IBM Plex Mono',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Color(0xFF427D9D),
                      fontSize: 14,
                      fontFamily: 'IBM Plex Mono',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '• $duration',
                        style: TextStyle(
                          color: Color(0xFF49454F),
                          fontSize: 12,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          height: 0.11,
                          letterSpacing: 0.40,
                        ),
                      ),
                      Spacer(),
                      if (isLocked)
                        Icon(
                          Icons.lock,
                          size: 20,
                          color: Color(0xFF164863),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
