import 'package:flutter/material.dart';

import '../Shared/textInputDecoration.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({Key? key}) : super(key: key);

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 321,
      height: 445,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Image.asset(
            'assets/Student.png',
            width: 96.53,
            height: 96.37,
          ),
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
          const SizedBox(height: 31),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'IBM Plex Mono',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the dialog
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF427D9D)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color(0xFF427D9D),
                    fontSize: 16,
                    fontFamily: 'IBM Plex Mono',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
