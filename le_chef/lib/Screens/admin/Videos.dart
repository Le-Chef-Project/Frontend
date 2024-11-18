import 'package:flutter/material.dart';
import 'package:le_chef/Api/apimethods.dart';
import '../../Models/Video.dart';
import '../../Widgets/SmallCard.dart';
import 'viewVideo.dart'; // Import the Video model

class VideoListScreen extends StatefulWidget {
  final int selectedLevel;
  const VideoListScreen({super.key, required this.selectedLevel});

  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  Future<List<Video>>? videos;
  List<Video> _filteredvideos = [];
  bool isloading = true;

  // Fetch videos and filter them based on the selected level
  void _fetchAndFilterVideos() async {
    List<Video> allVideos = await ApisMethods.fetchAllVideos();

    setState(() {
      isloading = false;
      _filteredvideos = allVideos
          .where((video) => video.educationLevel == widget.selectedLevel)
          .toList();
      print(
          'Filtered videos for unit ${widget.selectedLevel}: ${_filteredvideos.length}');
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchAndFilterVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isloading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator while fetching
          : _filteredvideos.isEmpty
              ? const Center(
                  child: Text(
                      "No videos available")) // Show message if no videos match
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: _filteredvideos.length,
                  itemBuilder: (context, index) {
                    final video = _filteredvideos[index];
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
                      ), isLocked: false,
                    );
                  },
                ),
    );
  }
}
