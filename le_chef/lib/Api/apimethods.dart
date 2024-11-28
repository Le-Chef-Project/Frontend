import 'dart:convert';
import 'dart:io';
import 'package:le_chef/Models/Admin.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../Models/session.dart' as session;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:le_chef/Models/PDF.dart';
import 'package:le_chef/Models/Quiz.dart' as quizModel;
import 'package:le_chef/Models/Video.dart';
import 'package:le_chef/Models/direct_chat.dart';
import 'package:le_chef/Models/group_chat.dart';
import 'package:le_chef/Screens/admin/THome.dart';
import 'package:le_chef/Screens/user/examResultbyID.dart';
import 'package:path/path.dart'; // To get the file name

import '../Models/Notes.dart';
import '../Models/Quiz.dart';
import '../Models/Student.dart';
import '../Models/group.dart';
import '../Screens/user/Home.dart';
import '../main.dart';
import 'SharedPrefes.dart';
import 'apiendpoints.dart';
import '../Models/payment.dart' as payment_model;

class ApisMethods {
  static String? token = sharedPreferences!.getString('token');
  static String? role = sharedPreferences!.getString('role');

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
      print('apiiii $json');

      if (response.statusCode == 200) {
        SharedPrefes.SaveToken(json['token']);
        SharedPrefes.saveUserName(json['username']);
        SharedPrefes.saveUserId(json['_id']);
        SharedPrefes.SaveRole(json['role']);
        SharedPrefes.saveImg(json['image']['url']);
        if (json['role'] == "admin") {
          Get.off(const THome(),
              transition: Transition.fade,
              duration: const Duration(seconds: 1));
        } else {
          SharedPrefes.Savelevel(json['educationLevel']);
          Get.off(const Home(),
              transition: Transition.fade,
              duration: const Duration(seconds: 1));
          print('educationLevel is ' + json['educationLevel']);
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
  static Future<void> addQuiz({
    required String title,
    required List<dynamic> questions,
    required int hours,
    required int minutes,
    required int? level,
    required int? unit,
    required bool isPaid,
    double? amountToPay,
  }) async {
    if (questions.isEmpty) {
      throw Exception('Questions list cannot be empty');
    }

    if (isPaid && amountToPay == null) {
      throw Exception('Amount to pay is required for paid quizzes');
    }

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

    final url =
        Uri.parse('${ApiEndPoints.baseUrl.trim()}${ApiEndPoints.quiz.addQuiz}');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'token': token!,
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print('${jsonDecode(response.body)['message']}');
    } else {
      print('${jsonDecode(response.body)['message']}');
    }
  }

//6- upload video
  static Future<void> uploadVideo({
    required File videoFile,
    required String title,
    required String description,
    double? amountToPay,
    required bool paid,
    required int educationLevel,
  }) async {
    // Parse the upload URL
    var url = Uri.parse(
        ApiEndPoints.baseUrl.trim() + ApiEndPoints.content.uploadVideo);

    final request = http.MultipartRequest('POST', url)
      ..fields['title'] = title
      ..fields['description'] = description
      ..fields['amountToPay'] =
          amountToPay.toString() // Send amountToPay as string
      ..fields['paid'] =
          paid ? 'true' : 'false' // Send paid as string 'true' or 'false'
      ..fields['educationLevel'] =
          educationLevel.toString(); // Send educationLevel as string
    request.headers['token'] = token!;

    // Add the video file to the request
    request.files
        .add(await http.MultipartFile.fromPath('video', videoFile.path));

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        final jsonResponse = jsonDecode(responseData);
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
                children: [Text('Failed to upload video: ${response.body}')],
              );
            });
        print('Failed to upload video: ${response.body}');
      }
    } catch (error) {
      print('Error uploading video: $error');
    }
  }

