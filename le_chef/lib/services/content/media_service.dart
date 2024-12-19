import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import '../../Models/PDF.dart';
import '../../Models/Video.dart';
import '../../main.dart';
import '../../utils/apiendpoints.dart';

class MediaService{
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

  static Future<List<PDF>> fetchAllPDFs() async {
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

}