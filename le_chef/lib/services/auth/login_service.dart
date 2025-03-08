import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../Screens/admin/THome.dart';
import '../../Screens/user/Home.dart';
import '../../main.dart';
import '../../utils/SharedPrefes.dart';
import '../../utils/apiendpoints.dart';

class LoginService {
  static Future<void> login(
      String emailController, String passwordController) async {
    if (emailController.isEmpty || passwordController.isEmpty) {
      _showErrorDialog('Blank fields are not allowed.');
      return;
    }

    var url = Uri.parse(
      ApiEndPoints.baseUrl.trim() + ApiEndPoints.authEndPoint.loginEmail,
    );

    try {
      http.Response response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.trim(),
          'password': passwordController.trim(),
        }),
      );

      print('API Request: $emailController + $passwordController');
      final json = jsonDecode(response.body);
      print('API Response: $json');

      if (response.statusCode == 200) {
        if (json['token'] == null || json['role'] == null) {
          _showErrorDialog('Invalid API response: Missing token or role.');
          return;
        }

        // Save user data and update global variables
        await _saveUserData(json);

        // Update global variables
        token = json['token']; // Update the global token
        role = json['role']; // Update the global role

        if (json['role'] == "admin") {
          Get.offAll(
            () => const THome(),
            transition: Transition.fade,
            duration: const Duration(seconds: 1),
          );
        } else {
          await SharedPrefes.Savelevel(json['educationLevel'] ?? '');
          Get.offAll(
            () => const Home(),
            transition: Transition.fade,
            duration: const Duration(seconds: 1),
          );
          print('Education Level: ${json['educationLevel']}');
        }
      } else {
        _showErrorDialog(json['message'] ?? 'Login failed. Please try again.');
      }
    } catch (e) {
      print('Error during login: $e');
      _showErrorDialog('An error occurred. Please try again.');
    }
  }

  static Future<void> _saveUserData(Map<String, dynamic> json) async {
    try {
      if (json['token'] != null) {
        await SharedPrefes.SaveToken(json['token']);
      } else {
        throw Exception('Token is null');
      }

      await SharedPrefes.saveUserName(json['username'] ?? '');
      await SharedPrefes.saveUserId(json['_id'] ?? '');
      await SharedPrefes.SaveRole(json['role']);
      await SharedPrefes.saveImg(
        json['image']?['url'] ??
            'https://t4.ftcdn.net/jpg/02/15/84/43/360_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg',
      );
      await SharedPrefes.savePassword(json['password']);
      await SharedPrefes.saveEmail(json['email']);
      await SharedPrefes.savePhone(json['phone']);
      await SharedPrefes.Savelevel(json['educationLevel']);
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  static void _showErrorDialog(String message) {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Error'),
          contentPadding: const EdgeInsets.all(20),
          children: [Text(message)],
        );
      },
    );
  }
}
