import 'dart:convert';

import 'package:http/http.dart';

import '../../utils/apiendpoints.dart';
import '../../main.dart';

class SessionService{
  static Future<String> createSession(int level) async {
    try {
      var url = Uri.parse(ApiEndPoints.baseUrl.trim() + ApiEndPoints.session.createSession);

      Response response = await post(
          url,
          headers: {'Content-Type': 'application/json', 'token': token!},
          body: jsonEncode({'level': level})
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        return decodedResponse['session']['hostUrl'];
      } else {
        throw jsonDecode(response.body)['message'] ?? 'Unknown error occurred';
      }
    } catch (e) {
      throw e.toString();
    }
  }
}