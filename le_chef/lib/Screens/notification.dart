import 'package:flutter/material.dart';

import '../Shared/customBottomNavBar.dart';
import '../Shared/custom_app_bar.dart';
import 'Home.dart';
import 'chats.dart';

class Notifications extends StatelessWidget {

  int _selectedIndex = 1; // Initial index for Chats screen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Text('Notifications'),
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
                MaterialPageRoute(builder: (context) => Chats()),
              );
              break;
          }
        }, context: context, selectedIndex: _selectedIndex,
      ),
    );
  }
}