//7- upload PDF
  static Future<void> uploadPDF({
    required String title,
    required String description,
    double? amountToPay,
    required bool paid,
    required int educationLevel,
    required File PDF,
  }) async {
    // Convert the Uri to a String
    String url = ApiEndPoints.baseUrl.trim() + ApiEndPoints.content.uploadPDF;
    // Create the multipart request
    var request = http.MultipartRequest('POST', Uri.parse(url))

      // Add the fields to the request
      ..fields['title'] = title
      ..fields['description'] = description
      ..fields['amountToPay'] = amountToPay.toString() // Double as string
      ..fields['paid'] = paid ? 'true' : 'false' // Boolean as 'true' or 'false'
      ..fields['educationLevel'] = educationLevel.toString(); // Int as string

    request.headers['token'] = token!;

    // Add the file to the request
    var file = await http.MultipartFile.fromPath('pdf', PDF.path,
        filename: basename(
            PDF.path)); // basename is used to get the file name from path
    request.files.add(file);

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      // Check the response status
      if (response.statusCode == 201) {
        // Read the response if needed
        final responseData = jsonDecode(response.body);

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
        print('Response: $responseData');
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

  static Future<List<Video>> fetchAllVideos() async {
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
                    response.body,
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

  //12-get all quizzes

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

  //13-get all units used in meeting
  static Future<List> getExamUnits() async {
    var url =
        Uri.parse(ApiEndPoints.baseUrl.trim() + ApiEndPoints.quiz.getExamUnits);
    http.Response response = await http.get(url,
        headers: {'Content-Type': 'application/json', 'token': token!});

    var data = jsonDecode(response.body);

    List temp = [];
    print('apiiii Get all Units $data');

    // Access the 'units' list inside 'data'
    if (data.containsKey('units') && data['units'] is List) {
      temp = data['units'];
    } else {
      throw Exception(
          "Unexpected data format: 'units' key not found or is not a list.");
    }

    return temp;
  }

  //14-Delete quiz
  static Future<void> delQuiz(String id) async {
    var url = Uri.parse(
        '${ApiEndPoints.baseUrl.trim()}${ApiEndPoints.quiz.delQuiz}$id');
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

  //15-update quiz
  static Future<void> updateQuiz({
    required String id,
    required List<dynamic> questions,
    required int hours,
    required int minutes,
  }) async {
    final Map<String, dynamic> body = {
      'questions': questions
          .map((q) => {
                'question': q['question'],
                'options': q['options'],
                'answer': q['answer'],
              })
          .toList(),
      'hours': hours,
      'minutes': minutes,
    };

    var url = Uri.parse(
        '${ApiEndPoints.baseUrl.trim()}${ApiEndPoints.quiz.updateQuiz}$id');

    http.Response response = await http.put(url,
        headers: {'Content-Type': 'application/json', 'token': token!},
        body: jsonEncode(body));
    if (response.statusCode == 200) {
      print('${jsonDecode(response.body)['message']}');
    } else {
      print('${jsonDecode(response.body)['message']}');
    }
  }

  //16- submit quiz

  static Future<Map<String, dynamic>> submitQuiz(
    quizModel.Quiz quiz,
    answers,
    String quizID,
  ) async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl.trim() + ApiEndPoints.quiz.submitQuiz + quizID);

    http.Response response = await http.post(url,
        headers: {'Content-Type': 'application/json', 'token': token!},
        body: jsonEncode({'answers': answers}));

    if (response.statusCode == 201) {
      Get.to(ExamResult(
        answers: answers,
        quiz_result: jsonDecode(response.body),
        quiz: quiz,
      ));
      return jsonDecode(response.body);
    } else {
      throw Exception(
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
                      '${jsonDecode(response.body)['message'] ?? 'Failed to submit quiz'}',
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
            }),
      );
    }
  }

  //17-send direct msg
  static Future<void> sendDirectMsg({
    required String id,
    required List<String> participants,
    required String sender,
    required String content,
    List<File>? images,
    List<File>? documents,
    String? audio,
    DateTime? createdAt,
  }) async {
    final url = Uri.parse(
        '${ApiEndPoints.baseUrl.trim()}${ApiEndPoints.chat.sendDirectMsg}$id');

    var request = http.MultipartRequest('POST', url);

    request.headers['token'] = token!;

    request.fields['sender'] = sender;
    request.fields['content'] = content;
    request.fields['createdAt'] =
        (createdAt ?? DateTime.now()).toIso8601String();

    if (audio != null) {
      request.files.add(await http.MultipartFile.fromPath('audio', audio));
    }

    if (images != null && images.isNotEmpty) {
      for (var i = 0; i < images.length; i++) {
        final imageFile = await http.MultipartFile.fromPath(
          'image',
          images[i].path,
          filename: basename(images[i].path),
        );
        request.files.add(imageFile);
      }
    }

    if (documents != null && documents.isNotEmpty) {
      for (var i = 0; i < documents.length; i++) {
        final documentFile = await http.MultipartFile.fromPath(
          'documents',
          documents[i].path,
          filename: basename(documents[i].path),
        );
        request.files.add(documentFile);
      }
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Message sent successfully: ${responseData['message']}');
      } else {
        print('Error: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending message: $e');
      throw Exception('Failed to send message: $e');
    }
  }

  //18-get direct msgs
  static Future<DirectChat> getDirectMessages(String chatRoomId) async {
    try {
      final url = Uri.parse(
        '${ApiEndPoints.baseUrl.trim()}${ApiEndPoints.chat.getDirectMsg}$chatRoomId',
      );

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'token': token!,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Debugging: Print the response for verification
        print('Response data: $responseData');

        // Parse the response and return
        return DirectChat.fromJson(responseData);
      } else if (response.statusCode == 404) {
        throw Exception('Chat room not found.');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized request. Check your token.');
      } else {
        throw Exception(
            'Failed to fetch messages. HTTP ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error fetching messages: $e');
      print('Stack trace: $stackTrace');

      // Re-throw the exception with a custom message
      throw Exception('An error occurred while fetching messages: $e');
    }
  }

  //19- create grp
  static Future<void> createGrp(String title, String desc) async {
    var url =
        Uri.parse(ApiEndPoints.baseUrl.trim() + ApiEndPoints.chat.createGrp);

    http.Response response = await http.post(url,
        headers: {'Content-Type': 'application/json', 'token': token!},
        body: jsonEncode({'title': title, 'description': desc}));

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
                    'Group Added Successfully',
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
      print('group  ${response.body}');
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
                      response.body,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ibmPlexMono(
                        color: const Color(0xFF888888),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ));
          });
    }
  }

