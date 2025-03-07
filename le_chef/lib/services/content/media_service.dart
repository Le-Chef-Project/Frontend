import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import '../../Models/PDF.dart';
import '../../Models/PDF_response.dart';
import '../../Models/Video.dart';
import '../../Models/video_response.dart';
import '../../main.dart';
import '../../utils/apiendpoints.dart';
import '../auth/login_service.dart';

class MediaService {
  static Future<String> uploadVideo({
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
      ..fields['paid'] =
          paid ? 'true' : 'false' // Send paid as string 'true' or 'false'
      ..fields['educationLevel'] =
          educationLevel.toString(); // Send educationLevel as string
    request.headers['token'] = token!;
    if (paid && amountToPay != null) {
      request.fields['amountToPay'] = amountToPay.toString();
    }

    // Add the video file to the request
    request.files
        .add(await http.MultipartFile.fromPath('video', videoFile.path));

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        return 'success';
      } else {
        return 'failed';
      }
    } catch (error) {
      print('Error uploading video: $error');
      return 'Error';
    }
  }

  static Future<String> uploadPDF({
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
      ..fields['paid'] = paid ? 'true' : 'false' // Boolean as 'true' or 'false'
      ..fields['educationLevel'] = educationLevel.toString(); // Int as string
    if (paid && amountToPay != null) {
      request.fields['amountToPay'] = amountToPay.toString();
    }

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
      print('apiiii upload PDF' + '${response.body}');

      if (response.statusCode == 201) {
        return 'success';
      } else {
        print('apiiii upload PDF' + '${response.body}');
        return 'failed';
      }
    } catch (e) {
      print('Error uploading file: $e');
      return 'Error';
    }
  }

  static Future<List<PDF>> fetchAllPDFsAdmin() async {
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

  static Future<PDFResponse> fetchAllPDFsUser() async {
    var url =
        Uri.parse(ApiEndPoints.baseUrl.trim() + ApiEndPoints.content.allPDFs);
    http.Response response = await http.get(
      url,
      headers: {'Content-Type': 'application/json', 'token': token!},
    );

    if (response.statusCode == 200) {
      print('User PDFssss ${json.decode(response.body)}');
      return PDFResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load videos: ${response.body}");
    }
  }


  static Future<VideoResponse> fetchAllVideosUser() async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl.trim() + ApiEndPoints.content.uploadVideo);
    http.Response response = await http.get(
      url,
      headers: {'Content-Type': 'application/json', 'token': token!},
    );

    if (response.statusCode == 200) {
      print('User videoooos ${json.decode(response.body)}');
      return VideoResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load videos: ${response.body}");
    }
  }

  static Future<List<Video>> fetchAllVideosAdmin() async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl.trim() + ApiEndPoints.content.uploadVideo);
    http.Response response = await http.get(
      url,
      headers: {'Content-Type': 'application/json', 'token': token!},
    );
    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      List temp = [];
      print('apiiii video ${data['videos']}');

      for (var i in data['videos']) {
        temp.add(i);
      }

      return Video.itemsFromSnapshot(temp);
    } else {
      throw Exception("Failed to load videos: ${response.body}");
    }
  }
}
