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

  FlutterSoundRecorder? _recorder;
  String? _recordedFilePath;
  bool person = true;
  bool _showFloatingButton = true;

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
    final index = _messages.indexWhere((element) => element.message.id == message.id);
    if (index != -1) {
      final wrappedMessage = _messages[index];
      if (wrappedMessage.message is CustomMessage) {
        final updatedMessage = wrappedMessage.message as CustomMessage;
        if (!wrappedMessage.seen) {
          setState(() {
            _messages[index] = WrappedMessage(
              message: updatedMessage,
              seen: true,
            );
          });
        }
      }

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

  void _handlePreviewDataFetched(types.Message message, types.PreviewData previewData) {
    // Find the index of the message in _messages list
    final index = _messages.indexWhere((element) => element.message.id == message.id);

    if (index != -1 && message is types.TextMessage) {
      final wrappedMessage = _messages[index] as WrappedMessage;

      // Cast the message to TextMessage and update preview data
      final updatedMessage = types.TextMessage(
        id: wrappedMessage.message.id,
        author: wrappedMessage.message.author,
        createdAt: wrappedMessage.message.createdAt,
        text: (wrappedMessage.message as types.TextMessage).text, // Cast to TextMessage to access text
        previewData: previewData, // Update preview data
      );

      setState(() {
        _messages[index] = WrappedMessage(
          message: updatedMessage,
          seen: wrappedMessage.seen,
        );
      });
    }
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);

    // Clear the text input field
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

  void _playAudio(String? uri) async {
    if (uri != null) {
      final player = AudioPlayer();
      try {
        await player.play(UrlSource(uri));
      } catch (e) {
        // Handle error if playback fails
        print("Error playing audio: $e");
      }
    }
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

  Widget _buildCustomMessage(types.Message message, {required int messageWidth}) {
    final messageTime = DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(message.createdAt!));

    // Define the colors based on whether the message is sent or received
    final messageColor = message.author.id == _user.id ? Colors.blue : Colors.grey[300];
    final textColor = message.author.id == _user.id ? Colors.white : Colors.black;

    Widget seenIndicator = const SizedBox.shrink(); // Default to no indicator

    if (message is WrappedMessage) {
      final wrappedMessage = message as WrappedMessage;
      if (wrappedMessage.seen) {
        seenIndicator = Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.check, color: Colors.blue, size: 16.0),
            SizedBox(width: 2.0),
            Icon(Icons.check, color: Colors.blue, size: 16.0),
          ],
        );
      }
    }

    if (message is types.TextMessage) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: messageColor, // Use the same color for text message background
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: message.author.id == _user.id ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(color: textColor), // Use the same color for text
            ),
            const SizedBox(height: 4.0),
            Row(
              mainAxisAlignment: message.author.id == _user.id ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                seenIndicator, // Add the seen indicator here
                const SizedBox(width: 4.0),
                Text(
                  messageTime,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else if (message is types.ImageMessage) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: messageColor, // Use the same color for image message background
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: message.author.id == _user.id ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Image.file(File(message.uri), width: message.width, height: message.height),
            const SizedBox(height: 4.0),
            Row(
              mainAxisAlignment: message.author.id == _user.id ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                seenIndicator, // Add the seen indicator here
                const SizedBox(width: 4.0),
                Text(
                  messageTime,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else if (message is types.FileMessage) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: messageColor, // Use the same color for file message background
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: message.author.id == _user.id ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.attach_file,
                  color: textColor, // Use the same color for file icon
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    message.name,
                    style: TextStyle(
                      color: textColor, // Use the same color for file name
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4.0),
            Row(
              mainAxisAlignment: message.author.id == _user.id ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                seenIndicator, // Add the seen indicator here
                const SizedBox(width: 4.0),
                Text(
                  messageTime,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final groupChatTheme = DefaultChatTheme(
      primaryColor: const Color(0xFF0E7490),
      secondaryColor: const Color(0xFFFBFAFA),
      backgroundColor: Colors.white,
      receivedMessageBodyTextStyle: const TextStyle(color: Color(0xFF083344)),
      sentMessageBodyTextStyle: const TextStyle(color: Colors.white),
      inputBackgroundColor: Colors.white, // Message input background color
      attachmentButtonIcon: Icon(Icons.attach_file), // Attachment button icon
    );

    final personalChatTheme = DefaultChatTheme(
      primaryColor: const Color(0xFF0E7490),
      secondaryColor: const Color(0xFFFBFAFA),
      backgroundColor: Colors.white,
      receivedMessageBodyTextStyle: const TextStyle(color: Color(0xFF083344)),
      sentMessageBodyTextStyle: const TextStyle(color: Colors.white),
      inputBackgroundColor: Colors.white, // Message input background color
      attachmentButtonIcon: Icon(Icons.attach_file), // Attachment button icon
    );

    return SafeArea(
      child: Scaffold(
        appBar: person
            ? CustomAppBar(
          title: "Thaowpsta",
          avatarUrl:
          'https://r2.starryai.com/results/911754633/bccb46bd-67fe-47c7-8e5e-3dd39329d638.webp',
        )
            : CustomAppBar(
          title: "Group",
          avatarUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZeR6Y0pmPtmNaWamoKJ7soTxAERZIMrjHbg&s',
        ),
        body: Chat(
            messages: _messages.map((wm) => wm.message).toList(),
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
                  padding: const EdgeInsets.fromLTRB(16, 16, 85, 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0E7490),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        'Recording...',
                        style: TextStyle(
                            color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                )
                    : Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 85, 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0),
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
                              hintStyle: TextStyle(
                                color: Color(0xFF888888),
                                fontSize: 12,
                                fontFamily: 'IBM Plex Mono',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                            style: const TextStyle(color: Colors.black),
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _handleSendPressed(
                                    types.PartialText(text: value));
                              }
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.attach_file,
                              color: Colors.black),
                          onPressed: _handleAttachmentPressed,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            fileMessageBuilder: (message, {required int messageWidth}) {
              if (message is types.FileMessage && message.mimeType?.startsWith('audio/') == true) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: message.author.id == _user.id ? Colors.blue : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: message.author.id == _user.id ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.audiotrack, color: message.author.id == _user.id ? Colors.white : Colors.black),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              'Voice Message',
                              style: TextStyle(
                                color: message.author.id == _user.id ? Colors.white : Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.play_arrow, color: message.author.id == _user.id ? Colors.white : Colors.black),
                            onPressed: () {
                              _playAudio(message.uri);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        mainAxisAlignment: message.author.id == _user.id ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(message.createdAt!)),
                            style: const TextStyle(color: Colors.white, fontSize: 10.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }

              // For other file messages
              return _buildCustomMessage(message, messageWidth: messageWidth);
            }
        ),
        floatingActionButton: _showFloatingButton
            ? ValueListenableBuilder<bool>(
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
                  MaterialPageRoute(builder: (context) => Home()),
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
                  MaterialPageRoute(builder: (context) => Chats()),
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

class WrappedMessage {
  final types.Message message;
  final bool seen;

  WrappedMessage({required this.message, required this.seen});
}

// class CustomTextMessage extends types.TextMessage {
//   final types.PreviewData? previewData;
//
//   CustomTextMessage({
//     required String id,
//     required types.User author,
//     required int createdAt,
//     required String text,
//     this.previewData,
//   }) : super(id: id, author: author, createdAt: createdAt, text: text);
//
//   @override
//   CustomTextMessage copyWith({
//     String? id,
//     types.User? author,
//     int createdAt,
//     String? text,
//     types.PreviewData? previewData,
//   }) {
//     return CustomTextMessage(
//       id: id ?? this.id,
//       author: author ?? this.author,
//       createdAt: createdAt ?? this.createdAt,
//       text: text ?? this.text,
//       previewData: previewData ?? this.previewData,
//     );
//   }
// }

