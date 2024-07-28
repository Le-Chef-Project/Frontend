import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:le_chef/Screens/Home.dart';

class SplashOne extends StatefulWidget {
  @override
  State<SplashOne> createState() => _SplashOneState();
}

class _SplashOneState extends State<SplashOne> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 5),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => Home())));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              width: 662,
              height: 662,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/splash_Photo.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Center(
                child: Container(
                  width: 189,
                  height: 189,
                  child: CircleAvatar(
                    backgroundColor: Color(0xFFF0FAFF),
                    child: Image.asset('assets/logo.png'),
                  ),
                ),
              ),
            )));
  }
}
