class Session {
  final String title;
  final String desc;
  final String date;
  final String startTime;
  final String endTime;
  final String hostUrl;
  final String educationLevel;
  final String createdAt;

  Session(
      {required this.title,
      required this.desc,
      required this.date,
      required this.startTime,
      required this.endTime,
      required this.hostUrl,
      required this.educationLevel,
      required this.createdAt});

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
        title: json['title'],
        desc: json['description'],
        date: json['date'],
        startTime: json['startTime'],
        endTime: json['endTime'],
        hostUrl: json['hostUrl'],
        createdAt: json['createdAt'],
        educationLevel: json['educationLevel']);
  }

  static List<Session> itemsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Session.fromJson(data);
    }).toList();
  }

}
