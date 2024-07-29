import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:le_chef/Screens/ExamForm.dart';
import 'package:le_chef/Screens/Home.dart';
import 'package:le_chef/Screens/Notes.dart';
import 'package:le_chef/Screens/SplashOne.dart';
import 'package:le_chef/Screens/THome.dart';
import 'package:le_chef/Screens/exams.dart';
import 'package:le_chef/Screens/login.dart';
import 'package:le_chef/Screens/notification.dart';
import 'package:le_chef/Screens/AAA.dart';
import 'package:le_chef/Screens/seeAllVid.dart';
import './Screens/payment.dart';
import 'Screens/chatPage.dart';
import 'Screens/chats.dart';
import 'Screens/videos.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the color you want for the status bar
    Color statusBarColor = Colors.white;
    // Apply the status bar color globally
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: statusBarColor,
      statusBarIconBrightness:
          Brightness.dark, // You can adjust based on your color
    ));

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Le Chef',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SplashOne(),
      ),
    );
  }
}
