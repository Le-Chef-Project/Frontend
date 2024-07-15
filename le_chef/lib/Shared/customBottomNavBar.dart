import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class custumBottomNavBar extends StatelessWidget {
  const custumBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none_outlined),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Image.network(
              'https://i.pinimg.com/originals/13/87/be/1387be74b2c4d1c58982a7b056f8e54e.jpg',
              width: 30,
              height: 25,
              fit: BoxFit.cover),
          label: 'Messages',
        ),
      ],
      selectedItemColor: Color(0xFF164863),
      unselectedItemColor: Color(0xFF164863),
      backgroundColor: Colors.white,
    );
  }
}
