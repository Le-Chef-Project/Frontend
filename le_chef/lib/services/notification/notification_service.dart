import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../Models/notification.dart';
import '../../utils/apiendpoints.dart';
import '../../main.dart';
import '../../Models/payment.dart' as payment_model;

class NotificationService {
  static Future<List<NotificationModel>> getNotifications() async {
    var url =
    role! == 'admin'
        ? Uri.parse(ApiEndPoints.baseUrl.trim() +
            ApiEndPoints.notification.getAdminNotification)
        : Uri.parse(ApiEndPoints.baseUrl.trim() +
            ApiEndPoints.notification.getUserNotification);
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'token': token!,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> notifications = data['notifications'] ?? [];
        return notifications
            .map((notification) => NotificationModel.fromJson(notification))
            .toList();
      } else {
        throw Exception('Failed to fetch notifications: ${response.body}');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }
}
