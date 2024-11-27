class Admin {
  String? id;
  String username;
  String email;
  String firstName;
  String lastName;
  String phone;
  String password;
  String role;
  String createdAt;
  String updatedAt;
  String? imageUrl;
  String? imagePublicId;

  Admin({
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.password,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    this.imageUrl,
    this.imagePublicId,
    this.id,
  });

  factory Admin.fromJson(dynamic json) {
    return Admin(
      id: json['_id'] ?? '',
      username: json['username'] as String,
      lastName: json['lastName'] as String,
      firstName: json['firstName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      password: json['password'] ?? '',
      role: json['role'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      imageUrl: json['image']?['url'] ?? '',
      imagePublicId: json['image']?['public_id'] ?? '',
    );
  }
}