import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Screens/members_screen.dart';

PreferredSizeWidget buildAppBar(BuildContext context, String? groupName,
    int? membersNumber, String? username, String? avatarUrl, String grpId) {
  if (groupName != null && groupName.contains(' ')) {
    return GroupChatAppBar(
      groupName: groupName,
      membersNumber: membersNumber,
      onBackPressed: () => Navigator.pop(context),
      grpId: grpId,
    );
  }
  return PersonalChatAppBar(
    username: username ?? 'Chat',
    avatarUrl: avatarUrl ??
        'https://r2.starryai.com/results/911754633/bccb46bd-67fe-47c7-8e5e-3dd39329d638.webp',
    onBackPressed: () => Navigator.pop(context),
  );
}

class GroupChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String groupName;
  final int? membersNumber;
  final VoidCallback onBackPressed;
  final String grpId;

  const GroupChatAppBar({
    Key? key,
    required this.groupName,
    this.membersNumber,
    required this.onBackPressed, required this.grpId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final names = groupName.split(' ');
    final abbreviatedName = names[0][0] + names[1][0];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MembersScreen(
              groupName: groupName,
              groupId: grpId,
            ),
          ),
        );
      },
      child: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBackPressed,
          color: Colors.black,
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF0E7490),
              child: Text(
                abbreviatedName,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 8),
            _buildGroupInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          groupName,
          style: GoogleFonts.ibmPlexMono(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (membersNumber != null)
          Text(
            '$membersNumber members',
            style: GoogleFonts.ibmPlexMono(
              color: const Color(0xFF888888),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class PersonalChatAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String username;
  final String? avatarUrl;
  final VoidCallback onBackPressed;

  const PersonalChatAppBar({
    Key? key,
    required this.username,
    this.avatarUrl,
    required this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBackPressed,
        color: Colors.black,
      ),
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage:
                avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            backgroundColor: const Color(0xFF0E7490),
            child: avatarUrl == null
                ? Text(
                    username[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            username,
            style: GoogleFonts.ibmPlexMono(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