//20-get all admin & student groups
  static Future<List<Group>> getAllGroups() async {
    var url = role! == 'admin'
        ? Uri.parse(
            ApiEndPoints.baseUrl.trim() + ApiEndPoints.chat.getAdminGroups)
        : Uri.parse(
            ApiEndPoints.baseUrl.trim() + ApiEndPoints.chat.getStudentGroups);

    http.Response response = await http.get(url,
        headers: {'Content-Type': 'application/json', 'token': token!});

    var data = jsonDecode(response.body);

    List temp = [];
    print('apiiii Get Groups ${data['groups']}');

    for (var i in data['groups']) {
      temp.add(i);
    }

    return Group.itemsFromSnapshot(temp);
  }

  //21-Delete grp
  static Future<void> DelGroup(String ID) async {
    var url = Uri.parse(
        '${ApiEndPoints.baseUrl.trim()}${ApiEndPoints.chat.deleteGroup}$ID');
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

//22- get group members
  static Future<List<dynamic>?> getGroupMembers(String groupId) async {
    var url = Uri.parse(
        '${ApiEndPoints.baseUrl.trim()}${ApiEndPoints.chat.getGroupMembers}$groupId');
    http.Response response = await http.get(
      url,
      headers: {'Content-Type': 'application/json', 'token': token!},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['members'];
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return null; // Return null in case of an error
    }
  }

//23- remove student from group
  static Future<void> removeStudentFromGroup({
    required String groupId,
    required String studentId,
  }) async {
    var url = Uri.parse(
        '${ApiEndPoints.baseUrl.trim()}${ApiEndPoints.chat.removeStudent}$groupId');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'token': token!,
      },
      body: jsonEncode({
        'studentIds': [studentId],
      }),
    );

    if (response.statusCode == 200) {
      print('Student removed successfully');
    } else {
      final responseData = jsonDecode(response.body);
      throw Exception(
          'erorrrrrr' + responseData['message'] ?? 'Failed to remove student');
    }
  }

