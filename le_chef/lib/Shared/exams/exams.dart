import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Models/Quiz.dart';
import 'package:le_chef/Screens/admin/AddExam.dart';
import 'package:le_chef/Shared/custom_app_bar.dart';
import 'package:le_chef/Widgets/total_exams-students_card.dart';
import 'package:le_chef/services/content/quiz_service.dart';

import '../../Screens/admin/THome.dart';
import '../../Screens/admin/payment_request.dart';
import '../../main.dart';
import '../../services/auth/login_service.dart';
import '../customBottomNavBar.dart';
import '../../Widgets/customExamWidgets.dart';
import '../../Screens/user/Home.dart';
import '../../Screens/chats/chats.dart';
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
  bool _isLoadingExams = true;
  bool _isLoadingFilteredExams = true;
  bool _isLoading = true;
  List<Quiz> _exams = [];
  List<Quiz> _filteredExams = [];
  List _units = [];
  List<String>? quizIds;
  QuizResponse? _quizResponse; // Store the API response

  final int _ExamsLength = sharedPreferences!.getInt('ExamsLength') ?? 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> fetchSubmittedQuizzes() async {
    // Fetch submitted quiz IDs
    List<String> Ids = await QuizService.getSubmittedQuizIds();
    print('Fetched Quiz IDs: $Ids');
    setState(() {
      quizIds = Ids;
    });
  }

  Future<void> _initializeData() async {
    try {
      await fetchSubmittedQuizzes();
      // First load units
      await getUnits();
      // Then load exams
      await getExams();
      // Initialize tab controller after data is loaded
      _tabController = TabController(length: _units.length, vsync: this);
      _tabController.addListener(_handleTabChange);
      // Initial filtering
      _filterExams();

      setState(() {
        _isLoading = false;
        _isLoadingExams = false;
      });
    } catch (e) {
      print('Error initializing data: $e');
      setState(() {
        _isLoading = false;
        _isLoadingExams = false;
      });
    }
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
    if (_exams.isEmpty) return;

    setState(() {
      _filteredExams = _exams
          .where((quiz) =>
              quiz.unit == selectedUnit && quiz.level == widget.selectedLevel)
          .toList();
      print('Filtered Exams for unit $selectedUnit: ${_filteredExams.length}');
    });
  }

  Future<void> getExams() async {
    try {
      if (role == "admin") {
        _exams = await QuizService.getAllQuizzesAdmin(token!);
      } else {
        _quizResponse = await QuizService.getAllQuizzesUser(token!);
        _exams = _quizResponse!.quizzes;
      }

      print('Total Exams loaded: ${_exams.length}');
    } catch (e) {
      print('Error loading Exams: $e');
      rethrow;
    }
  }

  Future<void> getUnits() async {
    try {
      final units = await QuizService.getExamUnits();
      setState(() {
        _units = units;
      });
      print('Total units loaded: ${_units.length}');
    } catch (e) {
      print('Error loading units: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(' tryyyyyyyyyy quizeeeeeee $_filteredExams');

    return Scaffold(
      appBar: const CustomAppBar(title: 'Exams'),
      backgroundColor: Colors.white,
      body: _isLoading || _isLoadingExams
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                role == 'admin'
                    ? totalStudent(context, 'Total Exams', '${_ExamsLength}',
                        buttonText: 'Add Exam', ontap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddExam()));
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
                              _units[index],
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
                            'No Exams available for Unit $selectedUnit',
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFBFAFA),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: customExamListTile(
                                  index,
                                  context,
                                  role == "admin"
                                      ? false
                                      : !(_quizResponse!.quizPaidContentIds
                                              .contains(exam.id) ||
                                          !exam.isPaid),
                                  exam,
                                  quizIds!,
                                ),
                              ),
                            );
                          },
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
