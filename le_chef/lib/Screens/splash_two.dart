import 'package:flutter/material.dart';
import 'package:le_chef/Screens/login.dart';

class SplashTwo extends StatefulWidget {
  const SplashTwo({super.key});

  @override
  State<SplashTwo> createState() => _SplashTwoState();
}

class _SplashTwoState extends State<SplashTwo> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(
              right: 16.0,
              top: 16.0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF1FAFF),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/logo.jpeg',
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
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
                      const Positioned(
                        bottom: 150,
                          left: 35,
                          child: Text('French Can be more interesting', style: TextStyle(color: Color(0xFF164863), fontSize: 24))),
                      Positioned(
                        bottom: 0,
                          left: 140,
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
                            },
                            child: const CircleAvatar(
                              backgroundColor: Color(0xFFF1FAFF),
                            radius: 60,
                            child: Icon(Icons.arrow_forward, color: Color(0xFF164863),size: 50,),),
                          ))
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
