class PDF {
  final String id;
  final String title;
  final String description;
  final String url;
  final bool isLocked;
  final bool paid;
  final int amountToPay;
  final int educationLevel;
  final String createdAt; // Ensure this is defined

  PDF({
    required this.id,
    required this.description,
    required this.title,
    required this.url,
    required this.paid,
    required this.educationLevel,
    required this.isLocked,
    required this.amountToPay,
    required this.createdAt, // Ensure this is defined
  });

  factory PDF.fromjson(Map<String, dynamic> json) {
    return PDF(
      id: json['_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      educationLevel: json['educationLevel'] as int? ?? 0,
      url: json['url'] as String? ?? '',
      isLocked: json['isLocked'] as bool? ?? false,
      paid: json['paid'] as bool? ?? false,
      amountToPay: json['amountToPay'] as int? ?? 0,
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  static List<PDF> itemsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return PDF.fromjson(data);
    }).toList();
  }
}
