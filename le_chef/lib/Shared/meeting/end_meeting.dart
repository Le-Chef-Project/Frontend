import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Shared/customBottomNavBar.dart';
import '../../Screens/chats.dart';
import '../../Screens/notification.dart';
import '../../Screens/user/Home.dart';
import 'online_session_screen.dart';

class EndMeeting extends StatelessWidget {
  const EndMeeting({super.key});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Image.asset('assets/Humaaans 3 Characters.png'),
              ),
              const SizedBox(
                height: 70,
              ),
              Text(
                'Call Ended',
                style: GoogleFonts.ibmPlexMono(
                  color: const Color(0xFF3D3D3D),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 92),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const OnlineSessionScreen()));
                        Get.to(() => const OnlineSessionScreen(), transition: Transition.fadeIn, duration: const Duration(milliseconds: 1000));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF427D9D),
                        padding:
                        const EdgeInsets.symmetric(vertical: 14.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'sessions page',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ibmPlexMono(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Home()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding:
                        const EdgeInsets.symmetric(vertical: 14.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                              color: Color(0xFF427D9D),
                              width: 1,
                            )),
                      ),
                      child: Text(
                        'Home',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ibmPlexMono(
                          color: const Color(0xFF427D9D),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar:  CustomBottomNavBar(
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