import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Shared/custom_app_bar.dart';
import 'package:le_chef/Shared/custom_elevated_button.dart';

import '../../Shared/textInputDecoration.dart';
import '../../main.dart';
import '../../theme/custom_button_style.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isObscure = true;
  String? role = sharedPreferences!.getString('role');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          CustomAppBar(title: role != 'admin' ? 'Student Profile' : 'Profile'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/logo.png', // Path to your logo asset
                    width: 150,
                    height: 150,
                  ),
                ],
              ),
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/default_image_profile.jpg'),
              ),
              SizedBox(height: 8),
              Text(
                'Danial Robert',
                style: TextStyle(
                  color: Color(0xFF427D9D),
                  fontSize: 20,
                  fontFamily: 'IBM Plex Mono',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              if (role != 'admin')
                Text(
                  'Level 2',
                  style: TextStyle(
                    color: Color(0xFF888888),
                    fontSize: 14,
                    fontFamily: 'IBM Plex Mono',
                    fontWeight: FontWeight.w400,
                    height: 1.2, // Adjust for better line height
                  ),
                ),
              SizedBox(height: 16),
              buildDividerWithText("Personal info"),
              SizedBox(height: 8),
              _textfeild('Username', 'Danial Robert', Icons.person),
              _buildPasswordField('Password', Icons.lock),
              _textfeild('Email', 'danialrobert123@gmail.com', Icons.email),
              _textfeild('Phone number', '81234567890', Icons.phone),
              if (role != 'admin')
                _textfeild('Academic Stage', '2', Icons.school),
              SizedBox(height: 20),
              CustomElevatedButton(
                onPressed: () {},
                text: 'Save Changes',
                buttonStyle: CustomButtonStyles.fillPrimaryTL5,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textfeild(String label, String placeholder, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 275,
            child: Text(
              label,
              style: GoogleFonts.ibmPlexMono(
                color: const Color(0xFF164863),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            decoration: textInputDecoration.copyWith(
              hintText: placeholder,
              prefixIcon: Icon(
                icon,
                color: Color(0xFF164863),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(String label, IconData icon) {
    return Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 275,
              child: Text(
                label,
                style: GoogleFonts.ibmPlexMono(
                  color: const Color(0xFF164863),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              obscureText: _isObscure,
              decoration: textInputDecoration.copyWith(
                hintText: '*******',
                prefixIcon: Icon(
                  icon,
                  color: Color(0xFF164863),
                ),
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
            ),
          ],
        ));
  }

  // Method to create a divider with text in the center
  Widget buildDividerWithText(String text) {
    return Row(
      children: [
        Expanded(
          child: Divider(thickness: 1, color: Color(0xFF164863)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            text,
            style: TextStyle(
              color: Color(0xFF164863),
              fontSize: 12,
              fontFamily: 'IBM Plex Mono',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
        ),
        Expanded(
          child: Divider(thickness: 1, color: Color(0xFF164863)),
        ),
      ],
    );
  }
}
