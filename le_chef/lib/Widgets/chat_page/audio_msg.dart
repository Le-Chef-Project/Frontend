import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:google_fonts/google_fonts.dart';

class AudioMessageBubble extends StatelessWidget {
  final FileMessage message;
  final User currentUser;
  final Function(String) onPlay;

  const AudioMessageBubble({
    required this.message,
    required this.currentUser,
    required this.onPlay,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      width: 190,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.play_arrow, color: Colors.white),
            onPressed: () => onPlay(message.uri),
          ),
          Expanded(
            child: Text(message.name, style: GoogleFonts.ibmPlexMono(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),),
          ),
        ],
      ),
    );
  }
}