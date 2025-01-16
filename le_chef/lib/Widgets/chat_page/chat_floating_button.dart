import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatFloatingButton extends StatefulWidget {
  final TextEditingController textController;
  final Function(types.PartialText) onSendPressed;
  // final VoidCallback onStartRecording;
  // final VoidCallback onStopRecording;

  const ChatFloatingButton({
    Key? key,
    required this.textController,
    required this.onSendPressed,
    // required this.onStartRecording,
    // required this.onStopRecording,
    required bool isTyping,
  }) : super(key: key);

  @override
  State<ChatFloatingButton> createState() => _ChatFloatingButtonState();
}

class _ChatFloatingButtonState extends State<ChatFloatingButton> {
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    widget.textController.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    widget.textController.removeListener(_handleTextChange);
    super.dispose();
  }

  void _handleTextChange() {
    final isCurrentlyTyping = widget.textController.text.trim().isNotEmpty;
    if (isCurrentlyTyping != _isTyping) {
      setState(() {
        _isTyping = isCurrentlyTyping;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  FloatingActionButton(
      backgroundColor: const Color(0xFF0E7490),
      onPressed: () {
        final text = widget.textController.text.trim();
        if (text.isNotEmpty) {
          widget.onSendPressed(types.PartialText(text: text));
        }
      },
      child: const Icon(Icons.send, color: Colors.white),
    );
    //     : GestureDetector(
    //   onLongPress: widget.onStartRecording,
    //   onLongPressUp: widget.onStopRecording,
    //   child: FloatingActionButton(
    //     backgroundColor: const Color(0xFF0E7490),
    //     onPressed: () {
    //       // Handle other functionalities
    //     },
    //     child: const Icon(Icons.mic, color: Colors.white),
    //   ),
    // );
  }
}