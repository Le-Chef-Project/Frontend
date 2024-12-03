import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/main.dart';
import '../../../Shared/customBottomNavBar.dart';
import '../../Api/apimethods.dart';
import '../../Models/session.dart';
import '../../Screens/admin/THome.dart';
import '../../Screens/admin/payment_request.dart';
import '../../Screens/chats/chats.dart';
import '../../Screens/notification.dart';
import '../../Screens/user/Home.dart';
import '../../Widgets/meeting/join_meeting.dart';
import '../../Widgets/meeting/meeting_not_started.dart';

class OnlineSessionScreen extends StatefulWidget {
  const OnlineSessionScreen({super.key});

  @override
  State<OnlineSessionScreen> createState() => _OnlineSessionScreenState();
}

class _OnlineSessionScreenState extends State<OnlineSessionScreen> {
  final String? role = sharedPreferences!.getString('role');
  List<Session> sessions = [];

  // Future<List<Session>> getSessions() async {
  //   try{
  //     sessions = await ApisMethods.getSessions();
  //     print('Session Returnedddd: $sessions');
  //     return sessions;
  //   }catch(e){
  //     throw('Error creating session: $e');
  //   }
  // }

  bool level1 = true;

  bool level2 = false;

  bool level3 = false;

  @override
  Widget build(BuildContext context) {
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
        title: Text(
          'Online Sessions',
          style: GoogleFonts.ibmPlexMono(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _buildBody(context),
      bottomNavigationBar: CustomBottomNavBar(
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

  Widget _buildBody(BuildContext context) {
    if (role == 'admin') {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  bool isActive = index == 0
                      ? level1
                      : index == 1
                          ? level2
                          : level3;

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Level ${index + 1}',
                              style: GoogleFonts.ibmPlexMono(
                                color: const Color(0xFF164863),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Switch(
                              value: isActive,
                              activeColor: const Color(0xFF00B84A),
                              thumbColor:
                                  const WidgetStatePropertyAll(Colors.white),
                              onChanged: (bool value) {
                                if (value) {
                                  setState(() {
                                    level1 = false;
                                    level2 = false;
                                    level3 = false;

                                    if (index == 0) {
                                      level1 = true;
                                    } else if (index == 1)
                                      level2 = true;
                                    else
                                      level3 = true;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Divider(
                          color: Color(0xFFC6C6C8),
                          thickness: 0.5,
                        ),
                      ),
                    ],
                  );
                }),
          ),
          const SizedBox(
            height: 20,
          ),
          joinMeeting(context, role, level1
              ? 1
              : level2
              ? 2
              : 3,),
        ],
      );
    } else {
      if (sessions.isNotEmpty) {
        return joinMeeting(context, role, null);
      } else {
        return meetingNotStarted(context);
      }
    }
  }
}