// 24- add students to group
  static Future<void> addStudentstoGroup({
    required String groupId,
    required List<String> studentIds,
  }) async {
    var url = Uri.parse(
        '${ApiEndPoints.baseUrl.trim()}${ApiEndPoints.chat.addStudentstoGroup}$groupId');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'token': token!,
      },
      body: jsonEncode({
        'studentIds': studentIds, // Send the list of student IDs
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
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
                    'Students Added Successfully',
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
      final errorData = jsonDecode(response.body);

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
                      errorData['message'],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ibmPlexMono(
                        color: const Color(0xFF888888),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ));
          });
    }
  }

  //25-send direct msg
  static Future<void> sendgrpMsg({
    required String group,
    required String sender,
    required String content,
    List<File>? images,
    List<File>? documents,
    String? audio,
    DateTime? createdAt,
  }) async {
    final url = Uri.parse(
        '${ApiEndPoints.baseUrl.trim()}${ApiEndPoints.chat.sendGrpMsg}$group');

    var request = http.MultipartRequest('POST', url);

    request.headers['token'] = token!;

    request.fields['sender'] = sender;
    request.fields['content'] = content;
    request.fields['createdAt'] =
        (createdAt ?? DateTime.now()).toIso8601String();

    if (audio != null) {
      request.files.add(await http.MultipartFile.fromPath('audio', audio));
    }

    if (images != null && images.isNotEmpty) {
      for (var i = 0; i < images.length; i++) {
        final imageFile = await http.MultipartFile.fromPath(
          'image',
          images[i].path,
          filename: basename(images[i].path),
        );
        request.files.add(imageFile);
      }
    }

    if (documents != null && documents.isNotEmpty) {
      for (var i = 0; i < documents.length; i++) {
        final documentFile = await http.MultipartFile.fromPath(
          'documents',
          documents[i].path,
          filename: basename(documents[i].path),
        );
        request.files.add(documentFile);
      }
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Message sent successfully: ${responseData['message']}');
      } else {
        print('Error: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending message: $e');
      throw Exception('Failed to send message: $e');
    }
  }

  //26-get Group msgs
  static Future<GroupChat> getGrpMessages(String groupId) async {
    try {
      final url = Uri.parse(
        '${ApiEndPoints.baseUrl.trim()}${ApiEndPoints.chat.getGroupMsg}$groupId',
      );

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'token': token!,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Debugging: Print the response for verification
        print('Response data: $responseData');

        // Parse the response and return
        return GroupChat.fromJson(responseData);
      } else if (response.statusCode == 404) {
        throw Exception('Chat room not found.');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized request. Check your token.');
      } else {
        throw Exception(
            'Failed to fetch messages. HTTP ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error fetching messages: $e');
      print('Stack trace: $stackTrace');

      // Re-throw the exception with a custom message
      throw Exception('An error occurred while fetching messages: $e');
    }
  }

  //27-get chats
  static Future<List<DirectChat>> getAllChats() async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl.trim() + ApiEndPoints.chat.getAdminChats);

    http.Response response = await http.get(url,
        headers: {'Content-Type': 'application/json', 'token': token!});

    var data = jsonDecode(response.body);

    List temp = [];
    print('apiiii Get Chats ${data['directChats']}');

    for (var i in data['directChats']) {
      temp.add(i);
    }

    return DirectChat.itemsFromSnapshot(temp);
  }

  //28- paymeny by Credit card
  static Future<Map<String, dynamic>> initiateCreditCardPayment({required String contentId,}) async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl.trim() + ApiEndPoints.payment.credieCard);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'token': token!,
      },
      body: jsonEncode({
        'contentId': contentId,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to initiate payment: ${response.statusCode}, ${response.body}');
    }
  }

