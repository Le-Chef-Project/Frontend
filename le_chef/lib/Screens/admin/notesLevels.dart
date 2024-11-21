import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Shared/customBottomNavBar.dart';
import '../../Shared/custom_app_bar.dart';
import '../../Widgets/total_exams-students_card.dart';
import '../../main.dart';
import '../Notes.dart';
import '../chats/chats.dart';
import '../notification.dart';
import '../user/Home.dart';
import 'THome.dart';
import 'addNotes.dart';
// ... other imports remain the same

class NotesTabContainerScreen extends StatefulWidget {
  const NotesTabContainerScreen({Key? key}) : super(key: key);

  @override
  NotesTabContainerScreenState createState() => NotesTabContainerScreenState();
}

class NotesTabContainerScreenState extends State<NotesTabContainerScreen>
    with TickerProviderStateMixin {
  late final TabController tabviewController; // Make this late final
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  int currentIndex = 0;
  List<dynamic> members = [];

  String? role = sharedPreferences!.getString('role');

  @override
  void initState() {
    super.initState();
    // Initialize the controller in initState
    tabviewController = TabController(length: 3, vsync: this);
    tabviewController.addListener(() {
      if (tabviewController.indexIsChanging) {
        // Remove null check
        setState(() {
          currentIndex = tabviewController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    tabviewController.dispose(); // Clean up the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(
          title: 'Notes',
        ),
        body: Column(
          children: [
            totalStudent(
              buttonText: 'Add to Notes',
              context,
              'Total Items in Notes',
              '150',
              ontap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const addNotes()),
              ),
            ),
            Material(
              color: Colors.white,
              child: TabBar(
                labelColor: const Color(0xFF427D9D),
                unselectedLabelColor: const Color(0xFF427D9D),
                controller: tabviewController,
                indicatorColor: const Color(0xFF427D9D),
                dividerColor: Colors.transparent,
                labelStyle: GoogleFonts.ibmPlexMono(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                unselectedLabelStyle: GoogleFonts.ibmPlexMono(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
                indicator: const Circletabindicator(radius: 4.0),
                tabs: const [
                  Tab(child: Text('Level 1')),
                  Tab(child: Text('Level 2')),
                  Tab(child: Text('Level 3')),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: tabviewController,
                children: const [
                  NotesScreen(level: 1),
                  NotesScreen(level: 2),
                  NotesScreen(level: 3)
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
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
      ),
    );
  }
}

class Circletabindicator extends Decoration {
  final Color color = const Color(0xFF427D9D);
  final double radius;

  const Circletabindicator({required this.radius});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CirclePainter(radius: radius);
  }
}

class _CirclePainter extends BoxPainter {
  final double radius;
  final Color color = const Color(0xFF427D9D);

  _CirclePainter({required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    if (cfg.size == null) return; // Add null check for cfg.size

    final Paint paint = Paint()
      ..color = color
      ..isAntiAlias = true;

    final Offset circleOffset =
        offset + Offset(cfg.size!.width / 2, cfg.size!.height - radius);
    canvas.drawCircle(circleOffset, radius, paint);
  }
}
