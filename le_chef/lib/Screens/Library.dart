import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Shared/customBottomNavBar.dart';
import '../Shared/custom_app_bar.dart';
import '../Widgets/SmallCard.dart';
import 'user/Home.dart';
import 'chats.dart';
import 'notification.dart';

class Library extends StatelessWidget {
  const Library({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Library"),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 158,
                height: 228,
                child: Image.asset('assets/Charco Education.png'),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Today',
                          style: GoogleFonts.ibmPlexMono(
                            color: const Color(0xFF164863),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 182,
                    padding: const EdgeInsets.all(8),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFFBFAFA),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Filter by date range',
                          style: GoogleFonts.ibmPlexMono(
                            color: const Color(0xFF888888),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: FlutterLogo(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                  height: 480,
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemCount: 15,
                      itemBuilder: (context, index) {
                        return Smallcard(
                          Title: 'Unit one',
                          description: 'lesson two',
                          ontap: () {},
                          imageurl: 'assets/desk_book_apple.jpeg',
                        );
                      }))
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        onItemTapped: (index) {
          switch (index) {
            case 0:
              Get.to(() => const Home(),
                  transition: Transition.fade,
                  duration: const Duration(seconds: 1));

              break;
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
      ),
    ));
  }
}
