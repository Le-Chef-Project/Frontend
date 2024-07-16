import 'package:flutter/material.dart';
import 'package:le_chef/Screens/chats.dart';
import '../Screens/Home.dart';
import '../Screens/notification.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({Key? key}) : super(key: key);

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Notifications()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Chats()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Container(
            decoration: BoxDecoration(
              color: _selectedIndex == 0 ? Color(0xFF164863) : Colors.white,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.home_outlined),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Container(
            decoration: BoxDecoration(
              color: _selectedIndex == 1 ? Color(0xFF164863) : Colors.white,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.notifications_none_outlined),
          ),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Container(
            decoration: BoxDecoration(
              color: _selectedIndex == 2 ? Color(0xFF164863) : Colors.white,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              'https://i.pinimg.com/originals/13/87/be/1387be74b2c4d1c58982a7b056f8e54e.jpg',
              width: 30,
              height: 25,
              fit: BoxFit.cover,
            ),
          ),
          label: 'Messages',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Color(0xFF164863),
      backgroundColor: Colors.white,
      onTap: _onItemTapped,
    );
  }
}
