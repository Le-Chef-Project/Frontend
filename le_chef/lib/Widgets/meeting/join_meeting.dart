import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Models/Student.dart';
import 'package:le_chef/services/session/session_service.dart';
import 'package:le_chef/services/student/student_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Screens/admin/THome.dart';
import '../../Screens/user/Home.dart';
import '../../services/auth/login_service.dart';

Future<void> createSession(int level, BuildContext context) async {
  try {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Card(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Creating session...')
                ],
              ),
            ),
          ),
        );
      },
    );

    final link = await SessionService.createSession(level);

    Navigator.pop(context);

    final Uri url = Uri.parse(link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  } catch (e) {
    Navigator.pop(context);
    print('Error creating session: $e');
  }
}

Future<List<Student>> getStudents(int educationalLevel) async {
  List<Student> allStudents = await StudentService.AllStudents(token!);

  List<Student> filteredStudents = allStudents.where((student) {
    return student.educationLevel == educationalLevel;
  }).toList();
  return filteredStudents;
}

Future<void> join(String meetingId, BuildContext context) async {
  try {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Card(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Joining to session...')
                ],
              ),
            ),
          ),
        );
      },
    );

    final link = await SessionService.joinMeeting(meetingId);

    Navigator.pop(context);

    final Uri url = Uri.parse(link);
    if (!await launchUrl(url, mode: LaunchMode.platformDefault)) {
      throw 'Could not join $url';
    }
  } catch (e) {
    Navigator.pop(context);
    print('Error joining session: $e');
  }
}

Widget joinMeeting(BuildContext context, String? role, int? educationalLevel,
    String? meetingId) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/Humaaans 3 Characters.png'),
        const SizedBox(
          height: 81,
        ),
        Text(
          'Tap to ${role == 'admin' ? 'Create' : 'Join'} meeting',
          style: GoogleFonts.ibmPlexMono(
            color: const Color(0xFF3D3D3D),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 26),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/video_svgrepo.com.png'),
            const SizedBox(width: 35),
            const Icon(Icons.mic, color: Color(0xFF164863), size: 40),
          ],
        ),
        const SizedBox(height: 42),
        role == 'admin'
            ? Row(children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        List<Student> stds =
                            await getStudents(educationalLevel!);
                        createSession(educationalLevel, context);
                        // await ApisMethods.sendNotificationsToStudents(stds);
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const MeetingPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF427D9D),
                        padding: const EdgeInsets.symmetric(vertical: 14.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Create Meeting',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ibmPlexMono(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
              ])
            : Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        join(meetingId!, context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF427D9D),
                        padding: const EdgeInsets.symmetric(vertical: 14.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Join Meeting',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ibmPlexMono(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Home()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                              color: Color(0xFF427D9D),
                              width: 2,
                            )),
                      ),
                      child: Text(
                        'Home Page',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ibmPlexMono(
                          color: const Color(0xFF427D9D),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ],
    ),
  );
}
