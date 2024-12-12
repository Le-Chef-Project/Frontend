import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Screens/admin/library.dart';
import 'package:le_chef/Screens/admin/payment_request.dart';
import 'package:le_chef/Shared/exams/exams.dart';
import 'package:le_chef/Shared/custom_app_bar.dart';

import '../../Shared/customBottomNavBar.dart';
import '../../main.dart';
import '../chats/chats.dart';
import '../notification.dart';
import '../user/Home.dart';
import 'THome.dart';

class ExamLibraryLevels extends StatefulWidget {
  final String title;
  final int? libraryLength;
  final int? pdfLength;
  final int? examsLength;
  final int? videosLength;
  const ExamLibraryLevels({super.key, required this.title, this.libraryLength, this.pdfLength, this.examsLength, this.videosLength});

  @override
  State<ExamLibraryLevels> createState() => _ExamLibraryLevelsState();
}

class _ExamLibraryLevelsState extends State<ExamLibraryLevels> {
  String? role = sharedPreferences!.getString('role');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(title: widget.title),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: 3,
                shrinkWrap:
                    true, // Added to allow ListView to be contained within a Column
                physics:
                    const NeverScrollableScrollPhysics(), // Disables ListView's scrolling
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        widget.title == 'Exams'
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Exams(
                                          selectedLevel: index + 1,
                                        )),
                              )
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LibraryTabContainerScreen(
                                          selectedLevel: index + 1,
                                          libraryLength: widget.libraryLength,
                                          examsLength: widget.examsLength,
                                          pdfLength: widget.pdfLength,
                                          videosLength: widget.videosLength,
                                        )),
                              );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBFAFA),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          title: Text(
                            'Level ${index + 1}',
                            style: GoogleFonts.ibmPlexMono(
                              color: const Color(0xFF164863),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          onItemTapped: (index) async {
            switch (index) {
              case 0:
                if (role == 'admin') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const THome()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                  );
                }
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Notifications()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Chats()),
                );
                break;
              case 3:
                if (role == 'admin') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentRequest()));
                }
            }
          },
          context: context, userRole: role!,
        ),
      ),
    );
  }
}
