import 'package:flutter/material.dart';
import 'package:le_chef/Screens/chats.dart';
import 'package:le_chef/Shared/customBottomNavBar.dart';
import '../Shared/custom_app_bar.dart';
import 'package:majesticons_flutter/majesticons_flutter.dart';

import 'Home.dart';
import 'notification.dart'; // Correct import
import 'Payment.dart'; // Make sure to import PaymentScreen

class AllVid extends StatelessWidget {
  const AllVid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLocked = false; // Variable to control the visibility of the lock icon

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(title: "All Videos"),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: List.generate(4, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GestureDetector(
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
                              'This quiz is locked. You should pay quiz fees',
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
                                              height: 0,
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
                                              height: 0,
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

                    }
                  },
                  child: Card(
                    color: Color(0xCC888888),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            "https://images.unsplash.com/reserve/bOvf94dPRxWu0u3QsPjF_tree.jpg?ixid=M3wxMjA3fDB8MXxzZWFyY2h8M3x8bmF0dXJhbHxlbnwwfHx8fDE3MjA5MjY0NjR8MA&ixlib=rb-4.0.36",
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (isLocked) ...[
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Icon(
                              Icons.lock,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: IconButton(
                              icon: Icon(Icons.play_arrow, size: 58, color: Colors.white),
                              onPressed: () {
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
              'This quiz is locked. You should pay quiz fees',
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
              height: 0,
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
              height: 0,
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

              }
              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
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
