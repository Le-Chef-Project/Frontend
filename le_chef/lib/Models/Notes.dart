class Notes {
  final String id;
  final String title;
  final String content;
  final String url;

  Notes(
      {required this.id,
      required this.content,
      required this.title,
      required this.url});

  factory Notes.fromjson(dynamic json) {
    return Notes(
      id: json['_id'] as String,
      title: json['title'] as String,
      content: json['content'] == null ? '' : json['content'] as String,
      url: json['url'] as String,
    );
  }

  static List<Notes> itemsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Notes.fromjson(data);
    }).toList();
  }
}
