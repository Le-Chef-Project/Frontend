import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:le_chef/Screens/chats.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../Shared/customBottomNavBar.dart';
import '../Shared/custom_app_bar.dart';
import 'Home.dart';
import 'notification.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<WrappedMessage> _messages = [];
  final AudioPlayer _audioPlayer = AudioPlayer();

  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  );

  final TextEditingController _textController = TextEditingController();
  final ValueNotifier<bool> _isTyping = ValueNotifier(false);
  final ValueNotifier<bool> _isRecording = ValueNotifier(false);
  Map<String, AudioPlayer?> _audioPlayers = {};
  Map<String, bool> _isPlayingMap = {};

  FlutterSoundRecorder? _recorder;
  String? _recordedFilePath;
  bool person = false;
  bool _showFloatingButton = true;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
    _loadMessages();
    _initRecorder();
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _isTyping.dispose();
    _isRecording.dispose();
    _recorder?.closeRecorder();
    super.dispose();
  }

  void _onTextChanged() {
    _isTyping.value = _textController.text.isNotEmpty;
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, WrappedMessage(message: message, seen: false));
    });
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name ?? '',
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index = _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage = (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

      // Handle file opening logic
      if (wrappedMessage.message is types.FileMessage) {
        final fileMessage = wrappedMessage.message as types.FileMessage;

        // Check if the file is an image
        if (fileMessage.mimeType?.startsWith('image/') == true) {
          setState(() {
            _showFloatingButton = false;
          });

          // Open the image file
          await OpenFilex.open(fileMessage.uri);

          // Optionally, reset the button visibility here if you want it to reappear
          // after closing the image viewer.
          setState(() {
            _showFloatingButton = true;
          });
        } else {
          await OpenFilex.open(fileMessage.uri);
        }
      }
    }
  }

  void _handlePreviewDataFetched(types.TextMessage message, types.PreviewData previewData) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    _addMessage(textMessage);
    _textController.clear();
  }

  void _loadMessages() async {
    final response = await rootBundle.loadString('assets/messages.json');
    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .map((message) => WrappedMessage(message: message, seen: false))
        .toList();

    setState(() {
      _messages = messages;
    });
  }

  Future<void> _initRecorder() async {
    _recorder = FlutterSoundRecorder();
    await _recorder!.openRecorder();
    if (await Permission.microphone.request().isGranted) {
      await _recorder!.setSubscriptionDuration(const Duration(milliseconds: 10));
    } else {
      // Handle permission denied
    }
  }

  void _startRecording() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/temp.aac';

    await _recorder!.startRecorder(
      toFile: path,
      codec: Codec.aacADTS,
    );
    _isRecording.value = true;
    _recordedFilePath = path;
  }

  void _stopRecording() async {
    await _recorder!.stopRecorder();
    _isRecording.value = false;

    if (_recordedFilePath != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: 'audio/aac',
        name: 'Voice Message',
        size: File(_recordedFilePath!).lengthSync(),
        uri: _recordedFilePath!,
      );
      _addMessage(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    const groupChatTheme = DefaultChatTheme(
      primaryColor: Color(0xFF0E7490),
      secondaryColor: Color(0xFFFBFAFA),
      backgroundColor: Colors.white,
      receivedMessageBodyTextStyle: const TextStyle(color: Color(0xFF083344)),
      sentMessageBodyTextStyle: const TextStyle(color: Colors.white),
      inputBackgroundColor: Colors.white, // Message input background color
      attachmentButtonIcon: Icon(Icons.attach_file), // Attachment button icon
    );

    const personalChatTheme = DefaultChatTheme(
      primaryColor: Color(0xFF0E7490),
      secondaryColor: Color(0xFFFBFAFA),
      backgroundColor: Colors.white,
      receivedMessageBodyTextStyle: const TextStyle(color: Color(0xFF083344)),
      sentMessageBodyTextStyle: const TextStyle(color: Colors.white),
      inputBackgroundColor: Colors.white, // Message input background color
      attachmentButtonIcon: Icon(Icons.attach_file), // Attachment button icon
    );

    return SafeArea(
      child: Scaffold(
        appBar: person ? CustomAppBar(
          title: "Thaowpsta",
          avatarUrl: 'https://r2.starryai.com/results/911754633/bccb46bd-67fe-47c7-8e5e-3dd39329d638.webp',
        ) : CustomAppBar(
          title: "Group",
          avatarUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZeR6Y0pmPtmNaWamoKJ7soTxAERZIMrjHbg&s',
        ),

        body: Chat(
          messages: _messages,
          onAttachmentPressed: _handleAttachmentPressed,
          onMessageTap: _handleMessageTap,
          onPreviewDataFetched: _handlePreviewDataFetched,
          onSendPressed: _handleSendPressed,
          showUserAvatars: person,
          showUserNames: true,
          user: _user,
          theme: person ? personalChatTheme : groupChatTheme,
          customBottomWidget: ValueListenableBuilder<bool>(
            valueListenable: _isRecording,
            builder: (context, isRecording, child) {
              return isRecording
                  ? Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 85, 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E7490),
                    borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
                  ),
                  child: const Center(
                    child: Text(
                      'Recording...',
                      style: TextStyle(color: Colors.white, fontSize: 16), // Adjust color to ensure contrast
                    ),
                  ),
                ),
              )


                  : Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 85, 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBFAFA),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                          style: const TextStyle(color: Colors.black),
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              _handleSendPressed(types.PartialText(text: value));
                            }
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.attach_file, color: Colors.black),
                        onPressed: _handleAttachmentPressed,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        floatingActionButton: ValueListenableBuilder<bool>(
          valueListenable: _isTyping,
          builder: (context, isTyping, child) {
            return isTyping
                ? FloatingActionButton(
              backgroundColor: const Color(0xFF0E7490),
              onPressed: () {
                final text = _textController.text.trim();
                if (text.isNotEmpty) {
                  _handleSendPressed(types.PartialText(text: text));
                }
              },
              child: const Icon(Icons.send, color: Colors.white),
            )
                : GestureDetector(
              onLongPress: _startRecording,
              onLongPressUp: _stopRecording,
              child: FloatingActionButton(
                backgroundColor: const Color(0xFF0E7490),
                onPressed: () {
                  // Handle other functionalities
                },
                child: const Icon(Icons.mic, color: Colors.white),
              ),
            );
          },
        )
            : null,
        bottomNavigationBar: CustomBottomNavBar(
          onItemTapped: (index) {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Notifications()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Chats()),
                );
                break;
            }
          },
          context: context,
        ),
      ),
    );
  }
}
