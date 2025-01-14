import 'dart:convert';
import 'package:http/http.dart';
import '../../main.dart';
import '../../Models/Admin.dart' as admin;
import '../../utils/apiendpoints.dart';
class AdminService{
  static Future<admin.Admin> getAdmin(String token) async {
    var url = Uri.parse(
        ApiEndPoints.baseUrl.trim() + ApiEndPoints.userManage.getAdmin);

    Response response = await get(url,
        headers: {'Content-Type': 'application/json', 'token': token!});

    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {

      print('apiiii Admin ${data['admin']}');

      return admin.Admin.fromJson(data['admin']);
    } else {
      throw Exception(
          'Failed to fetch messages. HTTP ${response.statusCode}\n ${response.body}');
    }
  }
}