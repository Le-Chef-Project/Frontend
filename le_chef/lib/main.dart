import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:le_chef/Screens/ExamForm.dart';
import 'package:le_chef/Screens/OnlineSessions.dart';
import 'package:le_chef/Screens/Login.dart';
import 'package:le_chef/Screens/THome.dart';
import 'package:le_chef/Screens/all_students.dart';
import 'package:le_chef/Screens/meeting/end_meeting.dart';
import 'package:le_chef/Screens/meeting/meeting_screen.dart';
import 'package:le_chef/Screens/meeting/online_session_screen.dart';
import 'package:le_chef/Screens/members_screen.dart';
import 'package:le_chef/Screens/splash_one.dart';

import 'Screens/Home.dart';

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
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Le Chef',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: AllStudents(),
      ),
    );
  }
}
