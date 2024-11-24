class Student {
  String username;
  final String Lastname;
  final String firstname;
  String email;
  String phone;
  String password;
  int educationLevel;
  final String ID;

  Student({
    required this.username,
    required this.Lastname,
    required this.firstname,
    required this.email,
    required this.phone,
    required this.password,
    required this.educationLevel,
    required this.ID,
  });

  factory Student.fromjson(dynamic json) {
    return Student(
      ID: json['_id'] as String,
      username: json['username'] as String,
      Lastname: json['lastName'] as String,
      firstname: json['firstName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      educationLevel: json['educationLevel'] ?? '',
      password: json['password'] ?? '',
    );
  }

  static List<Student> itemsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Student.fromjson(data);
    }).toList();
  }
}
