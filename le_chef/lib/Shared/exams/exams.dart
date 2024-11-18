import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Api/apimethods.dart';
import 'package:le_chef/Models/Quiz.dart';
import 'package:le_chef/Screens/admin/AddExam.dart';
import 'package:le_chef/Shared/custom_app_bar.dart';
import 'package:le_chef/Widgets/total_exams-students_card.dart';

import '../customBottomNavBar.dart';
import '../../Widgets/customExamWidgets.dart';
import '../../main.dart';
import '../../Screens/user/Home.dart';
import '../../Screens/chats.dart';
import '../../Screens/notification.dart';

class Exams extends StatefulWidget {
  final int selectedLevel;
  const Exams({super.key, required this.selectedLevel});

  @override
  State<Exams> createState() => _ExamsState();
}

class _ExamsState extends State<Exams> with TickerProviderStateMixin {
  late TabController _tabController;
  int selectedUnit = 1;
  String? role = sharedPreferences!.getString('role');
  bool _isLoading = true;
  List<Quiz> _exams = [];
  List<Quiz> _filteredExams = [];
  List _units = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _units.length, vsync: this);
    _tabController.addListener(_handleTabChange);
    getUnits();
    getExams();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        selectedUnit = _tabController.index + 1;
        _filterExams();
      });
    }
  }

  void _filterExams() {
    setState(() {
      print('Calling filter func');
      _filteredExams = _exams
          .where((quiz) =>
              quiz.unit == selectedUnit && quiz.level == widget.selectedLevel)
          .toList();
      print('Filtered exams for unit $selectedUnit: ${_filteredExams.length}');

      for (var exam in _filteredExams) {
        print(
            'Exam: ${exam.title}, Unit: ${exam.unit}, Questions: ${exam.questions.length}, duration: ${exam.duration.toString()}');
      }
    });
  }

  Future<void> getExams() async {
    try {
      final exams = await ApisMethods.getAllQuizzes();
      setState(() {
        _exams = exams;
        _isLoading = false;
        _filterExams();
      });
      print('Total exams loaded: ${_exams.length}');
    } catch (e) {
      print('Error loading exams: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> getUnits() async {
    try {
      final units = await ApisMethods.getExamUnits();
      setState(() {
        _units = units;
        _isLoading = false;
        _tabController = TabController(length: _units.length, vsync: this);
        _tabController.addListener(_handleTabChange);
        _filterExams();
      });
      print('Total units loaded: ${_units.length}');
    } catch (e) {
      print('Error loading units: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(' tryyyyyyyyyy quizeeeeeee $_filteredExams');

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
                        MaterialPageRoute(builder: (context) => const AddExam()));
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
                    indicator: const CircleTabIndicator(radius: 4.0),
                    tabs: List.generate(
                      _units.length,
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
              child: _filteredExams.isEmpty
                  ? Center(
                      child: Text(
                        'No exams available for Unit $selectedUnit',
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: _filteredExams.length,
                      itemBuilder: (context, index) {
                        final exam = _filteredExams[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFBFAFA),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: customExamListTile(
                              index,
                              context,
                              exam.isPaid,
                              exam,
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

  const CircleTabIndicator({
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
