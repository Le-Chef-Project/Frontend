import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class ChatThemes {
  static const groupChat = DefaultChatTheme(
    primaryColor: Color(0xFF0E7490),
    secondaryColor: Color(0xFFFBFAFA),
    backgroundColor: Colors.white,
    receivedMessageBodyTextStyle: TextStyle(color: Color(0xFF083344)),
    sentMessageBodyTextStyle: TextStyle(color: Colors.white),
    inputBackgroundColor: Colors.white,
    attachmentButtonIcon: Icon(Icons.attach_file),
  );

  static const personalChat = DefaultChatTheme(
    primaryColor: Color(0xFF0E7490),
    secondaryColor: Color(0xFFFBFAFA),
    backgroundColor: Colors.white,
    receivedMessageBodyTextStyle: TextStyle(color: Color(0xFF083344)),
    sentMessageBodyTextStyle: TextStyle(color: Colors.white),
    inputBackgroundColor: Colors.white,
    attachmentButtonIcon: Icon(Icons.attach_file),
  );
}