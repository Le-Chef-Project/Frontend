import 'package:flutter/material.dart';

import '../Shared/customBottomNavBar.dart';
import '../Shared/custom_app_bar.dart';

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Text('Notifications'),
    ),
        bottomNavigationBar: CustomBottomNavBar()
    );
  }
}
