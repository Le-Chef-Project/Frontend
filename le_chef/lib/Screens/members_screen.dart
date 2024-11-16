import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/main.dart';

import '../Shared/customBottomNavBar.dart';
import 'user/Home.dart';
import 'chats.dart';
import 'notification.dart';

class MembersScreen extends StatelessWidget {
  final String groupName;
  final int membersNumber;
  final String userImg = 'assets/bccb46bd-67fe-47c7-8e5e-3dd39329d638.webp';
  final List usersName = ['Mhammed Ali', 'Jouna Moayyad', 'Hawraa Mahmoud', 'Ruqaya Layth', 'Aya Abd Alazyz', 'Ibrahem Abas'];
  String? role = sharedPreferences!.getString('role');

  MembersScreen({super.key, required this.groupName, required this.membersNumber});

  @override
  Widget build(BuildContext context) {
    final String abbreviatedName = groupName[0] + groupName.split(' ')[1];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  groupName,
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            role == 'admin' ?Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 38.5),
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your logic for adding members
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF427D9D),
                        padding: const EdgeInsets.symmetric(vertical: 14.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Add members',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ibmPlexMono(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ) : SizedBox.shrink(),
            const SizedBox(height: 47),
            Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: ListTile(
                    leading: const CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage(
                        'assets/bccb46bd-67fe-47c7-8e5e-3dd39329d638.webp',
                      ),
                    ),
                    title: Text(
                      'Hany Azmy', // Dynamic name if you have data
                      style: GoogleFonts.ibmPlexMono(
                        color: const Color(0xFF083344),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'Teacher',
                      style: GoogleFonts.ibmPlexMono(
                        color: const Color(0xFF888888),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
            Expanded(
              child: ListView.builder(
                itemCount: usersName.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage(
                          userImg,
                        ),
                      ),
                      title: Text(
                        usersName[index],
                        style: GoogleFonts.ibmPlexMono(
                          color: const Color(0xFF083344),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: role == 'admin' ? IconButton(
                        icon: Image.asset('assets/trash.png'),
                        onPressed: () {
                          //ToDo delete logic
                        },
                      ) : SizedBox.shrink(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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
