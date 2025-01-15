import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/notification.dart';
import '../../main.dart';
import '../../utils/apiendpoints.dart';
import '../auth/login_service.dart';

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
