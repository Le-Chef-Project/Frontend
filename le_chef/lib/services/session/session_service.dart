import 'dart:convert';

import 'package:http/http.dart';
import '../../Models/session.dart' as session;
import '../../main.dart';
import '../../utils/apiendpoints.dart';
import '../auth/login_service.dart';

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

  static Future<List<session.Session>> getSessions() async{

    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl.trim() + ApiEndPoints.session.getSession);

      Response response = await get(url, headers: {
        'Content-Type': 'application/json',
        'token': token!
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        var decodedResponse = jsonDecode(response.body)['sessions'];
        print('Sessions Retrived successflly');
        return session.Session.itemsFromSnapshot(decodedResponse);
      } else {
        throw 'Upload failed with status: ${response.statusCode}';
      }
    }catch (e) {
      throw e.toString();
    }
  }

  static Future<String> joinMeeting(String meetingId) async{
    try{
    var url = Uri.parse(ApiEndPoints.baseUrl.trim() + ApiEndPoints.session.joinSession);

    Response response = await post(url, headers: {
      'Content-Type': 'application/json',
      'token': token!
    }, body: jsonEncode({'meetingId': meetingId}));

    if (response.statusCode == 201 || response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);
      return decodedResponse['joinUrl'];
    } else {
      throw jsonDecode(response.body)['message'] ?? 'Unknown error occurred';
    }
  }catch (e) {
      throw e.toString();
    }
  }
}