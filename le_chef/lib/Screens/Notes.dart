import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Api/apimethods.dart';
import '../Models/Notes.dart';
import '../main.dart';

class NotesScreen extends StatefulWidget {
  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  String? role = sharedPreferences.getString('role');

  Future<List<Notes>>? _notesFuture;
  @override
  void initState() {
    super.initState();
    _notesFuture = ApisMethods.fetchAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: role == "user"
          ? AppBar(
              title: Text('Notes'),
            )
          : null, // Return null when role is not "user"
      body: FutureBuilder<List<Notes>>(
          future: _notesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No notes available"));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final note = snapshot.data![index];
                return NoteCard(
                  content: note.content,
                  title: note.title,
                  createdAt: note.createdAt,
                );
              },
            );
          }),
    );
  }
}

// Note Card widget
class NoteCard extends StatelessWidget {
  final String title;
  final String content;
  final String createdAt;

  const NoteCard({
    required this.title,
    required this.content,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    final displayDate = _formatCreatedAt(createdAt);
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Color(0xFFF9F9F9),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              displayDate,
              style: TextStyle(
                color: Color(0xFF888888),
                fontSize: 12,
                fontFamily: 'IBM Plex Mono',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(
                color: Color(0xFF164863),
                fontSize: 14,
                fontFamily: 'IBM Plex Mono',
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
            SizedBox(height: 8),
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
      return "Today at ${DateFormat.jm().format(dateTime)}";
    } else if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day - 1) {
      return "Yesterday at ${DateFormat.jm().format(dateTime)}";
    } else if (dateTime.isAfter(now.subtract(Duration(days: 7)))) {
      final daysAgo = now.difference(dateTime).inDays;
      return "$daysAgo day${daysAgo > 1 ? 's' : ''} ago at ${DateFormat.jm().format(dateTime)}";
    } else {
      return DateFormat.yMMMd().add_jm().format(dateTime);
    }
  }
}
