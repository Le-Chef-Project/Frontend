class DirectChat {
  final String id;
  final List<String> participants;
  final List<Message> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  DirectChat({
    required this.id,
    required this.participants,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DirectChat.fromJson(Map<String, dynamic> json) {
    return DirectChat(
      id: json['_id'] ?? '',
      participants: json['participants'] != null
          ? List<String>.from(json['participants'])
          : [],
      messages: json['messages'] != null
          ? List<Message>.from(
          json['messages'].map((msg) => Message.fromJson(msg)))
          : [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  static List<DirectChat> itemsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return DirectChat.fromJson(data);
    }).toList();
  }
}

class Message {
  final String id;
  final String sender;
  final String content;
  final List<String>? images;
  final List<String>? documents;
  final AudioData? audio;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.sender,
    required this.content,
    this.images,
    this.documents,
    this.audio,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'] ?? '',
      sender: json['sender'] ?? '',
      content: json['content'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      documents: json['documents'] != null ? List<String>.from(json['documents']) : null,
      audio: json['audio'] != null ? AudioData.fromJson(json['audio']) : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}

class AudioData {
  final String data;
  final String contentType;

  AudioData({
    required this.data,
    required this.contentType,
  });

  factory AudioData.fromJson(Map<String, dynamic> json) {
    return AudioData(
      data: json['data'] ?? '',
      contentType: json['contentType'] ?? '',
    );
  }
}