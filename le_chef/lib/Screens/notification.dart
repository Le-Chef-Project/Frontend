import 'package:flutter/material.dart';
import 'package:le_chef/Screens/Home.dart';
import 'package:le_chef/Shared/custom_app_bar.dart';

import '../Shared/customBottomNavBar.dart';
import 'chats.dart';

class Notifications extends StatelessWidget {
  String day = "Today";
  static const IconData pencil = IconData(0xf37e,
      fontFamily: "CupertinoIcons", fontPackage: 'cupertino_icons');
  final int _selectedIndex = 1; // Initial index for Chats screen

  final int itemCount = 2;

  Notifications({super.key}); // Number of times to print the list

  // Notifications({required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(title: "Notifications"),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      day,
                      style: const TextStyle(
                        color: Color(0xFF083344),
                        fontSize: 20,
                        fontFamily: 'IBM Plex Mono',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const NotificationItem(
                    icon: pencil,
                    iconBackgroundColor: Color(0xFFEBF4FF),
                    iconColor: Color(0xFF2A324B), // Set unique icon color
                    title: 'New Note!',
                    time: 'Just now',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const NotificationItem(
                    icon: Icons.play_arrow,
                    iconBackgroundColor: Color(0xFFFFF8F8),
                    iconColor: Color(0xFF427D9D), // Set unique icon color
                    title: 'New Video is published!',
                    time: 'Just now',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const NotificationItem(
                    icon: Icons.check_circle_outline,
                    iconBackgroundColor: Color(0xFFFAFFF1),
                    iconColor: Color(0xFF2ED573), // Set unique icon color
                    title: 'You have new quiz',
                    time: 'Just now',
                  ),
                  const SizedBox(height: 40)
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          onItemTapped: (index) {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Chats()),
                );
                break;
            }
          },
          context: context,
          selectedIndex: _selectedIndex,
        ),
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor; // New property for icon color
  final String title;
  final String time;

  const NotificationItem({super.key, 
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor, // Add to constructor
    required this.title,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: iconBackgroundColor,
            child: Icon(icon, color: iconColor, size: 30), // Use iconColor here
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
