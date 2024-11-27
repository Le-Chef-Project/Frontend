import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:le_chef/Api/apimethods.dart';
import 'package:le_chef/Models/Student.dart';
import 'package:le_chef/Shared/custom_app_bar.dart';

import '../../Models/Admin.dart';
import '../../Shared/textInputDecoration.dart';
import '../../main.dart';

class ProfilePage extends StatefulWidget {
  final bool isStudent;
  final Student? student;
  final Admin? admin;

  const ProfilePage(
      {super.key, required this.isStudent, this.student, this.admin});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isObscure = true;
  File? img;

  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _educationLevelController;

  bool _isLoading = false;
  final String? _userId = sharedPreferences!.getString('Id');

  @override
  void initState() {
    super.initState();

    if (widget.isStudent) {
      _usernameController =
          TextEditingController(text: widget.student?.username ?? '');
      _passwordController =
          TextEditingController(text: widget.student?.password ?? '');
      _emailController =
          TextEditingController(text: widget.student?.email ?? '');
      _phoneController =
          TextEditingController(text: widget.student?.phone ?? '');
      _educationLevelController = TextEditingController(
          text: widget.student?.educationLevel.toString() ?? '');
    } else {
      _usernameController =
          TextEditingController(text: widget.admin?.username ?? '');
      _passwordController =
          TextEditingController(text: widget.admin?.password ?? '');
      _emailController = TextEditingController(text: widget.admin?.email ?? '');
      _phoneController = TextEditingController(text: widget.admin?.phone ?? '');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    if (widget.isStudent) {
      _educationLevelController.dispose();
    }
    super.dispose();
  }

  Future<void> editProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.isStudent) {
        await ApisMethods.editProfile(
            userId: widget.student!.ID,
            username: _usernameController.text,
            email: _emailController.text,
            phone: _phoneController.text,
            educationLevel: int.parse(_educationLevelController.text),
            imageFile: img);

        setState(() {
          widget.student?.username = _usernameController.text;
          widget.student?.email = _emailController.text;
          widget.student?.phone = _phoneController.text;
          widget.student?.educationLevel =
              int.parse(_educationLevelController.text);
        });
      } else {
        await ApisMethods.editProfile(
            userId: widget.admin!.id,
            username: _usernameController.text,
            email: _emailController.text,
            phone: _phoneController.text,
            imageFile: img);

        setState(() {
          widget.admin?.username = _usernameController.text;
          widget.admin?.email = _emailController.text;
          widget.admin?.phone = _phoneController.text;
          widget.admin?.password = _passwordController.text;
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Color(0xFF164863),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        print('Error updating profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }

    ApisMethods.AllStudents(); // Refresh student data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
          title: widget.isStudent ? 'Student Profile' : 'Admin Profile'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Image.asset(
                  'assets/logo.png',
                  width: 100,
                  height: 100,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final pickedImage = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);

                  if (pickedImage != null) {
                    setState(() {
                      img = File(pickedImage.path);
                    });
                  }
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: widget.isStudent
                      ? NetworkImage(widget.student!.imageUrl!)
                      : NetworkImage(widget.admin!.imageUrl!),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.isStudent
                    ? widget.student?.username ?? 'No username'
                    : widget.admin?.username ?? 'No username',
                style: const TextStyle(
                  color: Color(0xFF427D9D),
                  fontSize: 20,
                  fontFamily: 'IBM Plex Mono',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              const SizedBox(height: 10),
              if (widget.isStudent)
                Text(
                  'Level ${widget.student?.educationLevel.toString() ?? 'N/A'}',
                  style: const TextStyle(
                    color: Color(0xFF888888),
                    fontSize: 14,
                    fontFamily: 'IBM Plex Mono',
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                )
              else
                Text(
                  widget.admin?.email ?? 'No email',
                  style: const TextStyle(
                    color: Color(0xFF888888),
                    fontSize: 14,
                    fontFamily: 'IBM Plex Mono',
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                ),
              const SizedBox(height: 16),
              buildDividerWithText("Personal info"),
              const SizedBox(height: 8),
              _textfield('Username', _usernameController, Icons.person),
              _buildPasswordField('Password', _passwordController, Icons.lock),
              _textfield('Email', _emailController, Icons.email),
              _textfield('Phone number', _phoneController, Icons.phone),
              if (widget.isStudent)
                _textfield(
                    'Academic Stage', _educationLevelController, Icons.school),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF427D9D),
                      minimumSize: const Size(140.50, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isLoading ? null : editProfile,
                    child: _isLoading
                        ? Text('Saving...',
                            style: GoogleFonts.ibmPlexMono(color: Colors.white))
                        : Text(
                            'Save Changes',
                            style: GoogleFonts.ibmPlexMono(color: Colors.white),
                          )),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textfield(
      String label, TextEditingController controller, IconData icon) {
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
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            decoration: textInputDecoration.copyWith(
              hintText: label,
              prefixIcon: Icon(
                icon,
                color: const Color(0xFF164863),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(
      String label, TextEditingController controller, IconData icon) {
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
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            obscureText: _isObscure,
            enabled: widget.student?.ID == _userId,
            decoration: textInputDecoration.copyWith(
              hintText: label,
              prefixIcon: Icon(
                icon,
                color: const Color(0xFF164863),
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
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDividerWithText(String text) {
    return Row(
      children: [
        const Expanded(
          child: Divider(thickness: 1, color: Color(0xFF164863)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF164863),
              fontSize: 12,
              fontFamily: 'IBM Plex Mono',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
        ),
        const Expanded(
          child: Divider(thickness: 1, color: Color(0xFF164863)),
        ),
      ],
    );
  }
}
