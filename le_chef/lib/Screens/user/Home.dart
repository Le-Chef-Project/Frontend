import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Screens/chats/chats.dart';
import 'package:le_chef/Shared/exams/exams.dart';
import 'package:le_chef/Shared/login.dart';
import 'package:le_chef/Widgets/SmallCard.dart';
import 'package:le_chef/services/content/media_service.dart';
import 'package:le_chef/services/content/note_service.dart';
import 'package:le_chef/services/content/quiz_service.dart';
import '../../Models/Notes.dart';
import '../../Models/PDF.dart';
import '../../Models/Quiz.dart';
import '../../Models/Video.dart';
import '../../Shared/customBottomNavBar.dart';
import '../../Shared/meeting/online_session_screen.dart';
import '../../main.dart';
import '../Notes.dart';
import '../admin/library.dart';
import '../admin/payment_request.dart';
import '../admin/viewVideo.dart';
import '../notification.dart';
import 'seeAllVid.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final int _selectedIndex = 0; // Initial index for Chats screen
  static int? level = sharedPreferences?.getInt('educationLevel');
  static String? userName = sharedPreferences?.getString('userName');
  static String? rolee = sharedPreferences?.getString('role');
  String? logged_img = sharedPreferences?.getString('img');

  List<Quiz>? _exams;
  bool _isLoading_Exams = true;
  List<Notes>? _notes;
  bool _isLoading_notes = true;
  List<PDF>? _pdfs;
  bool _isLoading_pdfs = true;
  int libraryLength = 0;
  int videosLength = 0;

  Future<List<Video>>? _videosFuture;

  @override
  void initState() {
    super.initState();
    _videosFuture = _fetchAndSortVideos();
    _videosFuture!.then((videos) {
      setState(() {
        videosLength = videos.length;
      });
    });
    getpdf();
    getexams();
    getnotes();
  }

  Future<void> getexams() async {
    _exams = await QuizService.getAllQuizzes();
    print('apiii $_exams + ${_exams?.length}');

    _exams = _exams?.where((exam) => exam.level == level).toList();
    setState(() {
      _isLoading_Exams = false;
    });
  }

  Future<void> getpdf() async {
    _pdfs = await MediaService.fetchAllPDFs();
    print('apiii $_pdfs + ${_pdfs?.length}');

    _pdfs = _pdfs?.where((pdf) => pdf.educationLevel == level).toList();
    setState(() {
      _isLoading_pdfs = false;
      libraryLength += _pdfs!.length ?? 0;
    });
  }

  Future<void> getnotes() async {
    _notes = await NoteService.fetchNotesForUserLevel();

    _notes = _notes?.where((note) => note.educationLevel == level).toList();
    setState(() {
      _isLoading_notes = false;
    });
  }

  Future<List<Video>> _fetchAndSortVideos() async {
    final Videos = await MediaService.fetchAllVideos();

    // Filter and sort videos by date
    final filteredVideos = Videos.where((video) {
      return video.educationLevel == level;
    }).toList();

    // Sort videos by date
    filteredVideos.sort((a, b) =>
        DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)));

    setState(() {
      libraryLength += filteredVideos.length ?? 0;
    });
    print("Sorted Videos: ${filteredVideos.length}");
    return filteredVideos;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          leading: CircleAvatar(
            radius:
                30, // Adjust the radius to control the size of the CircleAvatar
            backgroundImage: NetworkImage(
              logged_img ??
                  'https://t4.ftcdn.net/jpg/02/15/84/43/360_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg',
            ),
            backgroundColor: Colors.white,
          ),
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
                  )),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 8, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: const Color(0x00565656),
                        child: Text(
                          userName != null ? userName! : 'Guest',
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
                          'Level  ${level ?? 'Unknown'}',
                          style: GoogleFonts.ibmPlexMono(
                            color: const Color(0xFF427D9D),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 400,
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: Text(
                          'Newest Videos',
                          style: GoogleFonts.ibmPlexMono(
                            color: const Color(0xFF164863),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 106),
                    TextButton(
                      onPressed: () {
                        Get.to(() => const AllVid(),
                            transition: Transition.fade,
                            duration: const Duration(seconds: 1));
                      },
                      child: Text(
                        'See all',
                        style: GoogleFonts.ibmPlexMono(
                          color: const Color(0xFF427D9D),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<Video>>(
                  future: _videosFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No videos available"));
                    }
                    final Videos = snapshot.data!;

                    return SizedBox(
                      height: 250,
                      child: ListView.builder(
                        itemCount: videosLength > 3 ? 3 : videosLength,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final video = Videos[index];
                          return Smallcard(
                            id: video.id,
                            type: 'Video',
                            Title: video.title,
                            description: video.description,
                            imageurl: 'assets/desk_book_apple.jpeg',
                            ontap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    VideoPlayerScreen(url: video.url),
                              ),
                            ),
                            isLocked: video.isLocked,
                          );
                        },
                      ),
                    );
                  }),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0.0, 0, 15.0),
                child: SizedBox(
                  width: 380,
                  child: Text(
                    'More',
                    style: GoogleFonts.ibmPlexMono(
                      color: const Color(0xFF164863),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: _buildCardRec(context,
                          Title: "Exams",
                          Number: _isLoading_Exams
                              ? "..."
                              : "${_exams?.length ?? 0}",
                          ImagePath: 'assets/Wonder Learners Graduating.png',
                          //Todo go to exam for student
                          onTapCardRec: () => Get.to(
                              () => Exams(
                                    selectedLevel: level!,
                                  ),
                              transition: Transition.fade,
                              duration: const Duration(seconds: 1))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildCardRec(context,
                          Title: "Library",
                          Number:
                              _isLoading_pdfs ? '...' : '${libraryLength ?? 0}',
                          ImagePath: 'assets/Charco Education.png',
                          onTapCardRec: () => Get.to(
                              () => LibraryTabContainerScreen(
                                    selectedLevel: level!,
                                  ),
                              transition: Transition.fade,
                              duration: const Duration(seconds: 1))),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: _buildCardRec(context,
                          Title: "Notes",
                          Number: _isLoading_notes
                              ? '...'
                              : '${_notes?.length ?? 0}',
                          ImagePath: 'assets/Wonder Learners Book.png',
                          onTapCardRec: () => Get.to(
                              () => NotesScreen(
                                    level: level!,
                                  ),
                              transition: Transition.fade,
                              duration: const Duration(seconds: 1))),
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
                            Get.to(() => const OnlineSessionScreen(),
                                transition: Transition.fade,
                                duration: const Duration(seconds: 1));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  'Online Seesions',
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
                                width: double.maxFinite,
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
        bottomNavigationBar: CustomBottomNavBar(
          onItemTapped: (index) {
            switch (index) {
              case 1:
                Get.to(() => const Notifications(),
                    transition: Transition.fade,
                    duration: const Duration(seconds: 1));

                break;
              case 2:
                Get.to(() => const Chats(),
                    transition: Transition.fade,
                    duration: const Duration(seconds: 1));

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
          userRole: rolee!,
        ),
      ),
    );
  }
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
