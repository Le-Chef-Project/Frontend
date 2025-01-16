import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Models/Admin.dart';
import 'package:le_chef/Models/Notes.dart';
import 'package:le_chef/Models/PDF.dart';
import 'package:le_chef/Screens/admin/all_students.dart';
import 'package:le_chef/Screens/admin/notesLevels.dart';
import 'package:le_chef/Screens/admin/payment_request.dart';
import 'package:le_chef/Screens/admin/studentProfile.dart';
import 'package:le_chef/Screens/chats/chats.dart';
import 'package:le_chef/Shared/custom_elevated_button.dart';
import 'package:le_chef/services/auth/admin_service.dart';
import 'package:le_chef/services/content/media_service.dart';
import 'package:le_chef/services/content/note_service.dart';
import 'package:le_chef/services/content/quiz_service.dart';
import 'package:le_chef/services/student/student_service.dart';
import '../../Models/Quiz.dart';
import '../../Models/Student.dart';
import '../../Models/Video.dart';
import '../../Shared/customBottomNavBar.dart';
import '../../Shared/login.dart';
import '../../Shared/meeting/online_session_screen.dart';
import '../../Shared/textInputDecoration.dart';
import '../../main.dart';
import '../../theme/custom_button_style.dart';
import '../../utils/SharedPrefes.dart';
import '../notification.dart';
import 'Exam&LibraryLevels.dart';

// SharedPreferences? sharedPreferences;
// String? token;


class THome extends StatefulWidget {
  const THome({super.key});

  @override
  State<THome> createState() => _THomeState();
}

