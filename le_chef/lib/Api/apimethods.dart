import 'dart:convert';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:le_chef/Models/PDF.dart';
import 'package:le_chef/Models/Quiz.dart' as quizModel;
import 'package:le_chef/Models/Video.dart';
import 'package:le_chef/Screens/admin/THome.dart';
import '../Models/Notes.dart';
import '../Models/Quiz.dart';
import '../Models/Student.dart';
import '../Screens/exams.dart';
import '../Screens/user/Home.dart';
import '../main.dart';
import 'SharedPrefes.dart';
import 'package:path/path.dart'; // To get the file name
import 'apiendpoints.dart';

class ApisMethods {
  static String? token = sharedPreferences.getString('token');
//1-Login
  static Future<void> login(emailController, passwordController) async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl.trim() + ApiEndPoints.authEndPoint.loginEmail);
    if (emailController.isNotEmpty && passwordController.isNotEmpty) {
      http.Response response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': emailController.trim(),
            'password': passwordController
          }));
      print('apiiii $emailController + $passwordController ');
      final json = jsonDecode(response.body);
      print('apiiii ${json['role']}');

      if (response.statusCode == 200) {
        SharedPrefes.SaveToken(json['token']);
        SharedPrefes.SaveRole(json['role']);
        if (json['role'] == "admin") {
          Get.off(const THome(),
              transition: Transition.fade,
              duration: const Duration(seconds: 1));
        } else {
          Get.off(const Home(),
              transition: Transition.fade,
              duration: const Duration(seconds: 1));
        }
      } else {
        showDialog(
            context: Get.context!,
            builder: (context) {
              return SimpleDialog(
                title: const Text('Error'),
                contentPadding: const EdgeInsets.all(20),
                children: [Text(json['message'])],
              );
            });
      }
    } else {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return const SimpleDialog(
              title: Text('Error'),
              contentPadding: EdgeInsets.all(20),
              children: [Text('black field not allowed')],
            );
          });
    }
  }

  // 2-Add Student
  static Future<String> AddStudent(
      emailController,
      passwordController,
      phoneController,
      usernameController,
      firstnameController,
      lastnameController) async {
    String? Mess;
    var url = Uri.parse(
        ApiEndPoints.baseUrl.trim() + ApiEndPoints.userManage.AddStudent);
    if (emailController.isNotEmpty &&
        passwordController.isNotEmpty &&
        phoneController.isNotEmpty &&
        usernameController.isNotEmpty &&
        firstnameController.isNotEmpty &&
        lastnameController.isNotEmpty) {
      http.Response response = await http.post(url,
          headers: {'Content-Type': 'application/json', 'token': token!},
          body: jsonEncode({
            'email': emailController.trim(),
            'password': passwordController,
            'phone': phoneController,
            'username': usernameController,
            'firstName': firstnameController,
            'lastName': lastnameController
          }));
      final json = jsonDecode(response.body);
      if (response.statusCode == 201) {
        print('apiii $json');
        Mess = 'success';
      } else {
        Mess = json['error'];
      }
    } else {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return const SimpleDialog(
              title: Text('Error'),
              contentPadding: EdgeInsets.all(20),
              children: [Text('black field not allowed')],
            );
          });
    }
    return Mess!;
  }

//3- All Students

  static Future<List<Student>> AllStudents() async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl.trim() + ApiEndPoints.userManage.GetStudents);
    http.Response response = await http.get(
      url,
      headers: {'Content-Type': 'application/json', 'token': token!},
    );
    var data = jsonDecode(response.body);

    List temp = [];
    if (response.statusCode == 200) {
      print('apiiii students $data');

      for (var i in data) {
        temp.add(i);
      }

      return Student.itemsFromSnapshot(temp);
    } else {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: const Text('Error'),
              contentPadding: const EdgeInsets.all(20),
              children: [Text('can not get student : ${response.body}')],
            );
          });
      return Student.itemsFromSnapshot(temp);
    }
  }

  //4-Delete Student
  static Future<void> DelStudent(String ID) async {
    var url = Uri.parse(
        '${ApiEndPoints.baseUrl.trim()}${ApiEndPoints.userManage.DelStudent}$ID');
    http.Response response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json', 'token': token!},
    );
    if (response.statusCode == 200) {
      print('${jsonDecode(response.body)['message']}');
    } else {
      print('${jsonDecode(response.body)['message']}');
    }
  }

