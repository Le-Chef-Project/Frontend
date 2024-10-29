import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Api/apimethods.dart';
import 'package:le_chef/Models/Quiz.dart';
import 'package:le_chef/Screens/admin/AddExam.dart';
import 'package:le_chef/Shared/custom_app_bar.dart';
import 'package:le_chef/Widgets/total_exams-students_card.dart';

import '../Shared/customBottomNavBar.dart';
import '../Widgets/customExamWidgets.dart';
import '../main.dart';
import 'user/Home.dart';
import 'chats.dart';
import 'notification.dart';

class Exams extends StatefulWidget {
  const Exams({super.key});

  @override
  State<Exams> createState() => _ExamsState();
}

class _ExamsState extends State<Exams> with TickerProviderStateMixin {
  late TabController _tabController;
  int selectedUnit = 1;
  bool isLocked = true;
  String? role = sharedPreferences.getString('role');
  bool _isLoading = true;
  List<Quiz> _exams = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          selectedUnit = _tabController.index + 1;
        });
      }
    });
    getExams();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> getExams() async {
    _exams = await ApisMethods.getAllQuizzes();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Quiz> filteredExams =
        _exams.where((quiz) => quiz.unit == selectedUnit).toList();
    print(' tryyyyyyyyyy quizeeeeeee ${filteredExams}');

    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Exams'),
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            role == 'admin'
                ? totalStudent(context, 'Total Exams', '${_exams.length}',
                    buttonText: 'Add Exam', ontap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddExam()));
                  })
                : Center(
                    child: Image.asset(
                      'assets/Wonder Learners Graduating.png',
                      width: 300,
                      height: 300,
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: const Color(0xFF427D9D),
                    unselectedLabelColor: const Color(0xFF427D9D),
                    indicatorColor: const Color(0xFF427D9D),
                    dividerColor: Colors.transparent,
                    labelStyle: GoogleFonts.ibmPlexMono(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1,
                    ),
                    unselectedLabelStyle: GoogleFonts.ibmPlexMono(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      height: 1,
                    ),
                    indicator: CircleTabIndicator(radius: 4.0),
                    tabs: List.generate(
                      5,
                      (index) => Tab(
                        child: Text(
                          'Unit ${index + 1}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: filteredExams.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBFAFA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: customExamListTile(
                        index,
                        selectedUnit,
                        context,
                        isLocked,
                        _exams[index],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
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
      ),
    );
  }
}

class CircleTabIndicator extends Decoration {
  final double radius;
  final Color color;

  CircleTabIndicator({
    required this.radius,
    this.color = const Color(0xFF427D9D),
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CirclePainter(radius: radius, color: color);
  }
}

class _CirclePainter extends BoxPainter {
  final double radius;
  final Color color;

  _CirclePainter({
    required this.radius,
    required this.color,
  });

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
