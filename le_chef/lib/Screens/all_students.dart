import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Shared/custom_app_bar.dart';
import 'package:le_chef/Shared/custom_search_view.dart';

import '../Shared/customBottomNavBar.dart';
import 'Home.dart';
import 'chats.dart';
import 'notification.dart';

class AllStudents extends StatelessWidget {

  final String userImg = 'assets/bccb46bd-67fe-47c7-8e5e-3dd39329d638.webp';
  final List usersName = ['Mhammed Ali', 'Jouna Moayyad', 'Hawraa Mahmoud', 'Ruqaya Layth', 'Aya Abd Alazyz', 'Ibrahem Abas'];
  final double studentsNumber = 16.5;

  AllStudents({super.key});

  totalStudent(BuildContext context) {
    return Container(
        width: 317,
        height: 83,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x4C427D9D),
              blurRadius: 32.50,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Total Students',
                    style: GoogleFonts.ibmPlexMono(
                      color: Color(0xFF164863),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                  const SizedBox(width: 50),
                  Container(
                    decoration: ShapeDecoration(
                      color: const Color(0xFFDDF2FD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${studentsNumber}K',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ibmPlexMono(
                          color: Color(0xFF164863),
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'All Students'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: 39,),
            totalStudent(context),
            SizedBox(height: 43,),
            CustomSearchView(clear: (){}, hintText: 'search by student name', hintStyle: GoogleFonts.ibmPlexMono(color: Color(0xFF888888),
              fontSize: 14,
              fontWeight: FontWeight.w500,),),
            SizedBox(height: 59,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Name',
                    style: GoogleFonts.ibmPlexMono(
                      color: Color(0xFF164863),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),),
                  Text('Action',
                    style: GoogleFonts.ibmPlexMono(
                      color: Color(0xFF164863),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),)
                ],
              ),
            ),
            SizedBox(height: 32,),
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
                      trailing: IconButton(
                        icon: Image.asset('assets/trash.png'),
                        onPressed: () {
                          //ToDo delete logic
                        },
                      ),
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
