import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../../main.dart';
import '../../utils/apiendpoints.dart';
import '../auth/login_service.dart';

class ProfileService{
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

    var request = MultipartRequest('PUT', url)
      ..headers['token'] = token!;

    if (username != null) request.fields['username'] = username;
    if (email != null) request.fields['email'] = email;
    if (phone != null) request.fields['phone'] = phone;
    if (password != null) request.fields['password'] = password;
    if (educationLevel != null) {
      request.fields['educationLevel'] = educationLevel.toString();
    }

    if (imageFile != null) {
      var stream = ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      var multipartFile = MultipartFile(
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
      var responseBody = await Response.fromStream(response);

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
}