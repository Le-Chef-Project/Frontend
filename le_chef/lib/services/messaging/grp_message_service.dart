import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';

import '../../main.dart';
import '../../utils/apiendpoints.dart';
import 'package:http/http.dart' as http;

import '../../Models/group.dart';
import '../../Models/group_chat.dart';
import '../auth/login_service.dart';

class GrpMsgService {
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
          'images',
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

      if (response.statusCode == 201) {
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
}
