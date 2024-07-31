import 'package:flutter/material.dart';
import 'package:le_chef/Shared/custom_app_bar.dart';

import '../Shared/customBottomNavBar.dart';
import 'Home.dart';
import 'chats.dart';
import 'notification.dart';

class GroupMembers extends StatelessWidget {
  final List<Map<String, String>> students;

  const GroupMembers({Key? key, required this.students}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Group1"),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(student['avatarUrl']!),
            ),
            title: Text(student['name']!),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        onItemTapped: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
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
                MaterialPageRoute(builder: (context) => const Chats()),
              );
              break;
          }
        },
        context: context,
      ),
    );
  }
}
