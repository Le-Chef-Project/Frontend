import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:le_chef/services/content/media_service.dart';
import '../../Models/Video.dart';
import '../../Models/video_response.dart';
import '../../Widgets/SmallCard.dart';
import '../../main.dart';
import 'viewVideo.dart'; // Import the Video model

class VideoListScreen extends StatefulWidget {
  final int selectedLevel;
  const VideoListScreen({super.key, required this.selectedLevel});

  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  Future<List<Video>>? _VideosFuture;
  List<String> _allDateRanges = [];
  VideoResponse? _videoResponse; // Store the API response

  @override
  void initState() {
    super.initState();
    _VideosFuture = _fetchAndSortVideos();
  }

  Future<List<Video>> _fetchAndSortVideos() async {
    try {
      List<Video> videos = []; // Declare videos outside of if-else

      // Fetch videos based on role
      if (role != null && role == "admin") {
        videos = await MediaService.fetchAllVideosAdmin();
      } else {
        _videoResponse = await MediaService.fetchAllVideosUser();
        videos = _videoResponse!.videos;
      }

      // Filter videos based on selected education level
      final filteredVideos = videos.where((video) {
        return video.educationLevel == widget.selectedLevel;
      }).toList();

      // Sort filtered videos by date (newest first)
      filteredVideos.sort((a, b) =>
          DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)));

      // Extract unique date ranges for filtering
      _allDateRanges = filteredVideos
          .map((video) => _getDateText(video.createdAt))
          .toSet()
          .toList();

      return filteredVideos;
    } catch (error) {
      print("Error : $error");
      return [];
    }
  }

  Map<String, List<Video>> _groupVideosByDate(List<Video> videos) {
    Map<String, List<Video>> groupedVideos = {};

    for (var video in videos) {
      final dateText = _getDateText(video.createdAt);
      if (groupedVideos[dateText] == null) {
        groupedVideos[dateText] = [];
      }
      groupedVideos[dateText]!.add(video);
    }
    return groupedVideos;
  }

  String _getDateText(String createdAt) {
    final dateTime = DateTime.parse(createdAt);
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    final days = difference.inDays;

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return "Today";
    } else if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day - 1) {
      return "Yesterday";
    } else if (days < 7) {
      return "Last 7 days";
    } else if (days < 30) {
      return "Last 30 days";
    } else {
      return DateFormat.yMMMd().format(dateTime);
    }
  }

  Future<List<Video>> _applyDateFilter(List<String> selectedRanges) async {
    try {
      List<Video> videos = [];

      // Fetch videos based on role
      if (role == "admin") {
        videos = await MediaService.fetchAllVideosAdmin();
      } else {
        _videoResponse = await MediaService.fetchAllVideosUser();
        videos = _videoResponse! // Store the API response
            .videos;
      }

      // Apply filters: selected education level and date range
      final filteredVideos = videos.where((video) {
        final videoDateText = _getDateText(video.createdAt);

        return video.educationLevel == widget.selectedLevel &&
            selectedRanges.contains(videoDateText);
      }).toList();

      // Sort filtered videos by date (newest first)
      filteredVideos.sort((a, b) =>
          DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)));

      return filteredVideos;
    } catch (error) {
      print("Error applying date filter: $error");
      return [];
    }
  }

  void _showFilterModal(BuildContext context, List<String> allDates) {
    Set<String> selectedDates = {};

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Filters",
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF164863),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: allDates.length,
                      itemBuilder: (context, index) {
                        final dateText = allDates[index];
                        return CheckboxListTile(
                          title: Text(dateText),
                          value: selectedDates.contains(dateText),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selectedDates.add(dateText);
                              } else {
                                selectedDates.remove(dateText);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, selectedDates.toList());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF427D9D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 15),
                        child: Text(
                          "Show Results",
                          style: GoogleFonts.ibmPlexMono(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _VideosFuture = _fetchAndSortVideos();
                        });

                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 15),
                        child: Text(
                          "Reset",
                          style: GoogleFonts.ibmPlexMono(
                            color: const Color(0xFF427D9D),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((selectedRanges) {
      if (selectedRanges != null && selectedRanges.isNotEmpty) {
        // Filter videos based on selected ranges
        setState(() {
          _VideosFuture = _applyDateFilter(selectedRanges);
        });
      } else {
        setState(() {
          _VideosFuture = _fetchAndSortVideos();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Video>>(
          future: _VideosFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No videos available"));
            }

            final groupedVideos = _groupVideosByDate(snapshot.data!);

            return ListView(
              children: groupedVideos.entries.map((entry) {
                final dateText = entry.key;
                final videos = entry.value;
                final isFirst = entry.key == groupedVideos.keys.first;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            dateText,
                            style: const TextStyle(
                              color: Color(0xFF164863),
                              fontSize: 20,
                              fontFamily: 'IBM Plex Mono',
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (isFirst)
                          TextButton(
                            onPressed: () {
                              _showFilterModal(context, _allDateRanges);
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFFFBFAFA),
                              padding: const EdgeInsets.all(16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Filter by date range',
                                  style: GoogleFonts.ibmPlexMono(
                                    color: const Color(0xFF888888),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_down_rounded,
                                    color: Color(0xFF888888))
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: videos.length,
                      itemBuilder: (context, index) {
                        final video = videos[index];
                        return Smallcard(
                          amountToPay:video.amountToPay ,
                          id: video.id,
                          type: 'Video',
                          Title: video.title,
                          description: video.description,
                          imageurl: video.thumbnail,
                          ontap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VideoPlayerScreen(url: video.url),
                            ),
                          ),
                          isLocked: role == "admin"
                              ? false
                              : !(_videoResponse!.videoPaidContentIds
                                      .contains(video.id) ||
                                  !video.isLocked),
                        );
                      },
                    ),
                  ],
                );
              }).toList(),
            );
          }),
    );
  }
}
