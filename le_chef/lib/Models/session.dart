class Session {
  final String title;
  final String desc;
  final String date;
  final String startTime;
  final String endTime;
  final String hostUrl;
  final String createdAt;

  Session(
      {required this.title,
      required this.desc,
      required this.date,
      required this.startTime,
      required this.endTime,
      required this.hostUrl,
        required this.createdAt});
  
  factory Session.fromJon(dynamic json){
    return Session(title: json['title'], desc: json['description'], date: json['date'], startTime: json['startTime'], endTime: json['endTime'], hostUrl: json['hostUrl'], createdAt: json['createdAt']);
  }
}
