import 'Video.dart';

class VideoResponse {
  final List<Video> videos;
  final List<String> videoPaidContentIds;

  VideoResponse({
    required this.videos,
    required this.videoPaidContentIds,
  });

  factory VideoResponse.fromJson(Map<String, dynamic> json) {
    return VideoResponse(
      videos: (json['videos'] as List).map((video) => Video.fromjson(video)).toList(),
      videoPaidContentIds: List<String>.from(json['videoPaidContentIds']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "videos": videos.map((video) => video.toJson()).toList(),
      "videoPaidContentIds": videoPaidContentIds,
    };
  }
}
