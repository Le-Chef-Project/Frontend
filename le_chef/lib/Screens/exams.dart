import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:le_chef/Screens/ExamInfo.dart';
import 'package:le_chef/Screens/payment.dart';
import 'package:le_chef/Shared/custom_app_bar.dart';

import '../Shared/customBottomNavBar.dart';
import 'Home.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Exams'),
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
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
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: isSelected
                          ? ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedUnit = index + 1;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF427D9D),
                              ),
                              child: Text(
                                'Unit ${index + 1}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'IBM Plex Mono',
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
                                side: BorderSide(color: Color(0xFF427D9D)),
                                backgroundColor: Colors.white,
                              ),
                              child: Text(
                                'Unit ${index + 1}',
                                style: TextStyle(
                                  color: Color(0xFF164863),
                                  fontSize: 18,
                                  fontFamily: 'IBM Plex Mono',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(20),
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF0F4F8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Text(
                          'Unit $selectedUnit - lesson ${index + 1}',
                          style: TextStyle(
                            color: Color(0xFF164863),
                            fontSize: 18,
                            fontFamily: 'IBM Plex Mono',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_forward_ios,
                                color: Color(0xFF164863)),
                            SizedBox(width: 8),
                            Icon(Icons.lock_outline, color: Color(0xFF164863)),
                          ],
                        ),
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
                                    'This quiz is locked.. You should pay quiz fees',
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                                          builder: (context) =>
                                                              PaymentScreen()));
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
                                                  backgroundColor:
                                                      Color(0xFF427D9D),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
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
                                                  side: BorderSide(
                                                      color: Color(0xFF427D9D)),
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        width: 1,
                                                        color:
                                                            Color(0xFF427D9D)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
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
                              MaterialPageRoute(
                                  builder: (context) => ExamInfo()),
                            );
                          }
                        },
                      ),
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
    );
  }
}
