import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefes {
  static Future SaveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  static Future SaveRole(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('role', role);
  }
}
