class Session {
  final String title;
  final String desc;
  final String hostUrl;
  final String joinUrl;
  final String educationLevel;
  final String createdAt;

  Session(
      {required this.title,
      required this.desc,
      required this.hostUrl,
        required this.joinUrl,
      required this.educationLevel,
      required this.createdAt});

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
        title: json['title'],
        desc: json['description'],
        hostUrl: json['hostUrl'],
        joinUrl: json['joinUrl'],
        createdAt: json['createdAt'],
        educationLevel: json['educationLevel']);
  }

  static List<Session> itemsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Session.fromJson(data);
    }).toList();
  }

}
