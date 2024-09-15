import 'package:flutter/material.dart';
import 'package:le_chef/Screens/seeAllVid.dart';

class THome extends StatefulWidget {
  const THome({super.key});

  @override
  State<THome> createState() => _THomeState();
}

class _THomeState extends State<THome> {
  final int _selectedIndex = 0; // Initial index for Chats screen

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.6,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 3,
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(66, 125, 157, 1),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(800))),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 80, 0, 0),
                        child: Row(
                          children: [
                            profile(),
                            Container(
                              width: 69,
                              height: 69,
                              decoration: const ShapeDecoration(
                                gradient: RadialGradient(
                                  center: Alignment(0, 1),
                                  radius: 0,
                                  colors: [
                                    Color(0xFFF0FAFF),
                                    Color(0xFFC1C9CD),
                                    Color(0xFF6BA2BE)
                                  ],
                                ),
                                shape: OvalBorder(),
                              ),
                              child:
                                  Image.asset('assets/video_svgrepo.com.png'),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.6,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  _buildCard('Students'),
                                  _buildCard('Quizzes')
                                ],
                              ),
                              Row(
                                children: [
                                  _buildCard('PDFs'),
                                  _buildCard('Notes')
                                ],
                              )
                            ],
                          ),
                        ),
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
                                    MaterialPageRoute(
                                        builder: (context) => const AllVid()),
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
                          height:
                              250, // Specify a fixed height for the ListView
                          child: new_video(context),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: SizedBox(
          width: 82, // Set the desired width
          height: 82, // Set the desired height

          child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: const Color.fromRGBO(66, 125, 157, 1),
            shape: const CircleBorder(),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 48,
            ),
          ),
        ),
      ),
    );
  }
}

Widget profile() {
  return SizedBox(
    width: 241,
    height: 76,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 76,
          height: 76,
          decoration: ShapeDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/Rectangle 5.png'),
              fit: BoxFit.fill,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Hany Azmy',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'IBM Plex Mono',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Le Chef',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'IBM Plex Mono',
                      fontWeight: FontWeight.w600,
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
  );
}

Widget _buildCard(String title) {
  return Card(
      elevation: 2,
      child: Container(
        width: 141,
        height: 61,
        decoration: ShapeDecoration(
          color: const Color(0xFFD9D9D9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Center(child: Text(title)),
      ));
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
