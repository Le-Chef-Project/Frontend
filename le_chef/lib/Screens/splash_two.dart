import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Screens/login.dart';

class SplashTwo extends StatelessWidget {
  const SplashTwo({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF1FAFF),
        body: Stack(
          children: [
            Positioned(
              right: 10.0,
              child: Hero(
                tag: 'logoAnimation',
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1FAFF),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/logo.png',
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Positioned(
              top: screenSize.height / 4 - 375,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Image.asset(
                        'assets/Nomads Postal Souvenir.png',
                        fit: BoxFit.contain,
                        width: screenSize.width,
                        height: screenSize.height,
                      ),
                      Positioned(
                        top: 110,
                        child: Image.asset(
                          'assets/Wonder Learners Story Time.png',
                          fit: BoxFit.contain,
                          width: screenSize.width,
                          height: screenSize.height,
                        ),
                      ),
                      Positioned(
                        bottom: 150,
                        left: 80,
                        child: Text(
                          'French Can be more \n interesting',
                          style: GoogleFonts.ibmPlexMono(
                            color: const Color(0xFF164863),
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 155,
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => Login(), transition: Transition.rightToLeftWithFade, duration: Duration(seconds: 2));
                          },
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 50,
                            child: Icon(Icons.arrow_forward, color: Color(0xFF164863), size: 50),
                          ),
                        ),
                      )
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