import 'package:flutter/material.dart';
import 'package:le_chef/Api/apimethods.dart';
import '../../Models/Video.dart';

import '../../Widgets/SmallCard.dart';
import 'viewVideo.dart'; // Import the Video model

class VideoListScreen extends StatefulWidget {
  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  Future<List<Video>>? videos;

  @override
  void initState() {
    super.initState();
    videos = ApisMethods().fetchAllVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Video>>(
        future: videos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No videos available"));
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final video = snapshot.data![index];
              return Smallcard(
                  Title: video.title,
                  description: video.description,
                  imageurl: 'assets/desk_book_apple.jpeg',
                  ontap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              VideoPlayerScreen(url: video.url),
                        ),
                      ));
            },
          );
        },
      ),
    );
  }
}
