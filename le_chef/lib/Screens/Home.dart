import 'package:flutter/material.dart';

import '../Shared/customBottomNavBar.dart';
import '../Shared/custom_app_bar.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: Text('Home'),
      ),
        bottomNavigationBar: CustomBottomNavBar()
  );}

  
}
