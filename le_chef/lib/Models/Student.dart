import 'package:onesignal_flutter/onesignal_flutter.dart';

class Student {
  String username;
  final String Lastname;
  final String firstname;
  String email;
  String phone;
  String password;
  int educationLevel;
  final String ID;
  String? imageUrl;
  String? imagePublicId;
  final Future<String?> playerId;

  Student({
    required this.username,
    required this.Lastname,
    required this.firstname,
    required this.email,
    required this.phone,
    required this.password,
    required this.educationLevel,
    required this.ID,
    required this.playerId,
    this.imageUrl,
    this.imagePublicId,
  });

  factory Student.fromjson(dynamic json) {
    Future<String?> playerId = json['playerId'] ?? OneSignal.User.getOnesignalId() ?? '';

    return Student(
      ID: json['_id'] as String,
      username: json['username'] as String,
      Lastname: json['lastName'] as String,
      firstname: json['firstName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      educationLevel: json['educationLevel'] ?? '',
      password: json['password'] ?? '',
      imageUrl: json['image']?['url'] ??
          'https://t4.ftcdn.net/jpg/02/15/84/43/360_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg',
      imagePublicId: json['image']?['public_id'] ?? '',
      playerId: playerId,
    );
  }

  static List<Student> itemsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Student.fromjson(data);
    }).toList();
  }
}
