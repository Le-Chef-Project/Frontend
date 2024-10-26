class Notes {
  final String id;
  final String title;
  final String content;
  final String url;
  final String createdAt;

  Notes(
      {required this.id,
      required this.content,
      required this.title,
      required this.url,
      required this.createdAt});

  factory Notes.fromjson(dynamic json) {
    return Notes(
      id: json['_id'] as String? ?? '', // Provide an empty string if null
      title: json['title'] as String? ?? '', // Provide an empty string if null
      content:
          json['content'] as String? ?? '', // Provide an empty string if null
      url: json['url'] as String? ?? '', // Provide an empty string if null
      createdAt:
          json['createdAt'] as String? ?? '', // Provide an empty string if null
    );
  }

  static List<Notes> itemsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Notes.fromjson(data);
    }).toList();
  }
}
