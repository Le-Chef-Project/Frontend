class DirectChat {
  final String id;
  final List<Participant> participants;
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
          ?.map((e) => Participant.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      messages: (json['messages'] as List?)
          ?.map((msgJson) =>
          Message.fromJson(msgJson as Map<String, dynamic>))
          .toList() ??
          [], // Default to an empty list
      createdAt: json['createdAt'], // Keep as is (dynamic type)
      updatedAt: json['updatedAt'], // Keep as is (dynamic type)
    );
  }

  static List<DirectChat> itemsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return DirectChat.fromJson(data);
    }).toList();
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
      id: json['_id'] as String?,
      sender: json['sender'] is Map
          ? json['sender']['_id'] ?? '' // Extract ID if sender is a Map
          : json['sender'] ?? '', // Use as-is if it's already a String
      createdAt: json['createdAt'],
      content: json['content'] as String?,
      images: json['images'] != null
          ? List<String>.from(json['images'] as List)
          : [],
      documents: json['documents'] != null
          ? List<String>.from(json['documents'] as List)
          : [],
      audio: json['audio'] != null
          ? AudioData.fromJson(json['audio'] as Map<String, dynamic>)
          : null,
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
      data: json['data'] as String ?? '',
      contentType: json['contentType'] as String ?? '',
    );
  }
}

class Participant {
  final String id;
  final String username;
  final String email;
  final String? img;

  Participant({
    required this.id,
    required this.username,
    required this.email,
    required this.img,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      img: json['image']?['url'] ??
          'https://t4.ftcdn.net/jpg/02/15/84/43/360_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg',
    );
  }
}