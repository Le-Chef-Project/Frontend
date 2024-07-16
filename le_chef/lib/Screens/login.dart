import 'package:flutter/material.dart';
import 'package:le_chef/Shared/textInputDecoration.dart';

import '../Shared/custom_app_bar.dart'; // Assuming textInputDecoration is defined here

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Ensures children expand horizontally
          children: [
            Text(
              'Welcome',
              style: TextStyle(
                color: Color(0xFF164863),
                fontSize: 18,
                fontFamily: 'IBM Plex Mono',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Please sign in to access your account',
              style: TextStyle(
                color: Color(0xFF888888),
                fontSize: 16,
                fontFamily: 'IBM Plex Mono',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: textInputDecoration.copyWith(hintText: 'Email'),
              validator: (val) => val!.isEmpty ? 'Invalid Email' : null,
              // onChanged: () {},
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: textInputDecoration.copyWith(hintText: 'Password'),
              validator: (val) => val!.isEmpty ? 'Invalid Email' : null,
              // onChanged: () {},
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle sign-in button press
              },
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