//5- add quiz
  static Future<bool> addQuiz({
    required String title,
    required List<dynamic> questions,
    required int hours,
    required int minutes,
    required int? level,
    required int? unit,
    required bool isPaid,
    double? amountToPay,
  }) async {
    try {
      if (questions.isEmpty) {
        throw Exception('Questions list cannot be empty');
      }

      if (isPaid && amountToPay == null) {
        throw Exception('Amount to pay is required for paid quizzes');
      }

      // Convert questions to proper format if they're not already QuizQuestion objects
      final formattedQuestions = questions.map((question) {
        if (question is QuizQuestion) {
          return question.toJson();
        } else if (question is Map<String, dynamic>) {
          return {
            'question': question['question'] ?? '',
            'options': question['options'] ?? [],
            'answer': question['answer'] ?? '',
          };
        } else {
          throw Exception('Invalid question format');
        }
      }).toList();

      final body = jsonEncode({
        'title': title,
        'questions': formattedQuestions,
        'hours': hours,
        'minutes': minutes,
        'educationLevel': level,
        'Unit': unit,
        'paid': isPaid,
        if (isPaid) 'amountToPay': amountToPay,
      });

      final url = Uri.parse('${ApiEndPoints.baseUrl.trim()}${ApiEndPoints.quiz.addQuiz}');

      final response = await http.post(
        url,
        headers: {
         'Content-Type': 'application/json', 'token': token!,
        },
        body: body,
      );

      if (response.statusCode == 201) {
        await _showSuccessDialog();
        return true;
      } else {
        await _showErrorDialog(response.body);
        return false;
      }
    } catch (e) {
      await _showErrorDialog(e.toString());
      return false;
    }
  }

  static Future<void> _showSuccessDialog() async {
    await showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Quiz added successfully!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static Future<void> _showErrorDialog(String errorMessage) async {
    await showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text('Failed to add quiz: $errorMessage'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

//6- upload video
  static Future<void> uploadVideo(
      File videoFile, String title, String description) async {
    // Parse the upload URL
    var url = Uri.parse(
        ApiEndPoints.baseUrl.trim() + ApiEndPoints.content.uploadVideo);

    final request = http.MultipartRequest('POST', url);
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.headers['token'] = token!;
    // Add the video file to the request
    request.files
        .add(await http.MultipartFile.fromPath('video', videoFile.path));

    try {
      final response = await request.send();
      if (response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseBody);
        showDialog(
            context: Get.context!,
            builder: (context) {
              return const SimpleDialog(
                title: Text('Success'),
                contentPadding: EdgeInsets.all(20),
                children: [Text('Video uploaded successfully!')],
              );
            });
        print('Video uploaded successfully: $jsonResponse');
      } else {
        showDialog(
            context: Get.context!,
            builder: (context) {
              return SimpleDialog(
                title: const Text('Error'),
                contentPadding: const EdgeInsets.all(20),
                children: [
                  Text('Failed to upload video: ${response.statusCode}')
                ],
              );
            });
        print('Failed to upload video: ${response.statusCode}');
      }
    } catch (error) {
      print('Error uploading video: $error');
    }
  }

//7- upload PDF
  static Future<void> uploadPDF(
      String title, String description, File PDF) async {
    // Convert the Uri to a String
    String url = ApiEndPoints.baseUrl.trim() + ApiEndPoints.content.uploadPDF;
    // Create the multipart request
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add the fields to the request
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.headers['token'] = token!;

    // Add the file to the request
    var file = await http.MultipartFile.fromPath('pdf', PDF.path,
        filename: basename(
            PDF.path)); // basename is used to get the file name from path
    request.files.add(file);

    try {
      // Send the request
      var response = await request.send();

      // Check the response status
      if (response.statusCode == 201) {
        print('PDF Uploaded successful');
        showDialog(
            context: Get.context!,
            builder: (context) {
              return AlertDialog(
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
                  ],
                ),
              );
            });
        // Read the response if needed
        var responseData = await http.Response.fromStream(response);
        print('Response: ${responseData.body}');
      } else {
        print('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

//8- GET ALL PDFs

  Future<List<PDF>> fetchAllPDFs() async {
    var url =
        Uri.parse(ApiEndPoints.baseUrl.trim() + ApiEndPoints.content.allPDFs);
    http.Response response = await http.get(
      url,
      headers: {'Content-Type': 'application/json', 'token': token!},
    );
    var data = jsonDecode(response.body);

    List temp = [];
    print('apiiii PDFs $data');

    for (var i in data) {
      temp.add(i);
    }

    return PDF.itemsFromSnapshot(temp);
  }

//9- GET ALL Videos

  Future<List<Video>> fetchAllVideos() async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl.trim() + ApiEndPoints.content.uploadVideo);
    http.Response response = await http.get(
      url,
      headers: {'Content-Type': 'application/json', 'token': token!},
    );
    var data = jsonDecode(response.body);

    List temp = [];
    print('apiiii Videos $data');

    for (var i in data) {
      temp.add(i);
    }

    return Video.itemsFromSnapshot(temp);
  }

//10- GET ALL Notes

  static Future<List<Notes>> fetchAllNotes() async {
    var url =
        Uri.parse(ApiEndPoints.baseUrl.trim() + ApiEndPoints.content.allNotes);
    http.Response response = await http.get(
      url,
      headers: {'Content-Type': 'application/json', 'token': token!},
    );
    var data = jsonDecode(response.body);

    List temp = [];
    print('apiiii Notes $data');

    for (var i in data) {
      temp.add(i);
    }

    return Notes.itemsFromSnapshot(temp);
  }

  //11- add note

  static Future<void> addNote(String content, int educationLevel) async {
    var url =
        Uri.parse(ApiEndPoints.baseUrl.trim() + ApiEndPoints.content.addNote);

    http.Response response = await http.post(url,
        headers: {'Content-Type': 'application/json', 'token': token!},
        body:
            jsonEncode({'educationLevel': educationLevel, 'content': content}));

    if (response.statusCode == 201) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
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
                    'Note Added Successfully',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ibmPlexMono(
                      color: const Color(0xFF888888),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          });
    } else {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
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
                    'Warning!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ibmPlexMono(
                      color: const Color(0xFF164863),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${response.body}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ibmPlexMono(
                      color: const Color(0xFF888888),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          });
    }
  }

  //10-get all quizzes

  static Future<List<quizModel.Quiz>> getAllQuizzes() async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl.trim() + ApiEndPoints.quiz.getAllQuizzes);
    http.Response response = await http.get(url,
        headers: {'Content-Type': 'application/json', 'token': token!});

    var data = jsonDecode(response.body);

    List temp = [];
    print('apiiii Get Exams $data');

    for (var i in data) {
      temp.add(i);
    }

    return quizModel.Quiz.itemsFromSnapshot(temp);
  }

  //11-get all units used in exams
  // static Future<List> getExamUnits(){
  //   var url = Uri.parse(
  //     ApiEndPoints.baseUrl.trim() + ApiEndPoints.quiz.getExamUnits
  //   );
  //   http.Response response = await http.get(url,
  //       headers: {'Content-Type': 'application/json', 'token': token!});
  //
  //   var data = jsonDecode(response.body);
  //
  //   List temp = [];
  //   print('apiiii Get all Units $data');
  //
  //   for (var i in data) {
  //     temp.add(i);
  //   }
  //
  //   return quizModel.Quiz.itemsFromSnapshot(temp);
  // }
}
