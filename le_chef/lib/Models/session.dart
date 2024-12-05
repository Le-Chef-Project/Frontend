class Session {
  final String? title;        // Made nullable
  final String? desc;         // Made nullable
  final String hostUrl;       // Required from API response
  final String joinUrl;       // Required from API response
  final String? educationLevel; // Made nullable
  final String createdAt;     // Required from API response
  final String? zoomMeetingId; // Added from API response
  final List<dynamic>? participants; // Added from API response

  Session({
    this.title,
    this.desc,
    required this.hostUrl,
    required this.joinUrl,
    this.educationLevel,
    required this.createdAt,
    this.zoomMeetingId,
    this.participants,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      title: json['title']?.toString(),  // Convert to String if not null
      desc: json['description']?.toString(),
      hostUrl: json['hostUrl'] ?? '',    // Provide default value if null
      joinUrl: json['joinUrl'] ?? '',
      createdAt: json['createdAt'] ?? '',
      educationLevel: json['level']?.toString(), // Changed from 'educationLevel' to 'level'
      zoomMeetingId: json['zoomMeetingId']?.toString(),
      participants: json['participants'] as List<dynamic>?,
    );
  }

  static List<Session> itemsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Session.fromJson(data);
    }).toList();
  }
}