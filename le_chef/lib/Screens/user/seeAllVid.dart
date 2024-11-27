import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:le_chef/Models/Video.dart';
import 'package:le_chef/Screens/chats/chats.dart';
import 'package:le_chef/Shared/customBottomNavBar.dart';
import '../../Api/apimethods.dart';
import '../../Shared/custom_app_bar.dart';
import '../../Widgets/SmallCard.dart';
import '../../main.dart';
import '../admin/payment_request.dart';
import '../admin/viewVideo.dart';
import '../notification.dart';
import 'Home.dart';

class AllVid extends StatefulWidget {
  const AllVid({Key? key}) : super(key: key);

  @override
  State<AllVid> createState() => _AllVidState();
}

class _AllVidState extends State<AllVid> {
  static int? level = sharedPreferences!.getInt('educationLevel');
  Future<List<Video>>? _VideosFuture;

  @override
  void initState() {
    super.initState();
    _VideosFuture = _fetchAndSortVideos();
  }

  Future<List<Video>> _fetchAndSortVideos() async {
    final Videos = await ApisMethods.fetchAllVideos();

    // Filter and sort videos by date
    final filteredVideos = Videos.where((video) {
      return video.educationLevel == level;
    }).toList();

    filteredVideos.sort((a, b) =>
        DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)));

    return filteredVideos;
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

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return "Today";
    } else if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day - 1) {
      return "Yesterday";
    } else {
      return DateFormat.yMMMd().format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(title: "All Videos"),
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

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
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
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 24,
                          crossAxisSpacing: 24,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: videos.length,
                        itemBuilder: (context, index) {
                          final video = videos[index];
                          return Smallcard(
                            id: video.id,
                            Title: video.title,
                            description: video.description,
                            imageurl: 'assets/desk_book_apple.jpeg',
                            ontap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    VideoPlayerScreen(url: video.url),
                              ),
                            ),
                            isLocked: video.isLocked,
                          );
                        },
                      ),
                    ],
                  );
                }).toList(),
              );
            }),
        bottomNavigationBar: CustomBottomNavBar(
          onItemTapped: (index) {
            switch (index) {
              case 0:
                Get.to(() => const Home(),
                    transition: Transition.fade,
                    duration: const Duration(seconds: 1));
                break;
              case 1:
                Get.to(() => const Notifications(),
                    transition: Transition.fade,
                    duration: const Duration(seconds: 1));
                break;
              case 2:
                Get.to(() => const Chats(),
                    transition: Transition.fade,
                    duration: const Duration(seconds: 1));
                break;
              case 3:
                if (role == 'admin') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentRequest()));
                }
            }
          },
          context: context, userRole: role!,
        ),
      ),
    );
  }
}