class _THomeState extends State<THome> with SingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  final int _selectedIndex = 0;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isObscure = true;
  late AnimationController _animationController;
  late Animation<double> _animation;
  Admin? admin;
  bool _isLoading_admin = true;

  bool _isLoading_Std = true;
  List<Student>? _Std;
  List<Quiz>? _exams;
  bool _isLoading_Exams = true;
  List<Notes>? _notes;
  bool _isLoading_notes = true;
  List<PDF>? _pdfs;
  bool _isLoading_pdfs = true;
  List<Video>? _videos;
  bool _isLoading_videos = true;
  int? _PDFsLength;
  int? _VideosLength;
  int? _NotesLength;
  int? _ExamsLength;


  @override
  @override
  void initState() {
    super.initState();
    // _initializeSharedPreferences().then((_) {
      _loadSharedPreferences();
      _initializeData();
      _setupAnimation();
    // });
  }

  // Future<void> _initializeSharedPreferences() async {
  //   sharedPreferences = await SharedPreferences.getInstance();
  // }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  Future<void> _loadSharedPreferences() async {
    if (sharedPreferences != null) {
      token = sharedPreferences!.getString('token');
      _PDFsLength = sharedPreferences!.getInt('PDFsLength') ?? 0;
      _NotesLength = sharedPreferences!.getInt('NotesLength') ?? 0;
      _VideosLength = sharedPreferences!.getInt('VideosLength') ?? 0;
      _ExamsLength = sharedPreferences!.getInt('ExamsLength') ?? 0;

      print('Token Home: $token');
      print('Token pdf: $_PDFsLength');
      print('Token _NotesLength: $_NotesLength');
      print('Token _VideosLength: $_VideosLength');
      print('Token _ExamsLength: $_ExamsLength');
    } else {
      print('sharedPreferences is null');
    }
  }

  Future<void> _initializeData() async {
    try {
      await Future.wait([
        getStd(),
        getLibrary(),
        getNotes(),
        getAdmin(),
        getexams(),
      ]);
      print('All data initialized successfully');
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  Future<void> getLibrary() async {
    try {
      _pdfs = await MediaService.fetchAllPDFs(token!);
      print('PDF length: ${_pdfs?.length}');

      setState(() {
        _isLoading_pdfs = false;
        SharedPrefes.savePDFsLength(_pdfs?.length ?? 0);
      });

      _videos = await MediaService.fetchAllVideos();
      print('Video length: ${_videos?.length}');

      setState(() {
        _isLoading_videos = false;
        SharedPrefes.saveVideosLength(_videos?.length ?? 0);
      });
    } catch (e) {
      print('Error fetching library data: $e');
      setState(() {
        _isLoading_pdfs = false;
        _isLoading_videos = false;
      });
    }
  }

  Future<void> getNotes() async {
    try {
      _notes = await NoteService.fetchAllNotes(token!);
      print('Notes fetched: ${_notes?.length}');
      setState(() {
        _isLoading_notes = false;
        SharedPrefes.saveNotesLength(_notes?.length ?? 0);
      });
    } catch (e) {
      print('Error fetching notes: $e');
      setState(() {
        _isLoading_notes = false;
      });
    }
  }

  Future<void> getexams() async {
    try {
      _exams = await QuizService.getAllQuizzes(token!);
      print('Exams fetched: ${_exams?.length}');
      setState(() {
        _isLoading_Exams = false;
        SharedPrefes.saveExamsLength(_exams?.length ?? 0);
      });
    } catch (e) {
      print('Error fetching exams: $e');
      setState(() {
        _isLoading_Exams = false;
      });
    }
  }

  Future<void> getStd() async {
    try {
      _Std = await StudentService.AllStudents(token!);
      if (_Std != null) {
        print('Students fetched: ${_Std!.length}');
      } else {
        print('Students list is null');
      }
      setState(() {
        _isLoading_Std = false;
      });
    } catch (e) {
      print('Error fetching students: $e');
      setState(() {
        _isLoading_Std = false;
      });
    }
  }

  Future<void> getAdmin() async {
    try {
      admin = await AdminService.getAdmin(token!);
      if (admin != null) {
        print('Got Admin Successfully: ${admin!.username}');
      } else {
        print('Admin is null');
      }
      setState(() {
        _isLoading_admin = false;
      });
    } catch (e) {
      print('Error fetching admin: $e');
      setState(() {
        _isLoading_admin = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async {
    setState(() {
      getStd();
      getLibrary();
      getNotes();
      getAdmin();
      getexams();

    });
  }

  void _showSuccessDialogWithFade() {
    _animationController.forward();
    Get.dialog(
      FadeTransition(
        opacity: _animation,
        child: AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/correct sign.png',
                width: 117,
                height: 117,
              ),
              const SizedBox(height: 10),
              Text(
                'Success!',
                textAlign: TextAlign.center,
                style: GoogleFonts.ibmPlexMono(
                  color: const Color(0xFF164863),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Student Added Successfully',
                textAlign: TextAlign.center,
                style: GoogleFonts.ibmPlexMono(
                  color: const Color(0xFF888888),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Fade out when pressing "Ok"
                  _animationController.reverse().then((_) => Get.back());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF427D9D),
                  minimumSize: const Size(140.50, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Ok',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ibmPlexMono(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 1000),
    );
  }

  void _showfailedDialogWithFade(Mess) {
    _animationController.forward();
    Get.dialog(
      FadeTransition(
        opacity: _animation,
        child: AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/error-16_svgrepo.com.jpg',
                width: 117,
                height: 117,
              ),
              const SizedBox(height: 10),
              Text(
                'Error!',
                textAlign: TextAlign.center,
                style: GoogleFonts.ibmPlexMono(
                  color: const Color(0xFF164863),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '$Mess',
                textAlign: TextAlign.center,
                style: GoogleFonts.ibmPlexMono(
                  color: const Color(0xFF888888),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Fade out when pressing "Ok"
                  _animationController.reverse().then((_) => Get.back());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF427D9D),
                  minimumSize: const Size(140.50, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Try Again',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ibmPlexMono(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 1000),
    );
  }

  void _onAddStudentPressed() async {
    Get.back();
    String Mess;
    Mess = await StudentService.AddStudent(
      _emailController.text.toString(),
      _passwordController.text.toString(),
      _phoneController.text.toString(),
      _userNameController.text.toString(),
      _firstnameController.text.toString(),
      _lastnameController.text.toString(),
      _levelController.text.toString(),
    );
    if (Mess == 'success') {
      Future.delayed(const Duration(milliseconds: 300), () {
        _showSuccessDialogWithFade();
      });
    } else {
      Future.delayed(const Duration(milliseconds: 300), () {
        _showfailedDialogWithFade(Mess);
      });
    }
    _emailController.clear();
    _passwordController.clear();
    _phoneController.clear();
    _userNameController.clear();
    _firstnameController.clear();
    _lastnameController.clear();
    _levelController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _isLoading_admin
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              leading: GestureDetector(
                  onTap: () {
                    if (admin != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                  isStudent: false, admin: admin!)));
                    }
                  },
                  child: CircleAvatar(
                    radius: 25,
                    child: Image.network(admin!.imageUrl!),
                  )),
              actions: [
                GestureDetector(
                  onTap: () {
                    sharedPreferences!.remove('token');
                    Get.to(const Login());
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 23),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        'assets/logo.png',
                        height: 50,
                      ),
                    ),
                  ),
                ),
              ],
            ),
      body: _isLoading_admin || _isLoading_Std || _isLoading_pdfs || _isLoading_notes || _isLoading_Exams
          ? const Center(
        child: CircularProgressIndicator(),
      )
          :
      RefreshIndicator(
        onRefresh: onRefresh,
        backgroundColor: const Color(0xFF164863),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 8, 0, 0),
                    child: _isLoading_admin
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: const Color(0x00565656),
                                child: Text(
                                  'Hany Azmy',
                                  style: GoogleFonts.ibmPlexMono(
                                    color: const Color(0xFF164863),
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  'French Teacher',
                                  style: GoogleFonts.ibmPlexMono(
                                    color: const Color(0xFF427D9D),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                              )
                            ],
                          )),
              ),
              const SizedBox(height: 68),
              _isLoading_Std
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : total_student(context),
              const SizedBox(height: 68),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: _buildCardRec(
                        context,
                        Title: "Exams",
                        Number: _isLoading_Exams ? "..." : "${_ExamsLength!}",
                        ImagePath: 'assets/Wonder Learners Graduating.png',
                        onTapCardRec: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ExamLibraryLevels(title: 'Exams')),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildCardRec(
                        context,
                        Title: "Library",
                        Number: _isLoading_pdfs
                            ? '...'
                            : '${_PDFsLength! + _VideosLength!}',
                        ImagePath: 'assets/Charco Education.png',
                        onTapCardRec: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ExamLibraryLevels(
                                    title: 'Library',
                                  )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: _buildCardRec(
                        context,
                        Title: "Notes",
                        Number: _isLoading_notes ? '...' : '${_NotesLength!}',
                        ImagePath: 'assets/Wonder Learners Book.png',
                        onTapCardRec: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const NotesTabContainerScreen()),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: ShapeDecoration(
                          gradient: LinearGradient(
                            begin: const Alignment(0.00, -1.00),
                            end: const Alignment(0, 1),
                            colors: [
                              const Color(0x33DDF2FD),
                              const Color(0x89C8C8C8),
                              Colors.white.withOpacity(0)
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const OnlineSessionScreen()));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  'Online Sessions',
                                  style: GoogleFonts.ibmPlexMono(
                                    color: const Color(0xFF164863),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Image.asset(
                                'assets/Shopaholics Sitting On The Floor.png',
                                height: 228,
                                width: double.infinity,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        onItemTapped: (index) {
          switch (index) {
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
        selectedIndex: _selectedIndex,
        userRole: role!,
      ),
    );
  }

  Widget _buildCardRec(
    BuildContext context, {
    required String Title,
    required String Number,
    required String ImagePath,
    Function? onTapCardRec,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0.00, -1.00),
          end: const Alignment(0, 1),
          colors: [
            const Color(0x33DDF2FD),
            const Color(0x89C8C8C8),
            Colors.white.withOpacity(0)
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          onTapCardRec?.call();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                Title,
                style: GoogleFonts.ibmPlexMono(
                  color: const Color(0xFF164863),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                Number,
                style: GoogleFonts.ibmPlexMono(
                  color: const Color(0xFF0E7490),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Image.asset(
              ImagePath,
              height: 228,
              width: double.maxFinite,
            )
          ],
        ),
      ),
    );
  }

  total_student(BuildContext context) {
    return Container(
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
                            '${_Std?.length ?? 0}',
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
                        onPressed: () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: Image.asset(
                                  'assets/Student.png',
                                  width: 96.53,
                                  height: 96.37,
                                ),
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 275,
                                        child: Text(
                                          'Add First Name',
                                          style: GoogleFonts.ibmPlexMono(
                                            color: const Color(0xFF164863),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: _firstnameController,
                                        decoration: textInputDecoration
                                            .copyWith(hintText: 'FirstName'),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Enter an FirstName';
                                          } //TODO
                                          //check isFound or not
                                          return null;
                                        },
                                      ),
                                      SizedBox(
                                        width: 275,
                                        child: Text(
                                          'Add Last Name',
                                          style: GoogleFonts.ibmPlexMono(
                                            color: const Color(0xFF164863),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: _lastnameController,
                                        decoration: textInputDecoration
                                            .copyWith(hintText: 'LastName'),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Enter an LastName';
                                          } //TODO
                                          //check isFound or not
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 31),
                                      SizedBox(
                                        width: 275,
                                        child: Text(
                                          'Add username',
                                          style: GoogleFonts.ibmPlexMono(
                                            color: const Color(0xFF164863),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: _userNameController,
                                        decoration: textInputDecoration
                                            .copyWith(hintText: 'userName'),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Enter an userName';
                                          } //TODO
                                          //check isFound or not
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      SizedBox(
                                        width: 275,
                                        child: Text(
                                          'Add Email',
                                          style: GoogleFonts.ibmPlexMono(
                                            color: const Color(0xFF164863),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        controller: _emailController,
                                        decoration: textInputDecoration
                                            .copyWith(hintText: 'Email'),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Enter an Email';
                                          } //TODO
                                          //check isFound or not
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      SizedBox(
                                        width: 275,
                                        child: Text(
                                          'Add Password',
                                          style: GoogleFonts.ibmPlexMono(
                                            color: const Color(0xFF164863),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: _passwordController,
                                        obscureText: _isObscure,
                                        decoration:
                                            textInputDecoration.copyWith(
                                          hintText: 'Password',
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _isObscure
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _isObscure = !_isObscure;
                                              });
                                            },
                                          ),
                                        ),
                                        validator: (val) => val!.length < 6
                                            ? 'Password too short'
                                            : null,
                                      ),
                                      SizedBox(
                                        width: 275,
                                        child: Text(
                                          'Add Phone',
                                          style: GoogleFonts.ibmPlexMono(
                                            color: const Color(0xFF164863),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        controller: _phoneController,
                                        decoration: textInputDecoration
                                            .copyWith(hintText: 'Phone'),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Enter Your Phone';
                                          } //TODO
                                          //check isFound or not
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      SizedBox(
                                        width: 275,
                                        child: Text(
                                          'Add Level',
                                          style: GoogleFonts.ibmPlexMono(
                                            color: const Color(0xFF164863),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: _levelController,
                                        decoration: textInputDecoration
                                            .copyWith(hintText: 'Level'),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Enter an Level';
                                          } //TODO
                                          //check isFound or not
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                                actions: [
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            width: 140.50,
                                            height: 48,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                _onAddStudentPressed();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xFF427D9D),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: Text(
                                                'Add Student',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.ibmPlexMono(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: SizedBox(
                                            width: 140.50,
                                            height: 48,
                                            child: OutlinedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              style: OutlinedButton.styleFrom(
                                                side: const BorderSide(
                                                    color: Color(0xFF427D9D)),
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  side: const BorderSide(
                                                      width: 1,
                                                      color: Color(0xFF427D9D)),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: Text(
                                                'Cancel',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.ibmPlexMono(
                                                  color:
                                                      const Color(0xFF427D9D),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                )
              ]),
        ));
  }
}

class FadeInDialog extends StatelessWidget {
  final Widget child;

  const FadeInDialog({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }
}
