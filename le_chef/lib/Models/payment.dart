class Payment {
  final String id;
  final String userId;
  final String username;
  final String email;
  final double amount;
  final String status;
  final String method;
  final String contentType;
  final String contentId;
  final String? paymentImageUrl;
  final bool success;
  final String createdAt;

  Payment(
      {required this.id,
      required this.amount,
      required this.status,
      required this.method,
      required this.contentType,
      required this.contentId,
      required this.paymentImageUrl,
      required this.success, required this.userId, required this.username, required this.email, required this.createdAt});

  factory Payment.fromJson(dynamic json) {
    return Payment(
      id: json['paymentId'] ?? '',
      userId: json['user']?['_id'] ?? '',
      username: json['user']?['username'] ?? '',
      email: json['user']?['email'] ?? '',
      amount: (json['amount'] is num) ? json['amount'].toDouble() : 0.0,
      status: json['status'] ?? '',
      method: json['method'] ?? '',
      contentType: json['contentType'] ?? '',
      contentId: json['contentId'] ?? '',
      paymentImageUrl: json['paymentImageUrl'],
      success: json['success'] ?? false,
      createdAt: json['created_at'] as String,
    );
  }

  static List<Payment> itemsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Payment.fromJson(data);
    }).toList();
  }
}
