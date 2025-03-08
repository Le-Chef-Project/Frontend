import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../main.dart';
import '../../utils/apiendpoints.dart';
import '../../Models/payment.dart' as payment_model;
import '../auth/login_service.dart';

class PaymentService {
  static Future<void> initiateEWalletPayment({
    required String contentId,
    required File paymentImage,
  }) async {
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
    final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
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
                      ' ${responseData['message']}',
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

  static Future<void> initiateCashPayment({
    required String contentId,
  }) async {
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

  static Future<void> acceptRequest(String paymentId) async {
    var url = Uri.parse(ApiEndPoints.baseUrl.trim() +
        ApiEndPoints.payment.requests +
        paymentId +
        ApiEndPoints.payment.accept);

    http.Response response = await http.post(
      url,
      headers: {
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

  static Future<void> rejectRequest(String paymentId) async {
    var url = Uri.parse(ApiEndPoints.baseUrl.trim() +
        ApiEndPoints.payment.requests +
        paymentId +
        ApiEndPoints.payment.reject);

    http.Response response = await http.post(
      url,
      headers: {
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
}
