import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Screens/admin/payment_request.dart';
import 'package:le_chef/Screens/user/examsResults.dart';
import '../../Shared/customBottomNavBar.dart';
import '../../Shared/custom_app_bar.dart';
import '../../Widgets/total_exams-students_card.dart';
import '../../main.dart';
import '../chats/chats.dart';
import '../notification.dart';
import '../user/Home.dart';
import 'PDFs.dart';
import 'THome.dart';
import 'Videos.dart';
import 'addLibrary.dart';

class LibraryTabContainerScreen extends StatefulWidget {
  final int selectedLevel;
  final int? pdfLength;
  final int? examsLength;
  final int? videosLength;
  final int? libraryLength;

  const LibraryTabContainerScreen(
      {super.key,
      required this.selectedLevel,
      this.pdfLength,
      this.libraryLength,
      this.examsLength,
      this.videosLength});

  @override
  LibraryTabContainerScreenState createState() =>
      LibraryTabContainerScreenState();
}

// ignore_for_file: must_be_immutable
class LibraryTabContainerScreenState extends State<LibraryTabContainerScreen>
    with TickerProviderStateMixin {
  late TabController tabviewController;
  String? role = sharedPreferences!.getString('role');

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  int currentIndex = 0; // Add this to track current tab index

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(
      length: role == 'admin' ? 3 : 4,
      vsync: this,
    );
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
        appBar: const CustomAppBar(
          title: 'Library',
        ),
        body: Column(
          children: [
            role == 'admin'
                ? totalStudent(
                    buttonText: 'Add to Library',
                    context,
                    'Total Items in Library',
                    '${widget.libraryLength}',
                    isLibrary: true,
                    ontap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddLibrary()),
                    ),
                  )
                : Center(
                    child: Image.asset(
                      'assets/Wonder Learners Graduating.png',
                      width: 300,
                      height: 300,
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
                tabs: role == 'admin'
                    ? [
                        const Tab(child: Text('Videos')),
                        const Tab(child: Text('Books')),
                        const Tab(child: Text('PDFs')),
                      ]
                    : [
                        const Tab(child: Text('Videos')),
                        const Tab(child: Text('Books')),
                        const Tab(child: Text('PDFs')),
                        const Tab(
                          child: Text('Exams Results'),
                        )
                      ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TabBarView(
                controller: tabviewController,
                children: role == 'admin'
                    ? [
                        VideoListScreen(selectedLevel: widget.selectedLevel),
                        const Text('hello'),
                        AllPDFs(selectedLevel: widget.selectedLevel),
                      ]
                    : [
                        VideoListScreen(selectedLevel: widget.selectedLevel),
                        const Text('hello'),
                        AllPDFs(selectedLevel: widget.selectedLevel),
                        const ExamsResults(),
                      ],
              ),
            ),
          ],
        ),
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
                  MaterialPageRoute(
                      builder: (context) => const Notifications()),
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
      ),
    );
  }
}

class Circletabindicator extends Decoration {
  final Color color = const Color(0xFF427D9D);
  double radius;
  Circletabindicator({required this.radius});
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
    final Paint paint = Paint()
      ..color = color
      ..isAntiAlias = true;

    final Offset circleOffset =
        offset + Offset(cfg.size!.width / 2, cfg.size!.height - radius);
    canvas.drawCircle(circleOffset, radius, paint);
  }
}
