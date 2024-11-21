import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Api/apimethods.dart';
import 'package:le_chef/Screens/admin/THome.dart';
import 'package:le_chef/main.dart';

import '../Shared/customBottomNavBar.dart';
import '../Widgets/dialog_with_two_buttons.dart';
import 'admin/selectStudent.dart';
import 'user/Home.dart';
import 'chats/chats.dart';
import 'notification.dart';

class MembersScreen extends StatefulWidget {
  final String groupName;
  final String groupId;

  const MembersScreen(
      {super.key, required this.groupName, required this.groupId});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  final String userImg = 'assets/bccb46bd-67fe-47c7-8e5e-3dd39329d638.webp';
  List<dynamic> members = [];
  String? logged_ID = sharedPreferences!.getString('Id');

  bool isLoading = true;

  String? role = sharedPreferences!.getString('role');
  String? logged_username = sharedPreferences!.getString('userName');

  @override
  void initState() {
    super.initState();
    fetchMembers();
  }

  Future<void> fetchMembers() async {
    const token = 'your-auth-token'; // Replace with actual token logic
    final fetchedMembers = await ApisMethods.getGroupMembers(widget.groupId);
    if (fetchedMembers != null) {
      setState(() {
        members = fetchedMembers
            .where((member) =>
                member['_id'] != logged_ID) // Exclude logged-in user
            .toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> handleRemoveStudent(String studentId) async {
    await ApisMethods.removeStudentFromGroup(
      groupId: widget.groupId,
      studentId: studentId,
    );

    // Successfully removed student
    setState(() {
      members = members.where((member) => member['_id'] != studentId).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final String abbreviatedName =
        widget.groupName[0] + widget.groupName.split(' ')[1];
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
                  widget.groupName,
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isLoading == false)
                  Text(
                    '${members.length + 1} members',
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  role == 'admin'
                      ? Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 38.5),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              StudentSelectionScreen(
                                                existmembers: members,
                                                groupId: widget.groupId,
                                              )),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF427D9D),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14.5),
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
                        )
                      : const SizedBox.shrink(),
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
                        logged_username!, // Dynamic name if you have data
                        style: GoogleFonts.ibmPlexMono(
                          color: const Color(0xFF083344),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        role == 'admin' ? 'Teacher' : 'Member',
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
                      itemCount: members.length,
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
                              members[index]['username'],
                              style: GoogleFonts.ibmPlexMono(
                                color: const Color(0xFF083344),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: role == 'admin'
                                ? IconButton(
                                    icon: Image.asset('assets/trash.png'),
                                    onPressed: () {
                                      dialogWithButtons(
                                          context: context,
                                          icon: Image.asset(
                                            'assets/trash-1.png',
                                          ),
                                          title: 'Delete!',
                                          content:
                                              'Are you sure that you want to Delete this Student!',
                                          button1Text: 'Delete',
                                          button1Action: () async {
                                            Navigator.pop(context);
                                            handleRemoveStudent(
                                                members[index]['_id']);
                                            dialogWithButtons(
                                                context: context,
                                                icon: Image.asset(
                                                  'assets/trash-1.png',
                                                ),
                                                title:
                                                    'Student is deleted successfully.');
                                            /*Future.delayed(
                                                    const Duration(seconds: 1),
                                                    () {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                });*/
                                          },
                                          button2Text: 'Cancel',
                                          button2Action: () =>
                                              Navigator.pop(context),
                                          buttonColor: Colors.red,
                                          outlineButtonColor: Colors.red);
                                    },
                                  )
                                : const SizedBox.shrink(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: CustomBottomNavBar(
        onItemTapped: (index) async {
          switch (index) {
            case 0:
              if (role == 'admin') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => THome()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              }
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
