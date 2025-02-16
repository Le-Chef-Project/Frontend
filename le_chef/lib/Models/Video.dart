class Video {
  final String id;
  final String title;
  final String description;
  final String url;
  final bool isLocked;
  final bool paid;
  final int educationLevel;
  final int amountToPay;
  final String createdAt; // Ensure this is defined

  Video({
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

  factory Video.fromjson(Map<String, dynamic> json) {
    return Video(
      id: json['_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      educationLevel: json['educationLevel'] as int? ?? 0,
      url: json['url'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      isLocked: json['isLocked'] as bool? ?? false,
      paid: json['paid'] as bool? ?? false,
      amountToPay: json['amountToPay'] as int? ?? 0,
    );
  }

  static List<Video> itemsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Video.fromjson(data);
    }).toList();
  }

  // Convert Video object to JSON
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "title": title,
      "description": description,
      "educationLevel": educationLevel,
      "url": url,
      "createdAt": createdAt,
    };
  }
}
