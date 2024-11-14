class GroupChat {
  final String id;
  final String group;
  final List<GroupChatMessage> messages;

  GroupChat({
    required this.id,
    required this.group,
    required this.messages,
  });

  factory GroupChat.fromJson(Map<String, dynamic> json) {
    return GroupChat(
      id: json['_id'] ?? '',
      group: json['group'] ?? '',
      messages: (json['messages'] as List?)
          ?.map((msgJson) => GroupChatMessage.fromJson(msgJson))
          .toList() ??
          [],
    );
  }

  static List<GroupChat> itemsFromSnapshot(List snapshot) {
    return snapshot.map((data) => GroupChat.fromJson(data)).toList();
  }
}

class GroupChatMessage {
  final String id;
  final String sender;
  final String content;
  final List<String>? images;
  final List<String>? documents;
  final List<String>? audio;
  final DateTime createdAt;

  GroupChatMessage({
    required this.id,
    required this.sender,
    required this.content,
    this.images,
    this.documents,
    this.audio,
    required this.createdAt,
  });

  factory GroupChatMessage.fromJson(Map<String, dynamic> json) {
    return GroupChatMessage(
      id: json['_id'] ?? '',
      sender: json['sender'] ?? '',
      content: json['content'] ?? '',
      images: (json['images'] as List?)?.map((e) => e.toString()).toList(),
      documents: (json['documents'] as List?)?.map((e) => e.toString()).toList(),
      audio: (json['audio'] as List?)?.map((e) => e.toString()).toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}

