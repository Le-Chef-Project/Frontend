import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Screens/Library.dart';
import 'package:le_chef/Screens/chats.dart';
import 'package:le_chef/Screens/exams.dart';
import 'package:le_chef/Screens/user/meeting/online_session_screen.dart';
import 'package:le_chef/Widgets/SmallCard.dart';
import '../../Shared/customBottomNavBar.dart';
import '../../Shared/custom_search_view.dart';
import '../Notes.dart';
import '../notification.dart';
import 'seeAllVid.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();
  final int _selectedIndex = 0; // Initial index for Chats screen

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          leading:
              Image.asset('assets/bccb46bd-67fe-47c7-8e5e-3dd39329d638.webp'),
          actions: [
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 23),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    'assets/logo.png',
                    height: 50,
                  ),
                )),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 8, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: const Color(0x00565656),
                        child: Text(
                          'Christine Gabrail',
                          style: GoogleFonts.ibmPlexMono(
                            color: const Color(0xFF164863),
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          'Level 2',
                          style: GoogleFonts.ibmPlexMono(
                            color: const Color(0xFF427D9D),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomSearchView(
                      onChanged: ((p0) {}),
                      clear: () {},
                      controller: searchController,
                      hintText: "Search Text")),
              Container(
                width: 400,
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: Text(
                          'Newest Videos',
                          style: GoogleFonts.ibmPlexMono(
                            color: const Color(0xFF164863),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 106),
                    TextButton(
                      onPressed: () {
                        Get.to(() => const AllVid(),
                            transition: Transition.fade,
                            duration: const Duration(seconds: 1));
                      },
                      child: Text(
                        'See all',
                        style: GoogleFonts.ibmPlexMono(
                          color: const Color(0xFF427D9D),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 250, // Specify a fixed height for the ListView
                child: ListView.builder(
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Smallcard(
                        Title: 'Unit one',
                        description: 'lesson two',
                        ontap: () {},
                        imageurl: 'assets/desk_book_apple.jpeg',
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0.0, 0, 15.0),
                child: SizedBox(
                  width: 380,
                  child: Text(
                    'More',
                    style: GoogleFonts.ibmPlexMono(
                      color: const Color(0xFF164863),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: _buildCardRec(context,
                          Title: "Exams",
                          Number: "15",
                          ImagePath: 'assets/Wonder Learners Graduating.png',
                          //Todo go to exam for student
                          // onTapCardRec: () => Get.to(() => const Exams(),
                          //     transition: Transition.fade,
                          //     duration: const Duration(seconds: 1))
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildCardRec(context,
                          Title: "Library",
                          Number: "20",
                          ImagePath: 'assets/Charco Education.png',
                          onTapCardRec: () => Get.to(() => const Library(),
                              transition: Transition.fade,
                              duration: const Duration(seconds: 1))),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: _buildCardRec(
                        context,
                        Title: "Notes",
                        Number: "10",
                        ImagePath: 'assets/Wonder Learners Book.png',
                        /*onTapCardRec: () => Get.to(() => NotesScreen(),
                              transition: Transition.fade,
                              duration: const Duration(seconds: 1))*/
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: ShapeDecoration(
                          gradient: LinearGradient(
                            begin: const Alignment(0.00, -1.00),
                            end: const Alignment(0, 1),
                            colors: [
                              const Color(0x33DDF2FD),
                              const Color(0x89C8C8C8),
                              Colors.white.withOpacity(0)
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => const OnlineSessionScreen(),
                                transition: Transition.fade,
                                duration: const Duration(seconds: 1));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  'Online Seesions',
                                  style: GoogleFonts.ibmPlexMono(
                                    color: const Color(0xFF164863),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Image.asset(
                                'assets/Shopaholics Sitting On The Floor.png',
                                height: 228,
                                width: double.maxFinite,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          onItemTapped: (index) {
            switch (index) {
              case 1:
                Get.to(() => Notifications(),
                    transition: Transition.fade,
                    duration: const Duration(seconds: 1));

                break;
              case 2:
                Get.to(() => const Chats(),
                    transition: Transition.fade,
                    duration: const Duration(seconds: 1));

                break;
            }
          },
          context: context,
          selectedIndex: _selectedIndex,
        ),
      ),
    );
  }
}

Widget _buildCardRec(
  BuildContext context, {
  required String Title,
  required String Number,
  required String ImagePath,
  Function? onTapCardRec,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8),
    decoration: ShapeDecoration(
      gradient: LinearGradient(
        begin: const Alignment(0.00, -1.00),
        end: const Alignment(0, 1),
        colors: [
          const Color(0x33DDF2FD),
          const Color(0x89C8C8C8),
          Colors.white.withOpacity(0)
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    child: GestureDetector(
      onTap: () {
        onTapCardRec?.call();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              Title,
              style: GoogleFonts.ibmPlexMono(
                color: const Color(0xFF164863),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              Number,
              style: GoogleFonts.ibmPlexMono(
                color: const Color(0xFF0E7490),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Image.asset(
            ImagePath,
            height: 228,
            width: double.maxFinite,
          )
        ],
      ),
    ),
  );
}
