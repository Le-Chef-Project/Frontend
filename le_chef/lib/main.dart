import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:le_chef/Screens/Home.dart';
import 'package:le_chef/Screens/Notes.dart';
import 'package:le_chef/Screens/exams.dart';
import 'package:le_chef/Screens/login.dart';
import 'package:le_chef/Screens/notification.dart';
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
      statusBarIconBrightness: Brightness.dark, // You can adjust based on your color
    ));

    return MaterialApp(
      title: 'Le Chef',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Videos(),
    );
  }
}
