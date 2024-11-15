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

  static Future Savelevel(int educationLevel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('educationLevel', educationLevel);
  }

  static Future saveUserName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', name);
  }

  static Future saveUserId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Id', id);
  }
}
