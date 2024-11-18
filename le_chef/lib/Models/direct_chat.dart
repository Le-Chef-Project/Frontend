class DirectChat {
  final String id;
  final List<String> participants;
  final List<Message> messages;
  final dynamic createdAt;
  final dynamic updatedAt;

  DirectChat({
    required this.id,
    required this.participants,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DirectChat.fromJson(Map<String, dynamic> json) {
    return DirectChat(
      id: json['_id'] ?? '', // Default to an empty string if null
      participants: (json['participants'] as List?)
          ?.map((e) => e as String)
          .toList() ??
          [], // Default to an empty list
      messages: (json['messages'] as List?)
          ?.map((msgJson) =>
          Message.fromJson(msgJson as Map<String, dynamic>))
          .toList() ??
          [], // Default to an empty list
      createdAt: json['createdAt'], // Keep as is (dynamic type)
      updatedAt: json['updatedAt'], // Keep as is (dynamic type)
    );
  }

}

// Message model class
class Message {
  final String? id;
  final String sender;
  final dynamic createdAt;
  final String? content;
  final List<String>? images;
  final List<String>? documents;
  final AudioData? audio;
  // final bool? seen;

  Message({
    this.id,
    required this.sender,
    required this.createdAt,
    this.content,
    this.images,
    this.documents,
    this.audio,
    // this.seen,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'] as String?, // Allow nullable ID
      sender: json['sender'] ?? '', // Default to an empty string if null
      createdAt: json['createdAt'], // Keep as is (dynamic type)
      content: json['content'] as String?, // Allow nullable content
      images: json['images'] != null
          ? List<String>.from(json['images'] as List)
          : [], // Default to empty list
      documents: json['documents'] != null
          ? List<String>.from(json['documents'] as List)
          : [], // Default to empty list
      audio: json['audio'] != null
          ? AudioData.fromJson(json['audio'] as Map<String, dynamic>)
          : null, // Allow nullable audio
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