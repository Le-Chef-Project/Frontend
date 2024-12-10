class NotificationModel {
  final String id;
  final String type;
  final String message;
  final String createdAt;
  final int level;

  NotificationModel({
    required this.id,
    required this.type,
    required this.message,
    required this.createdAt,
    required this.level,
  });

  // Factory constructor to create an instance from JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ??
          '', // Assuming '_id' is the identifier field in the backend
      type: json['type'] ?? 'No type',
      message: json['message'] ?? 'No Message',
      createdAt: json['createdAt'] ?? '',
      level: json['level'] ?? 0,
    );
  }

  // Convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'message': message,
      'createdAt': createdAt,
      'level': level,
    };
  }
}
