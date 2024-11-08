import 'package:flutter/material.dart';
import 'package:le_chef/Models/Student.dart';
import 'package:le_chef/Screens/chatPage.dart';
import 'package:le_chef/Screens/members_screen.dart';
import 'package:le_chef/Shared/customBottomNavBar.dart';

import '../Shared/custom_app_bar.dart';
import '../theme/custom_text_style.dart';
import '../theme/theme_helper.dart';
import 'user/Home.dart';
import 'notification.dart';

class Chats extends StatelessWidget {
  final int _selectedIndex = 2;

  const Chats({super.key}); // Initial index for Chats screen

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
                groupChat(context),
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
}

Widget PersonalChat(BuildContext context) {
  Student std = Student(username: 'saso', Lastname: 'Saiid', firstname: 'thaowpsta', email: 'thaowpsta@gmail.com', phone: '01211024432', ID: '671bb7965c2d72826a977b76');
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
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(receiver: std,)));
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
  return SingleChildScrollView(
    child: Column(
      children: [
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemCount: 3,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(groupName: "Group ${index + 1}", membersNumber: 34,)));
              },
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.all(8.0),
                width: double.infinity,
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MembersScreen(groupName: "Group ${index + 1}", membersNumber: 34,))),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: const Color.fromRGBO(14, 116, 144, 1),
                        child: Text(
                          'G${index + 1}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8), // Space between avatar and text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(context,
                                name: "Group ${index + 1}", time: "10:30PM"),
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
