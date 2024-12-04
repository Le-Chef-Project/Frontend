import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import '../../utils/apiendpoints.dart';
import '../../Models/direct_chat.dart';
import '../../main.dart';

class DirectMsgService{
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
}