import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class MessageInput extends StatefulWidget {
  final ValueNotifier<bool> isRecording;
  final TextEditingController textController;
  final Function() onAttachmentPressed;
  final Function(types.PartialText) onSendPressed;

  const MessageInput({
    Key? key,
    required this.isRecording,
    required this.textController,
    required this.onAttachmentPressed,
    required this.onSendPressed,
  }) : super(key: key);

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.isRecording,
      builder: (context, isRecording, child) {
        return isRecording
            ? Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 85, 16),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF0E7490),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                'Recording...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        )
            : Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 85, 16),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 8.0,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFBFAFA),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.textController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: InputBorder.none,
                      hintStyle: GoogleFonts.ibmPlexMono(
                        color: const Color(0xFF888888),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        widget.onSendPressed(types.PartialText(text: value));
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.attach_file,
                    color: Colors.black,
                  ),
                  onPressed: widget.onAttachmentPressed,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}