class Group {
  final String id;
  final String title;
  final String desc;
  final List<String> members;
  final dynamic createdAt;
  final LastMessage lastMessage;

  Group({
    required this.id,
    required this.title,
    required this.desc,
    required this.members,
    required this.createdAt,
    required this.lastMessage,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['_id'] ?? '',
      members:
          (json['members'] as List?)?.map((e) => e as String).toList() ?? [],
      title: json['title'] ?? '',
      createdAt: json['createdAt'],
      desc: json['description'],
      lastMessage: LastMessage.fromJson(json['lastMessage'])

    );
  }

  static List<Group> itemsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Group.fromJson(data);
    }).toList();
  }
}


class LastMessage {
  final String? senderId;
  final String? content;
  final List<String> images;
  final List<String> documents;
  final List<String> audio;
  final String createdAt;

  LastMessage({
    this.senderId,
    this.content,
    this.images = const [],
    this.documents = const [],
    this.audio = const [],
    this.createdAt = '',
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      senderId: json['sender']?.toString(),
      content: json['content'],
      images: (json['images'] as List?)?.map((e) => e as String).toList() ?? [],
      documents: (json['documents'] as List?)?.map((e) => e as String).toList() ?? [],
      audio: (json['audio'] as List?)?.map((e) => e as String).toList() ?? [],
      createdAt: json['createdAt'] ?? '',
    );
  }
}
