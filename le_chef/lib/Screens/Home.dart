import 'package:flutter/material.dart';
import 'package:le_chef/Screens/chats.dart';
import 'package:le_chef/Screens/exams.dart';
import 'package:le_chef/Screens/seeAllVid.dart';

import '../Shared/customBottomNavBar.dart';
import '../Shared/custom_search_view.dart';
import 'Notes.dart';
import 'notification.dart';

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
                  padding: const EdgeInsets.fromLTRB(20.0, 8, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: const Color(0x00565656),
                        child: const Text(
                          'Christine Gabrail',
                          style: TextStyle(
                            color: Color(0xFF164863),
                            fontSize: 22,
                            fontFamily: 'IBM Plex Mono',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                      Container(
                        child: const Text(
                          'Level 2',
                          style: TextStyle(
                            color: Color(0xFF427D9D),
                            fontSize: 16,
                            fontFamily: 'IBM Plex Mono',
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
                    const Expanded(
                      child: SizedBox(
                        child: Text(
                          'Newest Videos',
                          style: TextStyle(
                            color: Color(0xFF164863),
                            fontSize: 16,
                            fontFamily: 'IBM Plex Mono',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 106),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AllVid()),
                        );
                      },
                      child: const Text(
                        'See all',
                        style: TextStyle(
                          color: Color(0xFF427D9D),
                          fontSize: 12,
                          fontFamily: 'IBM Plex Mono',
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
                child: new_video(context),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0.0, 0, 15.0),
                child: SizedBox(
                  width: 380,
                  child: Text(
                    'More',
                    style: TextStyle(
                      color: Color(0xFF164863),
                      fontSize: 16,
                      fontFamily: 'IBM Plex Mono',
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
                      child: _buildCardRec(
                        context,
                        Title: "Exams",
                        Number: "15",
                        ImagePath: 'assets/Wonder Learners Graduating.png',
                        onTapCardRec: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Exams()),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildCardRec(context,
                          Title: "PDFs",
                          Number: "20",
                          ImagePath: 'assets/Charco Education.png'),
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
                        onTapCardRec: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Notes()),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Text(
                                'Online Seesions',
                                style: TextStyle(
                                  color: Color(0xFF164863),
                                  fontSize: 16,
                                  fontFamily: 'IBM Plex Mono',
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
          selectedIndex: _selectedIndex,
        ),
      ),
    );
  }
}

Widget new_video(BuildContext context) {
  return ListView.builder(
    itemCount: 2,
    scrollDirection: Axis.horizontal,
    itemBuilder: (context, index) {
      return Container(
        width: 273, // Fixed width for each item in the horizontal ListView
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.asset(
                'assets/desk_book_apple.jpeg',
                fit: BoxFit.cover,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lesson Title',
                    style: TextStyle(
                      color: Color(0xFFFBFAFA),
                      fontSize: 18,
                      fontFamily: 'IBM Plex Mono',
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    'Unit 3 - Lesson 1',
                    style: TextStyle(
                      color: Color(0xFFFBFAFA),
                      fontSize: 16,
                      fontFamily: 'IBM Plex Mono',
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    },
  );
}

Widget _buildCardRec(
  BuildContext context, {
  required String Title,
  required String Number,
  required String ImagePath,
  Function? onTapCardRec,
}) {
  return GestureDetector(
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
            style: const TextStyle(
              color: Color(0xFF164863),
              fontSize: 16,
              fontFamily: 'IBM Plex Mono',
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            Number,
            style: const TextStyle(
              color: Color(0xFF0E7490),
              fontSize: 12,
              fontFamily: 'IBM Plex Mono',
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
  );
}
