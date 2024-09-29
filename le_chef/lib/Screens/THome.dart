import 'package:flutter/material.dart';
import 'package:le_chef/Screens/chats.dart';
import 'package:le_chef/Screens/exams.dart';
import 'package:le_chef/Screens/seeAllVid.dart';
import 'package:le_chef/Shared/custom_elevated_button.dart';

import '../Shared/customBottomNavBar.dart';
import '../Shared/custom_search_view.dart';
import '../Shared/textInputDecoration.dart';
import '../theme/custom_button_style.dart';
import 'Notes.dart';
import 'notification.dart';

class THome extends StatefulWidget {
  const THome({super.key});

  @override
  State<THome> createState() => _THomeState();
}

class _THomeState extends State<THome> {
  TextEditingController searchController = TextEditingController();
  final int _selectedIndex = 0;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
// Initial index for Chats screen

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          leading: Image.asset('assets/Rectangle 4.png'),
          actions: [
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 23),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    'assets/logo.png',
                    height: 50,
                  ),
                )),
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
                        child: const Text(
                          'Hany Azmy',
                          style: TextStyle(
                            color: Color(0xFF164863),
                            fontSize: 22,
                            fontFamily: 'IBM Plex Mono',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                      Container(
                        child: const Text(
                          'French Teacher',
                          style: TextStyle(
                            color: Color(0xFF427D9D),
                            fontSize: 16,
                            fontFamily: 'IBM Plex Mono',
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
                height: 68,
              ),
              total_student(context),
              const SizedBox(
                height: 68,
              ),
              SizedBox(
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: _buildCardRec(
                        context,
                        Title: "Exams",
                        Number: "15",
                        ImagePath: 'assets/Wonder Learners Graduating.png',
                        onTapCardRec: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Exams()),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildCardRec(context,
                          Title: "Library",
                          Number: "20",
                          ImagePath: 'assets/Charco Education.png'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: _buildCardRec(
                        context,
                        Title: "Notes",
                        Number: "10",
                        ImagePath: 'assets/Wonder Learners Book.png',
                        onTapCardRec: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Notes()),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: ShapeDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.00, -1.00),
                            end: Alignment(0, 1),
                            colors: [
                              Color(0x33DDF2FD),
                              Color(0x89C8C8C8),
                              Colors.white.withOpacity(0)
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: GestureDetector(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Text(
                                  'Online Seesions',
                                  style: TextStyle(
                                    color: Color(0xFF164863),
                                    fontSize: 16,
                                    fontFamily: 'IBM Plex Mono',
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
          selectedIndex: _selectedIndex,
        ),
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
          begin: Alignment(0.00, -1.00),
          end: Alignment(0, 1),
          colors: [
            Color(0x33DDF2FD),
            Color(0x89C8C8C8),
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
                style: const TextStyle(
                  color: Color(0xFF164863),
                  fontSize: 16,
                  fontFamily: 'IBM Plex Mono',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                Number,
                style: const TextStyle(
                  color: Color(0xFF0E7490),
                  fontSize: 12,
                  fontFamily: 'IBM Plex Mono',
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
          shadows: [
            BoxShadow(
              color: Color(0x4C427D9D),
              blurRadius: 32.50,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'Total Students',
                        style: TextStyle(
                          color: Color(0xFF164863),
                          fontSize: 14,
                          fontFamily: 'IBM Plex Mono',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ),
                    Text(
                      'See all',
                      style: TextStyle(
                        color: Color(0xFF427D9D),
                        fontSize: 12,
                        fontFamily: 'IBM Plex Mono',
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
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
                            color: Color(0xFFDDF2FD),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '16.5K',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF164863),
                                fontSize: 24,
                                fontFamily: 'IBM Plex Mono',
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
                              title: Image.asset(
                                'assets/Student.png',
                                width: 96.53,
                                height: 96.37,
                              ),
                              content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 31),
                                  SizedBox(
                                    width: 275,
                                    child: Text(
                                      'Add username',
                                      style: TextStyle(
                                        color: Color(0xFF164863),
                                        fontSize: 14,
                                        fontFamily: 'IBM Plex Mono',
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _userNameController,
                                    decoration: textInputDecoration.copyWith(hintText: 'userName'),
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
                                      'Add Password',
                                      style: TextStyle(
                                        color: Color(0xFF164863),
                                        fontSize: 14,
                                        fontFamily: 'IBM Plex Mono',
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: _isObscure,
                                    decoration: textInputDecoration.copyWith(
                                      hintText: 'Password',
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _isObscure ? Icons.visibility_off : Icons.visibility,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isObscure = !_isObscure;
                                          });
                                        },
                                      ),
                                    ),
                                    validator: (val) => val!.length < 6 ? 'Password too short' : null,
                                  ),
                                ],
                              ),
                              actions: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          width: 140.50,
                                          height: 48,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(

                                                      title:Image.asset(
                                                        'assets/correct sign.png',
                                                        width: 117,
                                                        height: 117,
                                                      ),
                                                      content: const SizedBox(
                                                        width: 150,
                                                        height: 80,
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              'Success!',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                color: Color(0xFF164863),
                                                                fontSize: 16,
                                                                fontFamily: 'IBM Plex Mono',
                                                                fontWeight: FontWeight.w600,
                                                                height: 0,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              'Student Added Successfully',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                color: Color(0xFF888888),
                                                                fontSize: 16,
                                                                fontFamily: 'IBM Plex Mono',
                                                                fontWeight: FontWeight.w600,
                                                                height: 0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      actions: [
                                                        Expanded(
                                                          child: Row(
                                                            // mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Expanded(
                                                                child: SizedBox(
                                                                  width: 140.50,
                                                                  height: 48,
                                                                  child: ElevatedButton(
                                                                      onPressed: () {
                                                                        Navigator.pop(context);
                                                                      },
                                                                      style: ElevatedButton.styleFrom(
                                                                        backgroundColor:
                                                                        const Color(0xFF427D9D),
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                          BorderRadius.circular(12),
                                                                        ),
                                                                      ),
                                                                      child: const Text(
                                                                        'Ok',
                                                                        textAlign: TextAlign.center,
                                                                        style: TextStyle(
                                                                          color: Colors.white,
                                                                          fontSize: 16,
                                                                          fontFamily: 'IBM Plex Mono',
                                                                          fontWeight: FontWeight.w600,
                                                                          height: 0,
                                                                        ),
                                                                      )),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  });

                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFF427D9D),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: const Text(
                                              'Add Student',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: 'IBM Plex Mono',
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
                                              side: const BorderSide(color: Color(0xFF427D9D)),
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                side: const BorderSide(width: 1, color: Color(0xFF427D9D)),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: const Text(
                                              'Cancel',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xFF427D9D),
                                                fontSize: 16,
                                                fontFamily: 'IBM Plex Mono',
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
            ]));
  }



}

