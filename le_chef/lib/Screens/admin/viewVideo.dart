import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String url;

  const VideoPlayerScreen({required this.url});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  FlickManager? _flickManager;

  @override
  void initState() {
    super.initState();
    try {
      _flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(
          Uri.parse(widget.url),
        ),
      );
      // WakelockPlus.enable();  // Disable wakelock for now
    } catch (e) {
      print("Error initializing video player: $e");
    }
  }

  @override
  void dispose() {
    // WakelockPlus.disable();  // Disable wakelock for now
    _flickManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video Player")),
      body: _flickManager != null
          ? Center(
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: FlickVideoPlayer(flickManager: _flickManager!),
              ),
            )
          : Center(
              child: Text("Error initializing video player."),
            ),
    );
  }
}
