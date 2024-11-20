import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Models/Student.dart';
import 'package:le_chef/Models/group_chat.dart';
import 'package:le_chef/Screens/admin/selectStudent.dart';
import 'package:le_chef/Screens/chats/chatPage.dart';
import 'package:le_chef/Screens/members_screen.dart';
import 'package:le_chef/Shared/customBottomNavBar.dart';

import '../../Api/apimethods.dart';
import '../../Models/group.dart';
import '../../Shared/custom_app_bar.dart';
import '../../Widgets/dialog_with_two_buttons.dart';
import '../../main.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../user/Home.dart';
import '../notification.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});
  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final int _selectedIndex = 2;

  String? role = sharedPreferences!.getString('role');

  List<Group>? groups;
  bool _isLoading_grp = true;

  Future<void> getStd() async {
    groups = await ApisMethods.getAllGroups();
    print('group infooooooooo ${groups!}');
    setState(() {
      _isLoading_grp = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getStd();
  }

  // Initial index for Chats screen
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(title: 'Messages'),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(" Groups",
                          style: CustomTextStyles.titleSmallff0e7491),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                _isLoading_grp
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : groups!.isNotEmpty
                        ? groupChat(context)
                        : const Center(
                            child: Text('no groups yet '),
                          ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(" Chats",
                          style: CustomTextStyles.titleSmallff0e7491),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                PersonalChat(context),
              ],
            ),
          ),
          floatingActionButton: role == 'admin'
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StudentSelectionScreen(
                                is_exist: false,
                              )),
                    );
                  },
                  backgroundColor: const Color(0xFFDDF2FD),
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.add,
                    color: Color(0xFF164863),
                    size: 44,
                  ),
                )
              : null, // No button for non-admin roles
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
              }
            },
            context: context,
            selectedIndex: _selectedIndex,
          ),
        ),
      ),
    );
  }

  Widget PersonalChat(BuildContext context) {
    Student std = Student(
        username: 'saso',
        Lastname: 'Saiid',
        firstname: 'thaowpsta',
        email: 'thaowpsta@gmail.com',
        phone: '01211024432',
        ID: '671bb7965c2d72826a977b76');
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemCount: 2,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatPage(
                                receiver: std,
                              )));
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: Image.asset(
                          'assets/bccb46bd-67fe-47c7-8e5e-3dd39329d638.webp',
                          height: 50,
                          width: 49,
                        ).image,
                      ),
                    ),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          _buildHeader(context, name: "Kokii", time: "10:30PM"),
                          const SizedBox(height: 8),
                          const Text(
                            'Hi!!',
                            // style: Theme.of(context).textTheme.bodyText2,
                          )
                        ]))
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget groupChat(BuildContext context) {
    GroupChat? group;
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemCount: groups!.length,
            itemBuilder: (context, index) {
              String isoTime = groups![index].createdAt;

              // Parse the ISO 8601 string
              DateTime dateTime = DateTime.parse(isoTime);

              // Convert to local time if needed
              DateTime localTime = dateTime.toLocal();

              int hour = localTime.hour % 12 == 0 ? 12 : localTime.hour % 12;

              return GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const ChatPage()));
                },
                onLongPress: () async {
                  showModalBottomSheet(
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    builder: (context) => Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Background color of the modal
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              offset: const Offset(0, -2),
                              blurStyle: BlurStyle.inner,
                              spreadRadius: 1.3),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 72),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.height * 0.06,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF427D9D),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: GoogleFonts.ibmPlexMono(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.height * 0.06,
                              child: ElevatedButton(
                                onPressed: () {
                                  dialogWithButtons(
                                      context: context,
                                      icon: Image.asset(
                                        'assets/trash-1.png',
                                      ),
                                      title: 'Delete!',
                                      content:
                                          'Are you sure that you want to Delete Group!',
                                      button1Text: 'Delete',
                                      button1Action: () async {
                                        Navigator.pop(context);
                                        await ApisMethods.DelGroup(
                                            groups![index].id);
                                        dialogWithButtons(
                                            context: context,
                                            icon: Image.asset(
                                              'assets/trash-1.png',
                                            ),
                                            title:
                                                'Group is deleted successfully.');
                                        Future.delayed(
                                            const Duration(seconds: 1), () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        });
                                      },
                                      button2Text: 'Cancel',
                                      button2Action: () =>
                                          Navigator.pop(context),
                                      buttonColor: Colors.red,
                                      outlineButtonColor: Colors.red);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFEA5B5B),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Delete',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 72),
                          ],
                        ),
                      ),
                    ),
                    context: context,
                  );
                },
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(8.0),
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MembersScreen(
                                  groupName: groups![index].title,
                                  groupId: groups![index].id,
                                ))),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor:
                              const Color.fromRGBO(14, 116, 144, 1),
                          child: Text(
                            'G${index + 1}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                            width: 8), // Space between avatar and text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHeader(context,
                                  name: groups![index].title,
                                  time:
                                      "${hour.toString().padLeft(2, '0')}:${localTime.minute.toString().padLeft(2, '0')}${localTime.hour >= 12 ? 'PM' : 'AM'}"),
                              const SizedBox(height: 8),
                              const Text(
                                'Hi!!',
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context, {
    required String name,
    required String time,
  }) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(name,
          style: CustomTextStyles.titleSmallTeal900
              .copyWith(color: appTheme.teal900)),
      Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(time,
              style: CustomTextStyles.bodySmallTeal900
                  .copyWith(color: appTheme.teal900)))
    ]);
  }
}
