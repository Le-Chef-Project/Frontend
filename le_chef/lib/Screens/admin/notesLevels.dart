import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Shared/custom_app_bar.dart';
import '../../Widgets/total_exams-students_card.dart';
import '../Notes.dart';
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
        appBar: CustomAppBar(
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
                MaterialPageRoute(builder: (context) => addNotes()),
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
                indicator: Circletabindicator(radius: 4.0),
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
                children: [NotesScreen(), NotesScreen(), NotesScreen()],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class Circletabindicator extends Decoration {
  final Color color = const Color(0xFF427D9D);
  final double radius;

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
    if (cfg.size == null) return; // Add null check for cfg.size

    final Paint paint = Paint()
      ..color = color
      ..isAntiAlias = true;

    final Offset circleOffset =
        offset + Offset(cfg.size!.width / 2, cfg.size!.height - radius);
    canvas.drawCircle(circleOffset, radius, paint);
  }
}
