import 'dart:async';

import 'package:flutter/material.dart';
import 'package:le_chef/Screens/Home.dart';

class SplashOne extends StatefulWidget {
  const SplashOne({super.key});

  @override
  State<SplashOne> createState() => _SplashOneState();
}

class _SplashOneState extends State<SplashOne> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 5),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => const Home())));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              width: 662,
              height: 662,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/splash_Photo.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Center(
                child: SizedBox(
                  width: 189,
                  height: 189,
                  child: CircleAvatar(
                    backgroundColor: const Color(0xFFF0FAFF),
                    child: Image.asset('assets/logo.png'),
                  ),
                ),
              ),
            )));
  }
}
