class Video {
  final String id;
  final String title;
  final String description;
  final String url;
  final bool isLocked;

  Video(
      {required this.id,
      required this.description,
      required this.title,
      required this.url,
      required this.isLocked});

  factory Video.fromjson(dynamic json) {
    return Video(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
      isLocked: json['isLocked'] as bool,
    );
  }

  static List<Video> itemsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Video.fromjson(data);
    }).toList();
  }
}
