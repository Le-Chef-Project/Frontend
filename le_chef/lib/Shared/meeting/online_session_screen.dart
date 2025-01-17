import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/main.dart';
import 'package:le_chef/services/session/session_service.dart';
import '../../../Shared/customBottomNavBar.dart';
import '../../Models/session.dart';
import '../../Screens/admin/THome.dart';
import '../../Screens/admin/payment_request.dart';
import '../../Screens/chats/chats.dart';
import '../../Screens/notification.dart';
import '../../Screens/user/Home.dart';
import '../../Widgets/meeting/build_body.dart';
import '../../Widgets/meeting/join_meeting.dart';
import '../../Widgets/meeting/meeting_not_started.dart';

class OnlineSessionScreen extends StatefulWidget {
  const OnlineSessionScreen({super.key});

  @override
  State<OnlineSessionScreen> createState() => _OnlineSessionScreenState();
}

class _OnlineSessionScreenState extends State<OnlineSessionScreen> {
  final String? role = sharedPreferences!.getString('role');
  List<Session> sessions_list = [];
  bool loading = true;

  bool level1 = true;

  bool level2 = false;

  bool level3 = false;

  @override
  void initState() {
    getSessions();
    super.initState();
  }

  Future<void> getSessions() async {
    if (role != 'admin') {
      try {
        sessions_list = await SessionService.getSessions();
        setState(() {
          loading = false;
        });
        print('sessions Apiii: ${sessions_list.last.zoomMeetingId}');
      } catch (e) {
        print('Error loading Sessions: $e');
      }
    }
  }

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
      body: BuildBody(role: role, sessions_list: sessions_list, loading: loading,),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PaymentRequest()));
              }
          }
        },
        context: context,
        userRole: role!,
      ),
    );
  }
}
