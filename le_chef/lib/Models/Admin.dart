class Admin {
  String? id;
  String username;
  String? email;
  String firstName;
  String lastName;
  String? phone;
  String? password;
  String? role;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;
  String? imagePublicId;

  Admin({
    required this.username,
    this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.password,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.imageUrl,
    this.imagePublicId,
    this.id,
  });

  factory Admin.fromJson(dynamic json) {
    return Admin(
      id: json['_id'] as String? ?? '', // Default value if missing
      username: json['username'] as String? ?? '', // Default value if missing
      firstName: json['firstName'] as String? ?? '', // Default value if missing
      lastName: json['lastName'] as String? ?? '', // Default value if missing
      email: json['email'] as String?, // Set to null if missing
      phone: json['phone'] as String?, // Set to null if missing
      password: json['password'] as String?, // Set to null if missing
      role: json['role'] as String?, // Set to null if missing
      createdAt: json['created_at'] as String?, // Set to null if missing
      updatedAt: json['updated_at'] as String?, // Set to null if missing
      imageUrl: json['image']?['url'] ?? 'https://t4.ftcdn.net/jpg/02/15/84/43/360_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg', // Set to null if missing
      imagePublicId: json['image']?['public_id'] as String?, // Set to null if missing
    );
  }
}