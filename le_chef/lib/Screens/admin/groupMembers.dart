import 'package:flutter/material.dart';
import 'package:le_chef/Models/Student.dart';
import 'package:le_chef/Screens/admin/payment_request.dart';
import 'package:le_chef/Shared/custom_app_bar.dart';

import '../../Shared/customBottomNavBar.dart';
import '../../main.dart';
import '../user/Home.dart';
import '../chats/chats.dart';
import '../notification.dart';
import 'THome.dart';

class GroupMembers extends StatefulWidget {
  final List<Student> students;

  const GroupMembers({Key? key, required this.students}) : super(key: key);

  @override
  State<GroupMembers> createState() => _GroupMembersState();
}

class _GroupMembersState extends State<GroupMembers> {
  String? role = sharedPreferences!.getString('role');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Group1"),
      body: ListView.builder(
        itemCount: widget.students.length,
        itemBuilder: (context, index) {
          final student = widget.students[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(student.imageUrl!),
            ),
            title: Text(student.username),
          );
        },
      ),
      bottomNavigationBar:  CustomBottomNavBar(
        onItemTapped: (index) async {
          switch (index) {
            case 0:
              if (role == 'admin') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const THome()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              }
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Notifications()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Chats()),
              );
              break;
            case 3:
              if (role == 'admin') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentRequest()));
              }
          }
        },
        context: context, userRole: role!,
      ),
    );
  }
}
