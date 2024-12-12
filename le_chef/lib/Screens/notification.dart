import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:le_chef/Models/notification.dart';
import 'package:le_chef/Screens/Notes.dart';
import 'package:le_chef/Screens/admin/all_students.dart';
import 'package:le_chef/Screens/user/Home.dart';
import 'package:le_chef/Screens/user/seeAllVid.dart';
import 'package:le_chef/Shared/custom_app_bar.dart';
import 'package:le_chef/Shared/meeting/online_session_screen.dart';
import 'package:le_chef/services/notification/notification_service.dart';
import '../Shared/customBottomNavBar.dart';
import '../Shared/exams/exams.dart';
import '../main.dart';
import 'admin/THome.dart';
import 'admin/library.dart';
import 'admin/notesLevels.dart';
import 'admin/payment_request.dart';
import 'chats/chats.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool _isLoadingNotif = true;
  List<NotificationModel> _notifications = [];
  final int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    getNotifications();
  }

  Future<void> getNotifications() async {
    try {
      _notifications = await NotificationService.getNotifications();
    } catch (error) {
      print('Error fetching notifications: $error');
    } finally {
      setState(() {
        _isLoadingNotif = false;
      });
    }
  }

  Map<String, List<NotificationModel>> _groupNotificationsByDate(
      List<NotificationModel> notifications) {
    Map<String, List<NotificationModel>> groupedNotifications = {};

    for (var notification in notifications) {
      final dateText = _getDateText(notification.createdAt);
      if (groupedNotifications[dateText] == null) {
        groupedNotifications[dateText] = [];
      }
      groupedNotifications[dateText]!.add(notification);
    }
    return groupedNotifications;
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
        appBar: const CustomAppBar(title: "Notifications"),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _isLoadingNotif
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _notifications.isEmpty
                    ? const Center(
                        child: Text(
                          'No notifications yet',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView(
                        children: _groupNotificationsByDate(_notifications)
                            .entries
                            .map((entry) {
                          final dateText = entry.key;
                          final notifications = entry.value;

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
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: notifications.length,
                                itemBuilder: (context, index) {
                                  final notification = notifications[index];
                                  return NotificationItem(
                                    type: notification.type,
                                    level: notification.level,
                                    icon:
                                        getNotificationIcon(notification.type),
                                    iconBackgroundColor: getIconBackgroundColor(
                                        notification.type),
                                    iconColor: getIconColor(notification.type),
                                    title: notification.message,
                                    time: _formatTime(notification.createdAt),
                                  );
                                },
                              ),
                            ],
                          );
                        }).toList(),
                      )),
        bottomNavigationBar: CustomBottomNavBar(
          onItemTapped: (index) {
            switch (index) {
              case 0:
                if (role == 'admin') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const THome()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                  );
                }
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Chats()),
                );
                break;
              case 3:
                if (role == 'admin') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PaymentRequest()));
                }
            }
          },
          context: context,
          selectedIndex: _selectedIndex,
          userRole: role!,
        ),
      ),
    );
  }

  /// Helper function to format time
  String _formatTime(String timestamp) {
    try {
      // Parse the timestamp into DateTime
      DateTime dateTime = DateTime.parse(timestamp);

      // Format the time using intl
      return DateFormat('h:mm a').format(dateTime); // Example: 10:05 PM
    } catch (e) {
      return 'Invalid time';
    }
  }

  IconData getNotificationIcon(String type) {
    switch (type) {
      case 'note':
        return Icons.edit;
      case 'video':
        return Icons.play_arrow;
      case 'quiz':
        return Icons.check_circle_outline;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'payment':
        return Icons.attach_money;
      case 'meeting':
        return Icons.meeting_room;
      case 'user':
        return Icons.person;
      default:
        return Icons.notifications;
    }
  }

  Color getIconBackgroundColor(String type) {
    switch (type) {
      case 'note':
        return const Color(0xFFEBF4FF);
      case 'video':
        return const Color(0xFFFFF8F8);
      case 'quiz':
        return const Color(0xFFFAFFF1);
      case 'pdf':
        return const Color(0xFFFFF7E6);
      case 'payment':
        return const Color(0xFFE8F8F5);
      case 'meeting':
        return const Color(0xFFFFF4F4);
      case 'user':
        return const Color(0xFFF4F4FF);
      default:
        return Colors.grey.shade200;
    }
  }

  Color getIconColor(String type) {
    switch (type) {
      case 'note':
        return const Color(0xFF2A324B);
      case 'video':
        return const Color(0xFF427D9D);
      case 'quiz':
        return const Color(0xFF2ED573);
      case 'pdf':
        return const Color(0xFFDB4437);
      case 'payment':
        return const Color(0xFF27AE60);
      case 'meeting':
        return const Color(0xFF8E44AD);
      case 'user':
        return const Color(0xFF2980B9);
      default:
        return Colors.grey;
    }
  }
}

class NotificationItem extends StatelessWidget {
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final String title;
  final String time;
  final String type;
  final int level;

  const NotificationItem({
    super.key,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.title,
    required this.time,
    required this.type,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateToType(context, type, level);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: iconBackgroundColor,
              child: Icon(icon, color: iconColor, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    time,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToType(BuildContext context, String type, int level) {
    switch (type) {
      case 'note':
        role == 'admin'
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotesTabContainerScreen(),
                ),
              )
            : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotesScreen(
                    level: level,
                  ),
                ),
              );
        break;
      case 'video':
        role == 'admin'
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LibraryTabContainerScreen(
                    selectedLevel: level,
                  ),
                ),
              )
            : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllVid(),
                ),
              );
        break;
      case 'pdf':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LibraryTabContainerScreen(
              selectedLevel: level,
            ),
          ),
        );
        break;
      case 'quiz':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Exams(selectedLevel: level),
          ),
        );
        break;
      case 'payment':
        role == 'admin'
            ? Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PaymentRequest()),
              )
            : null;
        break;
      case 'meeting':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OnlineSessionScreen()),
        );
        break;
      case 'user':
        role == 'admin'
            ? Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AllStudents()),
              )
            : null;
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unknown type')),
        );
        break;
    }
  }
}
