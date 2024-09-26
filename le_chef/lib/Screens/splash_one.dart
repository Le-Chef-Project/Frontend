// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:le_chef/Screens/Home.dart';
//
// class SplashOne extends StatefulWidget {
//   const SplashOne({super.key});
//
//   @override
//   State<SplashOne> createState() => _SplashOneState();
// }
//
// class _SplashOneState extends State<SplashOne> {
//   TextEditingController searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     Timer(
//         const Duration(seconds: 5),
//         () => Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (BuildContext context) => Home())));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//             backgroundColor: Colors.white,
//             body: Container(
//               width: 662,
//               height: 662,
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage('assets/splash_Photo.png'),
//                   fit: BoxFit.fill,
//                 ),
//               ),
//               child: Center(
//                 child: SizedBox(
//                   width: 189,
//                   height: 189,
//                   child: CircleAvatar(
//                     backgroundColor: const Color(0xFFF0FAFF),
//                     child: Image.asset('assets/logo.png'),
//                   ),
//                 ),
//               ),
//             )));
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:le_chef/Screens/splash_two.dart';
//
// class SplashOne extends StatefulWidget {
//   const SplashOne({super.key});
//
//   @override
//   State<SplashOne> createState() => _SplashOneState();
// }
//
// class _SplashOneState extends State<SplashOne> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Initialize the animation controller
//     _controller = AnimationController(
//       duration: const Duration(seconds: 1),
//       vsync: this,
//     );
//
//     // Define the animation to move diagonally
//     _animation = Tween<Offset>(
//       begin: Offset.zero,
//       end: const Offset(1.0, -1.0), // Diagonal movement to the top-right
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOut,
//     ));
//
//     // Start the animation
//     _controller.forward().then((_) {
//       // Navigate to SplashTwo screen after animation completes
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => const SplashTwo()),
//       );
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: Stack(
//           children: [
//             Positioned.fill(
//               child: Container(
//                 decoration: const BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage('assets/splash_Photo.png'),
//                     fit: BoxFit.fill,
//                   ),
//                 ),
//               ),
//             ),
//             AnimatedBuilder(
//               animation: _animation,
//               builder: (context, child) {
//                 return Positioned(
//                   left: MediaQuery.of(context).size.width / 2 - 94.5 + _animation.value.dx * (MediaQuery.of(context).size.width / 2 - 94.5),
//                   top: MediaQuery.of(context).size.height / 2 - 94.5 + _animation.value.dy * (MediaQuery.of(context).size.height / 2 - 94.5),
//                   child: CircleAvatar(
//                     radius: 80,
//                       backgroundColor: const Color(0xFFF1FAFF),
//                     child: Center(
//                       child: Image.asset('assets/logo.png'), // Ensure this image path is correct
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:le_chef/Screens/splash_two.dart';

class SplashOne extends StatefulWidget {
  const SplashOne({super.key});

  @override
  State<SplashOne> createState() => _SplashOneState();
}

class _SplashOneState extends State<SplashOne> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<Offset> _logoAnimation;
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();

    // Logo animation
    _logoController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _logoAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.0, -1.0),
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOut,
    ));

    // Background animation
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _logoController.forward();
    _backgroundController.forward().then((_) {
      // Navigate to SplashTwo screen after animations complete
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SplashTwo()),
      );
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/splash_Photo.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            // Animated background
            AnimatedBuilder(
              animation: _backgroundAnimation,
              builder: (context, child) {
                return Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.lerp(Colors.transparent, const Color(0xFFF1FAFF), _backgroundAnimation.value),
                    ),
                  ),
                );
              },
            ),
            // Animated logo
            AnimatedBuilder(
              animation: _logoAnimation,
              builder: (context, child) {
                return Positioned(
                  left: MediaQuery.of(context).size.width / 2 - 40 + _logoAnimation.value.dx * (MediaQuery.of(context).size.width / 2 - 40),
                  top: MediaQuery.of(context).size.height / 2 - 40 + _logoAnimation.value.dy * (MediaQuery.of(context).size.height / 2 - 40),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: Center(
                      child: Image.asset('assets/logo.png'),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


