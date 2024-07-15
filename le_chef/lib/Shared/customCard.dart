import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key});

  final bool isLocked = true;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Color(0xCC888888),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    elevation: 4,
    child: Stack(
    children: [
    ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: Image.network(
    "https://images.unsplash.com/reserve/bOvf94dPRxWu0u3QsPjF_tree.jpg?ixid=M3wxMjA3fDB8MXxzZWFyY2h8M3x8bmF0dXJhbHxlbnwwfHx8fDE3MjA5MjY0NjR8MA&ixlib=rb-4.0.36",
    width: double.infinity,
    height: 200,
    fit: BoxFit.cover,
    ),
    ),
    Positioned.fill(
    child: Container(
    decoration: BoxDecoration(
    color: Colors.black.withOpacity(0.3),
    borderRadius: BorderRadius.circular(12),
    ),
    ),
    ),
    if (isLocked)
    Positioned(
    bottom: 8,
    right: 8,
    child: Icon(
    Icons.lock,
    color: Colors.white,
    size: 24,
    ),
    ),
    Positioned.fill(
    child: Align(
    alignment: Alignment.center,
    child: IconButton(
    icon: Icon(Icons.play_arrow, size: 58, color: Colors.white),
    onPressed: () {
    // Define your play button functionality here
    },
    ),
    ),
    ),
    ],
    )
    );
  }
}
