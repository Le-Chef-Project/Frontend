import 'package:flutter/material.dart';
import 'package:le_chef/Screens/groupMembers.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? avatarUrl;
  final bool? isPerson;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.avatarUrl,
    this.isPerson,
  }) : super(key: key);

  void _navigateToStudentsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GroupMembers(
          students: [
            {
              'name': 'Student 1',
              'avatarUrl': 'https://example.com/avatar1.png'
            },
            {
              'name': 'Student 2',
              'avatarUrl': 'https://example.com/avatar2.png'
            },
            {
              'name': 'Student 3',
              'avatarUrl': 'https://example.com/avatar3.png'
            },
            // Add more students here
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: GestureDetector(
        onTap: () {
          if (!isPerson!) {
            _navigateToStudentsPage(context);
          }
        },
        child: Row(
          children: [
            if (avatarUrl != null)
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(avatarUrl!),
              ),
            if (avatarUrl != null) const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded),
        onPressed: () {
          Navigator.pop(context);
        },
        color: Colors.black,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
