import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Api/apimethods.dart';
import 'package:le_chef/Screens/admin/all_students.dart';
import 'package:le_chef/Screens/chats.dart';
import 'package:le_chef/Screens/exams.dart';
import 'package:le_chef/Shared/custom_elevated_button.dart';
import '../../Models/Student.dart';
import '../../Shared/customBottomNavBar.dart';
import '../../Shared/custom_app_bar.dart';
import '../../Shared/textInputDecoration.dart';
import '../../Widgets/total_exams-students_card.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/theme_helper.dart';
import '../Notes.dart';
import '../notification.dart';
import 'PDFs.dart';
import 'Videos.dart';
import 'addLibrary.dart';

class LibraryTabContainerScreen extends StatefulWidget {
  const LibraryTabContainerScreen({Key? key}) : super(key: key);

  @override
  LibraryTabContainerScreenState createState() =>
      LibraryTabContainerScreenState();
}

// ignore_for_file: must_be_immutable
class LibraryTabContainerScreenState extends State<LibraryTabContainerScreen>
    with TickerProviderStateMixin {
  late TabController tabviewController;

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  int currentIndex = 0; // Add this to track current tab index

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 3, vsync: this);
    // Add listener for tab changes
    tabviewController.addListener(() {
      if (tabviewController.indexIsChanging) {
        setState(() {
          currentIndex = tabviewController.index;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'Library',
        ),
        body: Column(
          children: [
            totalStudent(
              buttonText: 'Add to Library',
              context,
              'Total Items in Library',
              '150',
              isLibrary: true,
              ontap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddLibrary()),
              ),
            ),
            Material(
              color: Colors.white,
              child: TabBar(
                labelColor: Color(0xFF427D9D),
                unselectedLabelColor: Color(0xFF427D9D),
                controller: tabviewController,
                indicatorColor: Color(0xFF427D9D),
                dividerColor: Colors.transparent,
                labelStyle: GoogleFonts.ibmPlexMono(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                unselectedLabelStyle: GoogleFonts.ibmPlexMono(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
                indicator: Circletabindicator(radius: 4.0),
                tabs: [
                  Tab(child: Text('Videos')),
                  Tab(child: Text('Books')),
                  Tab(child: Text('PDFs')),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: tabviewController,
                children: [
                  VideoListScreen(),
                  Text('hello'),
                  AllPDFs(),
                ],
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  total_student(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(27, 53, 26, 39),
      child: Container(
          width: 307,
          height: 149,
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
          child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            'Total Students',
                            style: GoogleFonts.ibmPlexMono(
                              color: const Color(0xFF164863),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(const AllStudents(),
                                transition: Transition.fadeIn,
                                duration: const Duration(seconds: 1));
                          },
                          child: Text(
                            'See all',
                            style: GoogleFonts.ibmPlexMono(
                              color: const Color(0xFF427D9D),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                    child: Row(
                      textBaseline: TextBaseline.ideographic,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Container(
                          height: 41,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFDDF2FD),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '110',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.ibmPlexMono(
                                color: const Color(0xFF164863),
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )),
                        const SizedBox(width: 20),
                        CustomElevatedButton(
                          height: 41,
                          width: 161,
                          text: "Add Student +",
                          buttonStyle: CustomButtonStyles.fillPrimaryTL5,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  )
                ]),
          )),
    );
  }
}

class Circletabindicator extends Decoration {
  final Color color = Color(0xFF427D9D);
  double radius;
  Circletabindicator({required this.radius});
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CirclePainter(radius: radius);
  }
}

class _CirclePainter extends BoxPainter {
  final double radius;
  final Color color;

  _CirclePainter({required this.radius, this.color = const Color(0xFF427D9D)});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Paint _paint = Paint()
      ..color = color
      ..isAntiAlias = true;

    final Offset circleOffset =
        offset + Offset(cfg.size!.width / 2, cfg.size!.height - radius);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}
