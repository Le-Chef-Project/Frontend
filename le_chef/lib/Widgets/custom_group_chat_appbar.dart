import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildGroupChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? groupName;
  final int? membersNumber;

  const BuildGroupChatAppBar(this.groupName, this.membersNumber, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate abbreviated name
    String abbreviatedName = '';
    if (groupName != null) {
      final names = groupName!.split(' ');
      if (names.length >= 2) {
        abbreviatedName = '${names[0][0]}${names[1][0]}'.toUpperCase();
      } else if (names.isNotEmpty) {
        abbreviatedName = names[0][0].toUpperCase();
      }
    }

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF0E7490),
              child: Text(
                abbreviatedName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    groupName ?? 'Group Chat',
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}