import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Models/Student.dart';
import 'package:le_chef/Models/direct_chat.dart';
import 'package:le_chef/Models/group_chat.dart';
import 'package:le_chef/Screens/admin/THome.dart';
import 'package:le_chef/Screens/admin/selectStudent.dart';
import 'package:le_chef/Screens/chats/chatPage.dart';
import 'package:le_chef/Screens/members_screen.dart';
import 'package:le_chef/Shared/customBottomNavBar.dart';

import '../../Api/apimethods.dart';
import '../../Models/group.dart';
import '../../Shared/custom_app_bar.dart';
import '../../Shared/textInputDecoration.dart';
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
  final TextEditingController _TitleController = TextEditingController();
  final TextEditingController _DescriptionController = TextEditingController();
  List<Group>? groups;
  bool _isLoading_grp = true;
  List<DirectChat>? chats;
  bool _isLoading_chat = true;
  final String? _userId = sharedPreferences!.getString('_id');


  Future<void> getStd() async {
    groups = await ApisMethods.getAllGroups();
    print('group infooooooooo ${groups!}');
    setState(() {
      _isLoading_grp = false;
    });
  }

  Future<void> getChats() async {
    chats = await ApisMethods.getAllChats();
    print('Chat infooooooooo ${chats}');
    setState(() {
      _isLoading_chat = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getStd();
    getChats();
  }

  String _getParticipantName(DirectChat chat) {
    final participant = chat.participants.firstWhere(
          (p) => p.id != _userId,
      orElse: () => Participant(id: '', username: 'Unknown', email: ''),
    );
    return participant.username;
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
                _isLoading_grp
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : chats!.isNotEmpty
                    ? PersonalChat(context)
                    : const Center(
                  child: Text('no Chats yet'),
                ),
              ],
            ),
          ),
          floatingActionButton: role == 'admin'
              ? FloatingActionButton(
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: Image.asset(
                      'assets/group.jpg',
                      width: 96.53,
                      height: 96.37,
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 275,
                            child: Text(
                              'Add Group Title',
                              style: GoogleFonts.ibmPlexMono(
                                color: const Color(0xFF164863),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _TitleController,
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Title'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter a Title';
                              } //TODO
                              //check isFound or not
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: 275,
                            child: Text(
                              'Add Group Description',
                              style: GoogleFonts.ibmPlexMono(
                                color: const Color(0xFF164863),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _DescriptionController,
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Description'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter a Description';
                              } //TODO
                              //check isFound or not
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: 140.50,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_TitleController.text.isEmpty ||
                                        _DescriptionController
                                            .text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please fill in all fields')),
                                      );
                                    } else {
                                      await ApisMethods.createGrp(
                                        _TitleController.text.toString(),
                                        _DescriptionController.text
                                            .toString(),
                                      );
                                      _TitleController.clear();
                                      _DescriptionController.clear();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    const Color(0xFF427D9D),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Create Group',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.ibmPlexMono(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: SizedBox(
                                width: 140.50,
                                height: 48,
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        color: Color(0xFF427D9D)),
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 1,
                                          color: Color(0xFF427D9D)),
                                      borderRadius:
                                      BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.ibmPlexMono(
                                      color: const Color(0xFF427D9D),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
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
              : null,
          // No button for non-admin roles
          bottomNavigationBar: CustomBottomNavBar(
            onItemTapped: (index) {
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
            itemCount: chats!.length,
            itemBuilder: (context, index) {

              String isoTime = chats![index].createdAt;

              DateTime dateTime = DateTime.parse(isoTime);

              DateTime localTime = dateTime.toLocal();

              int hour = localTime.hour % 12 == 0 ? 12 : localTime.hour % 12;
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ChatPage(
                                receiver: std,
                                person: true,
                              )));
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: Image
                            .asset(
                          'assets/bccb46bd-67fe-47c7-8e5e-3dd39329d638.webp',
                          height: 50,
                          width: 49,
                        )
                            .image,
                      ),
                    ),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            _buildHeader(context,
                            name:  _getParticipantName(chats![index]),
                                time: "${hour.toString()
                                .padLeft(2, '0')}:${localTime.minute.toString()
                                .padLeft(2, '0')}${localTime.hour >= 12
                                ? 'PM'
                                : 'AM'}"),
                            const SizedBox(height: 8),
                            Text(
                              chats![index].messages.last.content ??
                                  'No Message',
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ChatPage(group: groups?[index], person: false,)));
                },
                onLongPress: () async {
                  role == 'admin'
                      ? showModalBottomSheet(
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    builder: (context) =>
                        Container(
                          decoration: BoxDecoration(
                            color:
                            Colors.white, // Background color of the modal
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
                                  width:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.7,
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height *
                                      0.06,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      const Color(0xFF427D9D),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(12),
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
                                  width:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.7,
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height *
                                      0.06,
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
                                                const Duration(seconds: 1),
                                                    () {
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
                                      backgroundColor:
                                      const Color(0xFFEA5B5B),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(12),
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
                  )
                      : null;
                },
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(8.0),
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () =>
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MembersScreen(
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
                                  "${hour.toString().padLeft(
                                      2, '0')}:${localTime.minute.toString()
                                      .padLeft(2, '0')}${localTime.hour >= 12
                                      ? 'PM'
                                      : 'AM'}"),
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

  Widget _buildHeader(BuildContext context, {
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
