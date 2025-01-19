
import 'package:uuid/uuid.dart';

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
      messages:(json['messages'] as List?)
          ?.map((msgJson) =>
          GroupChatMessage.fromJson(msgJson as Map<String, dynamic>))  // Change this to use GroupChatMessage
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
  final String content;
  final Map<String, dynamic> sender; // Use a Map to store sender details
  final List<String>? images;
  final List<String>? documents;
  final List<String>? audio;
  final String createdAt;

  GroupChatMessage({
    required this.id,
    required this.content,
    required this.sender,
    this.images,
    this.documents,
    this.audio,
    required this.createdAt,
  });

  factory GroupChatMessage.fromJson(Map<String, dynamic> json) {
    return GroupChatMessage(
      id: json['_id'] ?? const Uuid().v4(),
      content: json['content'] ?? '',
      sender: json['sender'] ?? {}, // Parse the sender field
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      documents: json['documents'] != null ? List<String>.from(json['documents']) : null,
      audio: json['audio'] != null ? List<String>.from(json['audio']) : null,
      createdAt: json['createdAt'] ?? '',
    );
  }
}
