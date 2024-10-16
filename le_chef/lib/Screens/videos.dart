import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Screens/ExamInfo.dart';
import 'package:le_chef/Screens/user/payment.dart';
import 'package:le_chef/Shared/custom_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Shared/customBottomNavBar.dart';
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
  String? role;
  bool _showContainer = false;

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future _loadRole() async{
    final pref = await SharedPreferences.getInstance();
    setState(() {
      role = pref.getString('role');
    });
  }

  void _toggleContainer() {
    setState(() {
      _showContainer = !_showContainer;
    });
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Exams'),
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            role == 'admin' ?
            totalStudent(context) :
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
                                borderRadius: BorderRadius.circular(10)
                            )
                        ),
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
                            side: const BorderSide(color: Color(0xFF427D9D)),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            )
                        ),
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
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F4F8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        tileColor:  const Color(0xFFFBFAFA),
                        title: Text(
                          'Unit $selectedUnit - lesson ${index + 1}',
                          style: GoogleFonts.ibmPlexMono(
                            color: const Color(0xFF164863),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing:
                        role == 'admin' ?
                        IconButton(onPressed: _toggleContainer
                            , icon: const Icon(Icons.more_horiz))
                            : const Row(
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
                                  title: const Icon(
                                    Icons.lock_outline,
                                    color: Color(0xFF164863),
                                    size: 100,
                                  ),
                                  content: Text(
                                    'This quiz is locked.. You should pay quiz fees',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.ibmPlexMono(
                                      color: const Color(0xFF083344),
                                      fontSize: 16,
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
                                            child: SizedBox(
                                              width: 140.50,
                                              height: 48,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                          const PaymentScreen()));
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                  const Color(0xFF427D9D),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        12),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Pay Fees',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.ibmPlexMono(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    height: 0,
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
                                                  side: const BorderSide(
                                                      color: Color(0xFF427D9D)),
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    side: const BorderSide(
                                                        width: 1,
                                                        color:
                                                        Color(0xFF427D9D)),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        12),
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
                                                    height: 0,
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
                                  builder: (context) => const ExamInfo()),
                            );
                          }
                        },
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFDDF2FD),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: Text('50 Question', style: GoogleFonts.ibmPlexMono(color: const Color(0xFF2A324B),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,),),
                              ),
                              Container(
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFDDF2FD),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: Text('60 Minutes', style: GoogleFonts.ibmPlexMono(color: const Color(0xFF2A324B),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,),),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if(_showContainer)
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle update logic here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Update button color
                      ),
                      child: const Text('Update'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Handle delete logic here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Delete button color
                      ),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              )
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

  Widget totalStudent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x4C427D9D),
              blurRadius: 32.50,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Total Exams',
                  style: GoogleFonts.ibmPlexMono(
                    color: const Color(0xFF164863),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
                const SizedBox(width: 50),
                Container(
                  height: 41,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFDDF2FD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        '16.5K',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ibmPlexMono(
                          color: const Color(0xFF164863),
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16,),
            Center(
              child: ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF427D9D),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                  )
              ), child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Add Exam ', style: GoogleFonts.ibmPlexMono(color: const Color(0xFFFBFAFA),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,),),
                  const SizedBox(width: 2,),
                  const Icon(Icons.add, color: Color(0xFFFBFAFA), size: 20,)
                ],
              )),
            )
          ],
        ),
      ),
    );
  }

}