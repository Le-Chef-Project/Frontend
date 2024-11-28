import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Api/apimethods.dart';
import 'package:le_chef/Models/Student.dart';
import 'package:le_chef/Models/session.dart';

import '../../Screens/user/Home.dart';
import '../../Shared/meeting/meeting_screen.dart';

 Future<void> createSession(educationalLevel) async {
   try{
   await ApisMethods.createSession(educationalLevel);
   print('Session Created');
   }catch(e){
     print('Error creating session: $e');
   }
}

 Future<List<Session>> getSessions() async {
   try{
   var session = await ApisMethods.getSessions();
   print('Session Returnedddd: $session');
   return session;
   }catch(e){
     throw('Error creating session: $e');
   }
}

Future<List<Student>> getStudents(int educationalLevel) async {
  List<Student> allStudents = await ApisMethods.AllStudents();

  List<Student> filteredStudents = allStudents.where((student) {
    return student.educationLevel == educationalLevel;
  }).toList();
  return filteredStudents;
}

Widget joinMeeting(BuildContext context, String? role, int? educationalLevel) {
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
                      onPressed: () async{
                        List<Student> stds = await getStudents(educationalLevel!);
                        createSession(educationalLevel);
                        await ApisMethods.sendNotificationsToStudents(stds);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const MeetingPage()));
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
                        getSessions();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MeetingPage()));
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
