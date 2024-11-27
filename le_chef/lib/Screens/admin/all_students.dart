import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Models/Student.dart';
import 'package:le_chef/Screens/admin/payment_request.dart';
import 'package:le_chef/Screens/admin/studentProfile.dart';
import 'package:le_chef/Shared/custom_app_bar.dart';
import 'package:le_chef/Shared/custom_search_view.dart';
import 'package:le_chef/Widgets/dialog_with_two_buttons.dart';
import 'package:le_chef/main.dart';

import '../../Api/apimethods.dart';
import '../../Shared/customBottomNavBar.dart';
import '../../Widgets/total_exams-students_card.dart';
import '../user/Home.dart';
import '../chats/chats.dart';
import '../notification.dart';
import 'AddExam.dart';

class AllStudents extends StatefulWidget {
  const AllStudents({super.key});

  @override
  State<AllStudents> createState() => _AllStudentsState();
}

class _AllStudentsState extends State<AllStudents> {
  final String StdImg = 'assets/bccb46bd-67fe-47c7-8e5e-3dd39329d638.webp';
  int currentPage = 1;
  int studentsPerPage = 5;
  bool _isLoading_Std = true;
  List<Student>? _Std;
  double boxSize = 30.0;
  List<Student> searched_Student = [];
  final TextEditingController searchController = TextEditingController();
  String? profilePic = sharedPreferences?.getString('img');


  Future<void> getStd() async {
    _Std = await ApisMethods.AllStudents();
    print('Std infooooooooo ${_Std!}');
    setState(() {
      _isLoading_Std = false;
    });
  }

  void search(String? value) {
    setState(() {
      searched_Student = _Std!
          .where(
              (element) => element.firstname.toLowerCase().startsWith(value!))
          .toList();
    });
  }

  List<Student> get currentStudents {
    final startIndex = (currentPage - 1) * studentsPerPage;
    return _Std?.skip(startIndex).take(studentsPerPage).toList() ?? [];
  }

  int get totalPages =>
      (_Std?.length ?? 0) > 0 ? ((_Std!.length / studentsPerPage).ceil()) : 1;

  @override
  void initState() {
    super.initState();
    getStd();
  }

  void clear() {
    setState(() {
      searched_Student = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(title: 'All Students'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 39),
              totalStudent(
                context,
                'Total Students',
                '${_Std?.length ?? 0}',
                ontap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AddExam())),
              ),
              const SizedBox(height: 43),
              CustomSearchView(
                clear: () {
                  clear();
                },
                onChanged: (p0) {
                  search(p0);
                },
                controller: searchController,
                hintText: 'search by student name',
                hintStyle: GoogleFonts.ibmPlexMono(
                  color: const Color(0xFF888888),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 59),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Name',
                      style: GoogleFonts.ibmPlexMono(
                        color: const Color(0xFF164863),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Action',
                      style: GoogleFonts.ibmPlexMono(
                        color: const Color(0xFF164863),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _isLoading_Std
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : searched_Student.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: searched_Student.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfilePage(isStudent: true, student: currentStudents[index],)),
                                    );
                                  },
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 25,
                                      backgroundImage: currentStudents[index].imageUrl != null ? NetworkImage(currentStudents[index].imageUrl!) : AssetImage('assets/default_image_profile.jpg') as ImageProvider ,
                                    ),
                                    title: Text(
                                      searched_Student[index].firstname,
                                      style: GoogleFonts.ibmPlexMono(
                                        color: const Color(0xFF083344),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Image.asset('assets/trash.png'),
                                      onPressed: () {
                                        dialogWithButtons(
                                            context: context,
                                            icon: Image.asset(
                                                'assets/trash-1.png'),
                                            title: 'Remove Student !',
                                            content:
                                                'Are you sure that you want to remove student!',
                                            button1Text: 'Remove',
                                            button1Action: () async {
                                              Navigator.pop(context);
                                              await ApisMethods.DelStudent(
                                                  searched_Student[index].ID);
                                              dialogWithButtons(
                                                  context: context,
                                                  icon: Image.asset(
                                                      'assets/trash-1.png'),
                                                  title:
                                                      'Student is removed successfully !');
                                              Future.delayed(
                                                  const Duration(seconds: 2), () {
                                                Navigator.pop(context);
                                              });
                                            },
                                            buttonColor: Colors.red,
                                            button2Text: 'Cancel',
                                            button2Action: () {
                                              Navigator.pop(context);
                                            },
                                            outlineButtonColor: Colors.red);
                                        setState(() {
                                          getStd();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: currentStudents.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfilePage(isStudent: true, student: currentStudents[index],)),
                                    );
                                  },
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 25,
                                      backgroundImage:  currentStudents[index].imageUrl != null ? NetworkImage(currentStudents[index].imageUrl!) : AssetImage('assets/default_image_profile.jpg') as ImageProvider ,
                                    ),
                                    title: Text(
                                      currentStudents[index].firstname,
                                      style: GoogleFonts.ibmPlexMono(
                                        color: const Color(0xFF083344),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Image.asset('assets/trash.png'),
                                      onPressed: () {
                                        dialogWithButtons(
                                            context: context,
                                            icon: Image.asset(
                                                'assets/trash-1.png'),
                                            title: 'Remove Student !',
                                            content:
                                                'Are you sure that you want to remove student!',
                                            button1Text: 'Remove',
                                            button1Action: () async {
                                              Navigator.pop(context);
                                              await ApisMethods.DelStudent(
                                                  searched_Student[index].ID);
                                              dialogWithButtons(
                                                  context: context,
                                                  icon: Image.asset(
                                                      'assets/trash-1.png'),
                                                  title:
                                                      'Student is removed successfully !');
                                              Future.delayed(
                                                  const Duration(seconds: 2), () {
                                                Navigator.pop(context);
                                              });
                                            },
                                            buttonColor: Colors.red,
                                            button2Text: 'Cancel',
                                            button2Action: () {
                                              Navigator.pop(context);
                                            },
                                            outlineButtonColor: Colors.red);
                                        setState(() {
                                          getStd();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        'Showing ${currentStudents.length} of ${_Std?.length ?? 0}'),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: currentPage > 1
                              ? () => changePage(currentPage - 1)
                              : null,
                        ),
                        for (int i = 1; i <= totalPages; i++)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: GestureDetector(
                              onTap: () => changePage(i),
                              child: Container(
                                width: boxSize,
                                height: boxSize,
                                decoration: ShapeDecoration(
                                  color: currentPage == i
                                      ? const Color(0xFF427D9D)
                                      : const Color(0xFF888888),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                ),
                                child: Center(
                                  child: Text(
                                    '$i',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: currentPage < totalPages
                              ? () => changePage(currentPage + 1)
                              : null,
                        ),
                      ],
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
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentRequest()));
                }
            }
          },
          context: context, userRole: role!,
        ),
      ),
    );
  }

  void changePage(int page) {
    setState(() {
      currentPage = page;
    });
  }
}
