import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:le_chef/Shared/custom_app_bar.dart';
import 'package:le_chef/services/content/note_service.dart';
import '../Models/Notes.dart';
import '../main.dart';
import '../services/auth/login_service.dart';
import 'admin/THome.dart';

class NotesScreen extends StatefulWidget {
  final int level;
  const NotesScreen({super.key, required this.level});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  String? role = sharedPreferences!.getString('role');
  Future<List<Notes>>? _notesFuture;

  @override
  void initState() {
    super.initState();
    _notesFuture = _fetchAndSortNotes();
  }

  Future<List<Notes>> _fetchAndSortNotes() async {
    final notes = role == 'admin'
        ? await NoteService.fetchAllNotes(token!)
        : await NoteService.fetchNotesForUserLevel();

    // Filter notes based on education level
    final filteredNotes = notes.where((note) {
      if (widget.level == 1) {
        return note.educationLevel == 1;
      } else if (widget.level == 2) {
        return note.educationLevel == 2;
      } else if (widget.level == 3) {
        return note.educationLevel == 3;
      }
      return false;
    }).toList();

    // Sort the filtered notes by date
    filteredNotes.sort((a, b) =>
        DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)));
    return filteredNotes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: role == "user"
          ? const CustomAppBar(
              title: 'Notes',
            )
          : null,
      body: FutureBuilder<List<Notes>>(
          future: _notesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No notes available"));
            }

            final notes = snapshot.data!;

            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                final dateText = _getDateText(note.createdAt);

                // Check if a header text should be displayed before this note
                bool showHeaderText = (index == 0 ||
                    _getDateText(notes[index - 1].createdAt) != dateText);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showHeaderText)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          dateText,
                          style: const TextStyle(
                            color: Color(0xFF164863),
                            fontSize: 20,
                            fontFamily: 'IBM Plex Mono',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                    NoteCard(
                      content: note.content,
                      createdAt: note.createdAt,
                    ),
                  ],
                );
              },
            );
          }),
    );
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
}

// Note Card widget
class NoteCard extends StatelessWidget {
  final String content;
  final String createdAt;

  const NoteCard({
    super.key,
    required this.content,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    final displayDate = _formatCreatedAt(createdAt);
    return Container(
      width: double.infinity, // Makes the card take the full width
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: const Color(0xFFF9F9F9),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayDate,
                style: const TextStyle(
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
                style: const TextStyle(
                  color: Color(0xFF164863),
                  fontSize: 14,
                  fontFamily: 'IBM Plex Mono',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCreatedAt(String createdAt) {
    final dateTime =
        DateTime.parse(createdAt).toLocal(); // Convert to local time
    final now = DateTime.now();

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return DateFormat.jm().format(dateTime);
    } else if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day - 1) {
      return " ${DateFormat.jm().format(dateTime)}";
    } else {
      return DateFormat.jm().format(dateTime);
    }
  }
}
