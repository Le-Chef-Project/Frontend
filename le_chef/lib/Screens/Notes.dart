import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Notes extends StatelessWidget {
  final List<Map<String, String>> todayMessages = [
    {
      "time": "Just now",
      "message": "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    },
    {
      "time": "1 hour ago",
      "message": "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    },
    {
      "time": "2 hours ago",
      "message": "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    },
  ];

  final List<Map<String, String>> yesterdayMessages = [
    {
      "time": "20:24 pm",
      "message": "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    },
  ];

  // New list for notes with createdAt
  final List<Map<String, String>> notes = [
    {
      "_id": "66b48f544bdce22358cd0bc8",
      "title": "Sample Note",
      "content": "This is the content of the sample note.",
      "createdAt": "2024-10-25T09:26:44.931Z",
    },
    {
      "_id": "66b48f544bdce22358cd0bc9",
      "title": "Another Note",
      "content": "This note was created yesterday.",
      "createdAt": "2024-10-24T09:26:44.931Z",
    },
    {
      "_id": "66b48f544bdce22358cd0bca",
      "title": "Old Note",
      "content": "This is an older note.",
      "createdAt": "2024-09-15T11:59:47.998Z",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            "Today",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "Yesterday",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "Notes",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ...notes
              .map((note) => NoteCard(
                  title: note["title"]!,
                  content: note["content"]!,
                  createdAt: note["createdAt"]!))
              .toList(),
        ],
      ),
    );
  }
}

// New Note Card widget
class NoteCard extends StatelessWidget {
  final String title;
  final String content;
  final String createdAt;

  const NoteCard(
      {required this.title, required this.content, required this.createdAt});

  @override
  Widget build(BuildContext context) {
    final displayDate = _formatCreatedAt(createdAt);
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              displayDate,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // Method to format createdAt into a user-friendly string
  String _formatCreatedAt(String createdAt) {
    final dateTime = DateTime.parse(createdAt);
    final now = DateTime.now();

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return "Today at ${DateFormat.jm().format(dateTime)}"; // e.g., Today at 9:26 AM
    } else if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day - 1) {
      return "Yesterday at ${DateFormat.jm().format(dateTime)}"; // e.g., Yesterday at 9:26 AM
    } else if (dateTime.isAfter(now.subtract(Duration(days: 7)))) {
      final daysAgo = now.difference(dateTime).inDays;
      return "$daysAgo day${daysAgo > 1 ? 's' : ''} ago at ${DateFormat.jm().format(dateTime)}"; // e.g., 2 days ago at 9:26 AM
    } else {
      return DateFormat.yMMMd()
          .add_jm()
          .format(dateTime); // e.g., Oct 15, 2024 at 9:26 AM
    }
  }
}
