class PDF {
  final String id;
  final String title;
  final String description;
  final String url;

  PDF(
      {required this.id,
      required this.description,
      required this.title,
      required this.url});

  factory PDF.fromjson(dynamic json) {
    return PDF(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
    );
  }

  static List<PDF> itemsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return PDF.fromjson(data);
    }).toList();
  }
}
