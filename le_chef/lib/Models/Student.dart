class Student {
  final String username;
  final String Lastname;
  final String firstname;
  final String email;
  final String phone;
  final String ID;

  Student({
    required this.username,
    required this.Lastname,
    required this.firstname,
    required this.email,
    required this.phone,
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
    );
  }

  static List<Student> itemsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Student.fromjson(data);
    }).toList();
  }
}
