class Group {
  final String id;
  final String title;
  final String desc;
  final List<String> members;
  final dynamic createdAt;

  Group({
    required this.id,
    required this.title,
    required this.desc,
    required this.members,
    required this.createdAt,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['_id'] ?? '',
      members:
          (json['members'] as List?)?.map((e) => e as String).toList() ?? [],
      title: json['title'] ?? '',
      createdAt: json['createdAt'],
      desc: json['description'],
    );
  }

  static List<Group> itemsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Group.fromJson(data);
    }).toList();
  }
}
