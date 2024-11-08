class DirectChat {
  final String id;
  final List participants;
  final String sender;
  final String content;
  final List? images;
  final List? doc;
  final String? audio;
  final DateTime createdAt;

  DirectChat(
      {required this.id, required this.participants, required this.sender, required this.content, this.images, this.doc, this.audio, required this.createdAt});

  factory DirectChat.fromJson(Map<String, dynamic> json){
    return DirectChat(id: json['_id'] ?? '',
        participants: json['participants'] as List? ?? [],
        sender: json['sender'] ?? '',
        content: json['content'] ?? '',
        images: json['images'] as List? ?? [],
        doc: json['documents'] as List? ?? [],
        audio: json['audio'] ?? '',
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),);
  }

  static List<DirectChat> itemsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return DirectChat.fromJson(data);
    }).toList();
  }
}