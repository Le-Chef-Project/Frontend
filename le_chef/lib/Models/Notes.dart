class Notes {
  final String id;
  final String content;
  final String createdAt;
  final int educationLevel;

  Notes(
      {required this.id,
      required this.content,
      required this.createdAt,
      required this.educationLevel});

  factory Notes.fromjson(Map<String, dynamic> json) {
    return Notes(
        id: json['_id'] as String? ?? '', // Provide an empty string if null
        content:
            json['content'] as String? ?? '', // Provide an empty string if null
        createdAt: json['createdAt'] as String? ??
            '', // Provide an empty string if null
        educationLevel: json['educationLevel'] as int? ?? 0);
  }

  static List<Notes> itemsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Notes.fromjson(data);
    }).toList();
  }
}
