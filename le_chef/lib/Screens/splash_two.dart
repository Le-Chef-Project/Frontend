import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Screens/login.dart';

class SplashTwo extends StatefulWidget {
  const SplashTwo({super.key});

  @override
  State<SplashTwo> createState() => _SplashTwoState();
}

class _SplashTwoState extends State<SplashTwo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 100, end: 150).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1FAFF),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/logo.png',
                      width: _animation.value,
                      height: _animation.value,
                      fit: BoxFit.contain,
                    ),
                  );
                },
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
                            color: Color(0xFF164863),
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
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