import 'package:flutter/material.dart';
import 'package:le_chef/Screens/Home.dart';
import 'package:le_chef/Shared/custom_elevated_button.dart';
import 'package:le_chef/Shared/textInputDecoration.dart';

import '../Shared/customBottomNavBar.dart';
import '../Shared/custom_app_bar.dart';
import '../Shared/custom_outlined_button.dart';
import '../theme/custom_button_style.dart';
import '../theme/custom_text_style.dart';
import 'chats.dart';
import 'notification.dart'; // Assuming textInputDecoration is defined here

class OnlineSessions extends StatefulWidget {
  const OnlineSessions({Key? key}) : super(key: key);

  @override
  _OnlineSessionsState createState() => _OnlineSessionsState();
}

class _OnlineSessionsState extends State<OnlineSessions> {
  bool is_seesion = true;
  bool camera = true;
  bool mic = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(title: 'Online Sessions'),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: is_seesion
              ? Column(
                  children: [
                    Image.asset('assets/Humaaans 3 Characters.png'),
                    SizedBox(
                      height: 70,
                    ),
                    Text(
                      'Tab to join meeting',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'IBM Plex Mono',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        camera
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    camera = false;
                                  });
                                },
                                icon: Icon(Icons.videocam_outlined),
                                color: Color.fromRGBO(66, 125, 157, 1),
                              )
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    camera = true;
                                  });
                                },
                                icon: Icon(Icons.videocam_off_outlined),
                                color: Color.fromRGBO(66, 125, 157, 1),
                              ),
                        mic
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    mic = false;
                                  });
                                },
                                icon: Icon(Icons.mic_sharp),
                                color: Color.fromRGBO(66, 125, 157, 1),
                              )
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    mic = true;
                                  });
                                },
                                icon: Icon(Icons.mic_off_sharp),
                                color: Color.fromRGBO(66, 125, 157, 1),
                              )
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomElevatedButton(
                          height: 41,
                          width: 161,
                          text: "Join meeting",
                          buttonStyle: CustomButtonStyles.fillPrimaryTL5,
                        ),
                        CustomOutlinedButton(
                          buttonTextStyle: CustomTextStyles.bodyLargeff0e7490,
                          text: "Home page",
                          width: 161,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                          ),
                          margin: EdgeInsets.only(left: 8),
                          buttonStyle: CustomButtonStyles.outlinePrimaryTL51,
                        )
                      ],
                    ),
                  ],
                )
              : Column(
                  children: [
                    Image.asset('assets/error-16_svgrepo.com.jpg'),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      'There are no sessions \n now, come back later...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'IBM Plex Mono',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    CustomElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      ),
                      text: 'Home Page',
                      height: 41,
                      width: 250,
                      buttonStyle: CustomButtonStyles.fillPrimaryTL5,
                    ),
                  ],
                ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        onItemTapped: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
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
                MaterialPageRoute(builder: (context) => Chats()),
              );
              break;
          }
        },
        context: context,
      ),
    ));
  }
}
