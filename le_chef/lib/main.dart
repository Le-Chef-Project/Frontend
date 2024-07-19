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
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: SystemUiOverlay.values);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Le Chef',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ChatPage(),
    );
  }
}