//29- e wallet payment

  static Future<void> initiateEWalletPayment({required String contentId, required File paymentImage,}) async {
    var url = Uri.parse(ApiEndPoints.baseUrl.trim() +
        ApiEndPoints.payment.E_Wallet +
        contentId);

    // Prepare the multipart request
    final request = http.MultipartRequest('POST', url)
      ..headers['token'] = token! // Attach token
      ..files.add(await http.MultipartFile.fromPath(
        'paymentImage',
        paymentImage.path,
      ));

    // Send the request
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
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
                    ' ${responseData['message']}',
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
                      response.body,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ibmPlexMono(
                        color: const Color(0xFF888888),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ));
          });
    }
  }

//30- cash payment

  static Future<void> initiateCashPayment({required String contentId,}) async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl.trim() + ApiEndPoints.payment.Cash + contentId);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'token': token!,
      },
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
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
                    ' ${responseData['message']}',
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
      final errorData = jsonDecode(response.body);

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
                      errorData['message'],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ibmPlexMono(
                        color: const Color(0xFF888888),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ));
          });
    }
  }

  //31- get payment requests
  static Future<List<payment_model.Payment>> getAllRequest() async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl.trim() + ApiEndPoints.payment.getPaymentReq);

    http.Response response = await http.get(url,
        headers: {'Content-Type': 'application/json', 'token': token!});

    var data = jsonDecode(response.body);

    List temp = [];
    print('apiiii Get Requests ${data['payments']}');

    for (var i in data['payments']) {
      temp.add(i);
    }

    return payment_model.Payment.itemsFromSnapshot(temp);
  }

  //32-accept payment request
  static Future<void> acceptRequest(String paymentId) async{
    var url = Uri.parse(ApiEndPoints.baseUrl.trim() + ApiEndPoints.payment.requests + paymentId + ApiEndPoints.payment.accept);

    http.Response response = await http.post(
      url, headers: {
      'Content-Type': 'application/json',
      'token': token!,
    },
      body: jsonEncode({
        'status': 'success',
      }),
    );

    if (response.statusCode == 200) {
      print('Updated status Successfully: ${jsonDecode(response.body)}');
    } else {
      throw Exception(
          'Failed to Update payment status: ${response.statusCode}, ${response.body}');
    }
  }

  //33-reject payment request
  static Future<void> rejectRequest(String paymentId) async{
    var url = Uri.parse(ApiEndPoints.baseUrl.trim() + ApiEndPoints.payment.requests + paymentId + ApiEndPoints.payment.reject);

    http.Response response = await http.post(
      url, headers: {
      'Content-Type': 'application/json',
      'token': token!,
    },
      body: jsonEncode({
        'status': 'failed',
      }),
    );

    if (response.statusCode == 200) {
      print('Updated status Successfully: ${jsonDecode(response.body)}');
    } else {
      throw Exception(
          'Failed to Update payment status: ${response.statusCode}, ${response.body}');
    }
  }

  //34- edit profile
  static Future<void> editProfile({
    String? userId,
    String? username,
    String? email,
    String? phone,
    String? password,
    int? educationLevel,
    File? imageFile,
  }) async {
    final url = Uri.parse(
        '${ApiEndPoints.baseUrl.trim()}${ApiEndPoints.userManage.editProfile}$userId');
    print('Request URL: $url');

    var request = http.MultipartRequest('PUT', url)
      ..headers['token'] = token!;

    if (username != null) request.fields['username'] = username;
    if (email != null) request.fields['email'] = email;
    if (phone != null) request.fields['phone'] = phone;
    if (password != null) request.fields['password'] = password;
    if (educationLevel != null) {
      request.fields['educationLevel'] = educationLevel.toString();
    }

    if (imageFile != null) {
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile(
        'image',
        stream,
        length,
        filename: imageFile.path.split('/').last,
      );
      request.files.add(multipartFile);
    }

    print('Request Fields: ${request.fields}');
    print('Request Files: ${request.files.map((file) => file.filename).toList()}');

    try {
      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        print('Profile updated successfully.');
        print('Response: ${jsonDecode(responseBody.body)['message']}');
      } else {
        print('Error: ${response.statusCode}');
        print('Raw Response: ${responseBody.body}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }

  //35-create session
static Future<void> createSession(
    int level,
) async{
    var url = Uri.parse(ApiEndPoints.baseUrl.trim() + ApiEndPoints.session.createSession);

    http.Response response = await http.post(
      url, headers: {'Content-Type': 'application/json', 'token': token!}, body: jsonEncode({
      'educationLevel' : level
    })
    );

    if (response.statusCode == 200) {
      print('${jsonDecode(response.body)['message']}');
    } else {
      print('${jsonDecode(response.body)['message']}');
    }
}

  static Future<void> sendNotificationsToStudents(List<Student> students) async {
    // Updated URL to use the OneSignal API endpoint
    var notificationUrl = Uri.parse("https://onesignal.com/api/v1/notifications");

    // Replace this with the correct API key from your OneSignal Dashboard
    const String oneSignalApiKey = "esxyno7xzut45ek3o3qr5lyfo"; // REST API Key
    const String oneSignalAppId = "29357873-0cf5-4e66-b038-cdf4ce3906b4"; // Your OneSignal App ID

    for (var student in students) {
      try {
        // Resolve the playerId future
        var playerId = await student.playerId; // Use await to get the resolved value

        var notificationData = {
          "app_id": oneSignalAppId,
          "include_player_ids": [playerId], // Ensure playerId is a valid string
          "headings": {"en": "New Session Created"},
          "contents": {
            "en": "A new session has been created. Join now!"
          },
        };

        // Send notification request
        http.Response response = await http.post(
          notificationUrl,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Basic $oneSignalApiKey', // Authorization header
          },
          body: jsonEncode(notificationData),
        );

        if (response.statusCode == 200) {
          print('Notification sent to student ID: ${student.ID}');
        } else {
          print('Failed to send notification: ${response.statusCode} - ${response.body}');
        }
      } catch (e) {
        print('Error sending notification to student ID: ${student.ID}, $e');
      }
    }
  }

  //36- get sessions
  static Future<List<session.Session>> getSessions() async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl.trim() + ApiEndPoints.session.getSessions);

    http.Response response = await http.get(url,
        headers: {'Content-Type': 'application/json', 'token': token!});

    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {

      List temp = [];
      print('apiiii Sessions $data');

      for (var i in data) {
        temp.add(i);
      }

      return session.Session.itemsFromSnapshot(temp);
    } else {
      throw Exception(
          'Failed to fetch messages. HTTP ${response.statusCode}\n ${response.body}');
    }
    }

    //37-get admin
  static Future<Admin> getAdmin() async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl.trim() + ApiEndPoints.userManage.getAdmin);

    http.Response response = await http.get(url,
        headers: {'Content-Type': 'application/json', 'token': token!});

    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {

      print('apiiii Admin ${data['admin']}');

      return Admin.fromJson(data['admin']);
    } else {
      throw Exception(
          'Failed to fetch messages. HTTP ${response.statusCode}\n ${response.body}');
    }
    }
}
