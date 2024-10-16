import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:le_chef/Screens/admin/THome.dart';

import '../Models/Student.dart';
import '../Screens/user/Home.dart';
import '../main.dart';
import 'SharedPrefes.dart';
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
    print('apiiii students $data');

    for (var i in data) {
      temp.add(i);
    }

    return Student.itemsFromSnapshot(temp);
  }

  //4-Delete Student
  static Future<void> DelStudent(String ID) async {
    var url = Uri.parse('${ApiEndPoints.baseUrl.trim()}${ApiEndPoints.userManage.DelStudent}$ID');
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
  static Future<void> AddQuiz(
    title,
    questions,
    hours,
    minutes,
  ) async {
    final body = jsonEncode({
      'title': title,
      'questions': questions,
      'hours': hours.toString(),
      'minutes': minutes.toString(),
    });

    var url =
        Uri.parse(ApiEndPoints.baseUrl.trim() + ApiEndPoints.quiz.addQuiz);
    http.Response response = await http.post(url,
        headers: {'Content-Type': 'application/json', 'token': token!},
        body: body);

    if (response.statusCode == 201) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return const SimpleDialog(
              title: Text('Success'),
              contentPadding: EdgeInsets.all(20),
              children: [Text('Quiz added successfully!')],
            );
          });
    } else {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: const Text('Error'),
              contentPadding: const EdgeInsets.all(20),
              children: [Text('Failed to add quiz: ${response.body}')],
            );
          });
    }
  }
}
