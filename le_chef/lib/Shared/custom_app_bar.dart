import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? avatarUrl;

  CustomAppBar({
    Key? key,
    required this.title,
    this.avatarUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: Row(
        children: [
          if (avatarUrl != null)
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(avatarUrl!),
            ),
          if (avatarUrl != null) SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_rounded),
        onPressed: () {
          Navigator.pop(context);
        },
        color: Colors.black,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
