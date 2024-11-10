class GroupChat {
  final String id;
  final String group;
  final String sender;
  final String content;
  final List? images;
  final List? doc;
  final String? audio;
  final DateTime createdAt;

  GroupChat(
      {required this.id,required this.group,  required this.sender, required this.content, this.images, this.doc, this.audio, required this.createdAt});

  factory GroupChat.fromJson(Map<String, dynamic> json){
    return GroupChat(id: json['_id'] ?? '',
      group: json['group'],
      sender: json['sender'] ?? '',
      content: json['content'] ?? '',
      images: json['images'] as List? ?? [],
      doc: json['documents'] as List? ?? [],
      audio: json['audio'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),);
  }

  static List<GroupChat> itemsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return GroupChat.fromJson(data);
    }).toList();
  }
}