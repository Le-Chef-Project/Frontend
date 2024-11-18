import 'package:flutter/material.dart';

class ExamsResults extends StatefulWidget {
  const ExamsResults({super.key});

  @override
  State<ExamsResults> createState() => _ExamsResultsState();
}

class _ExamsResultsState extends State<ExamsResults> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text('Exams Results '),
        ),
      ),
    );
  }
}
