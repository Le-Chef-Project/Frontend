import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class ExamsResults extends StatefulWidget {
  @override
  State<ExamsResults> createState() => _ExamsResultsState();
}

class _ExamsResultsState extends State<ExamsResults> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text('Exams Results '),
        ),
      ),
    );
  }
}
