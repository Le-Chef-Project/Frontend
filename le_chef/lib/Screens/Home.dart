import 'package:flutter/material.dart';
import 'package:le_chef/Screens/chats.dart';

import '../Shared/customBottomNavBar.dart';
import '../Shared/custom_app_bar.dart';
import 'notification.dart';

class Home extends StatelessWidget {

  int _selectedIndex = 0; // Initial index for Chats screen


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: Text('Home'),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        onItemTapped: (index) {
          switch (index) {
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
        }, context: context, selectedIndex: _selectedIndex,
      ),
  );}

  
}
