import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class TextMessageWidget extends StatelessWidget {
  final types.TextMessage message;
  final VoidCallback onTap;

  const TextMessageWidget({required this.message, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(message.text),
      onTap: onTap,
    );
  }
}

class ImageMessageWidget extends StatelessWidget {
  final types.ImageMessage message;
  final VoidCallback onTap;

  const ImageMessageWidget({required this.message, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(message.uri),
      onTap: onTap,
    );
  }
}

class FileMessageWidget extends StatelessWidget {
  final types.FileMessage message;
  final VoidCallback onTap;

  const FileMessageWidget({required this.message, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(message.name),
      onTap: onTap,
    );
  }
}
