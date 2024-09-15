import 'package:flutter/material.dart';
import 'package:le_chef/Screens/Home.dart';
import 'package:le_chef/Shared/textInputDecoration.dart';

// Assuming textInputDecoration is defined here

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                //TODO
                //change logo
                child: Image.asset('assets/logo.png', width: 300, height: 300),
              ),
              const Text(
                'Welcome',
                style: TextStyle(
                  color: Color(0xFF164863),
                  fontSize: 18,
                  fontFamily: 'IBM Plex Mono',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please sign in to access your account',
                style: TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 16,
                  fontFamily: 'IBM Plex Mono',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
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
                validator: (val) =>
                    val!.length < 6 ? 'Password too short' : null,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF427D9D),
                    padding:
                        const EdgeInsets.symmetric(vertical: 14.5, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Log in',
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
            ],
          ),
        ),
      ),
    );
  }
}
