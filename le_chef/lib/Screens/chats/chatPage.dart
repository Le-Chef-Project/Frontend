// chat_screen.dart
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:le_chef/Models/Student.dart';
import 'package:le_chef/Models/direct_chat.dart' as direct_chat;
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:uuid/uuid.dart';

import '../../Api/apimethods.dart';
import '../../Shared/customBottomNavBar.dart';
import '../../Widgets/chat_page/appbar.dart';
import '../../Widgets/chat_page/audio_msg.dart';
import '../../Widgets/chat_page/chat_floating_button.dart';
import '../../Widgets/chat_page/doc_msg.dart';
import '../../Widgets/chat_page/msg_input.dart';
import '../../main.dart';
import '../../theme/chat_theme.dart';
import '../notification.dart';
import '../user/Home.dart';
import 'chats.dart';
import 'image_viewer.dart';

class ChatPage extends StatefulWidget {
  final String? groupName;
  final Student? receiver;
  final int? membersNumber;

  const ChatPage({Key? key, this.groupName, this.membersNumber, this.receiver})
      : super(key: key);


  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  List<types.Message> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ValueNotifier<bool> _isTyping = ValueNotifier(false);
  final ValueNotifier<bool> _isRecording = ValueNotifier(false);
  final String? _userId = sharedPreferences!.getString('_id');
  bool _isLoading = true;
  FlutterSoundRecorder? _recorder;
  String? _recordedFilePath;
  bool person = true;
  bool _showFloatingButton = true;
  late DocumentMessageBubble _documentMessageBubble;

  void initState() {
    super.initState();
    _fetchMessages();
    _documentMessageBubble = DocumentMessageBubble(
      currentUser: _user,
      onOpen: (String, str){},
    );
  }

  types.User get _user {
    return types.User(id: _userId ?? '');
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleImageSelection() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        name: image.name ?? '',
        size: await image.length(),
        uri: image.path,
      );

      _addMessage(message);

      try {
        if (person) {
          print(
              'Image path: ${image.path} and Image file path: ${File(image.path)}');
          await ApisMethods.sendDirectMsg(
            id: widget.receiver!.ID,
            participants: [_user.id, widget.receiver!.ID],
            sender: _user.id,
            content: 'Image',
            images: [File(image.path)],
            createdAt: DateTime.fromMillisecondsSinceEpoch(message.createdAt!),
          );
        }
      } catch (e) {
        print('Error sending image message: $e');
      }
    }
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

      try {
        if (person) {
          await ApisMethods.sendDirectMsg(
            id: widget.receiver!.ID,
            participants: [_user.id, widget.receiver!.ID],
            sender: _user.id,
            content: 'Documents',
            documents: [File(result.files.single.path!)],
            createdAt: DateTime.fromMillisecondsSinceEpoch(message.createdAt!),
          );
        }
      } catch (e) {
        print('Error sending file message: $e');
      }
    }
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
              TextButton(
              onPressed: () {
        Navigator.pop(context);
        _handleImageSelection();
        },
          child: const Align(
            alignment: AlignmentDirectional.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_outlined),
                Text('Photo'),
              ],
            ),
          ),
        ),
        TextButton(
        onPressed: () {
      Navigator.pop(context);
      _handleFileSelection();
        },
          child: const Align(
            alignment: AlignmentDirectional.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.file_copy),
                Text('File'),
              ],
            ),
          ),
        ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Align(
                    alignment: AlignmentDirectional.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.close),
                        Text('Cancel'),
                      ],
                    ),
                  ),
                ),
              ],
          ),
        ),
        ),
    );
  }

  String _getMessageType(direct_chat.Message msg) {
    if (msg.images != null && msg.images!.isNotEmpty) return 'image';
    if (msg.documents != null && msg.documents!.isNotEmpty) return 'file';
    if (msg.audio != null) return 'file';
    return 'text';
  }

  Map<String, dynamic> _getMessageContent(direct_chat.Message msg) {
    if (msg.images != null && msg.images!.isNotEmpty) {
      return {
        'name': 'Image',
        'size': 0,
        'uri': msg.images![0],
      };
    }
    if (msg.documents != null && msg.documents!.isNotEmpty) {
      print('Document URI: ${msg.documents![0]}'); // Log the URI
      return {
        'name': 'Document',
        'size': 0,
        'uri': msg.documents![0],
      };
    }
    if (msg.audio != null) {
      return {
        'name': 'Voice Message',
        'size': 0,
        'uri': msg.audio!.data,
        'mimeType': 'audio/aac',
      };
    }
    return {
      'text': msg.content ?? '',
    };
  }

  Future<void> _fetchMessages() async {
    try {
      if (widget.receiver != null) {
        setState(() => _isLoading = true);

        final direct_chat.DirectChat directChat =
        await ApisMethods.getDirectMessages('673b769659474de61ff3c7a8');

        final List<types.Message> convertedMessages =
        directChat.messages.map((msg) {
          // Safely handle createdAt
          final int createdAtMillis = _parseCreatedAt(msg.createdAt);

          return types.Message.fromJson({
              'author': {
                'id': msg.sender != widget.receiver?.ID
                    ? _user.id
                    : widget.receiver?.ID
              },
              'createdAt': createdAtMillis,
              'id': msg.id ?? const Uuid().v4(),
              'type': _getMessageType(msg),
              ...(_getMessageContent(msg)),
            });
        }).toList();

        convertedMessages.sort((b, a) =>
            (b.createdAt ?? 0).compareTo(a.createdAt ?? 0));

        setState(() {
          _messages = convertedMessages;
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      print('Error fetching messages: $e');
      print('Stack trace: $stackTrace'); // Add stack trace for better debugging
      setState(() => _isLoading = false);
    }
  }

  int _parseCreatedAt(dynamic createdAt) {
    if (createdAt == null) {
      return DateTime.now().millisecondsSinceEpoch;
    }

    try {
      if (createdAt is String) {
        return DateTime.parse(createdAt).millisecondsSinceEpoch;
      } else if (createdAt is Map<String, dynamic>) {
        return createdAt['millisecondsSinceEpoch'] ??
            DateTime.now().millisecondsSinceEpoch;
      }
    } catch (e) {
      print('Error parsing createdAt: $e');
    }

    return DateTime.now().millisecondsSinceEpoch;
  }

  void _handlePreviewDataFetched(types.Message message, types.PreviewData previewData) {
    final index =
    _messages.indexWhere((element) => element.id == message.id);

    if (index != -1 && message is types.TextMessage) {
      final wrappedMessage = _messages[index];

      final updatedMessage = types.TextMessage(
        id: wrappedMessage.id,
        author: wrappedMessage.author,
        createdAt: wrappedMessage.createdAt,
        text: (wrappedMessage as types.TextMessage).text,
        previewData: previewData,
      );

      setState(() {
        _messages[index] = updatedMessage;
      });
    }
  }

  Future<void> _startRecording() async {
    if (_recorder == null) {
      _recorder = FlutterSoundRecorder();
      await _recorder!.openRecorder();
    }

    if (!_recorder!.isRecording) {
      try {
        final tempDir = await getTemporaryDirectory();
        _recordedFilePath = '${tempDir.path}/audio_recording.aac';

        await _recorder!.startRecorder(
          toFile: _recordedFilePath,
          codec: Codec.aacADTS,
        );
        setState(() {
          _isRecording.value = true;
        });
      } catch (e) {
        print('Error starting recording: $e');
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
        mimeType: 'audio/aac', // Adjust MIME type if needed
        name: 'Audio',
        size: File(_recordedFilePath!).lengthSync(),
        uri: _recordedFilePath!,
      );

      // Add message to UI
      _addMessage(message);

      // Send to database
      try {
        if (person) {
          // Convert audio to base64 string and send
          final audioData = await _createAudioData(_recordedFilePath!);

          // Check if audio data is non-empty before sending
          if (audioData.isNotEmpty) {
            print("Audio Data Length: ${audioData.length}");

            await ApisMethods.sendDirectMsg(
              id: widget.receiver!.ID,
              participants: [_user.id, widget.receiver!.ID],
              sender: _user.id,
              content: 'Audio',
              audio: audioData, // Send the raw audio data here
              createdAt: DateTime.fromMillisecondsSinceEpoch(message.createdAt!),
            );
          } else {
            print("Error: Audio data is empty.");
          }
        } else {
          // await ApisMethods.sendGrpMsg(message.id, message.id, _user.id, '', null, null, _recordedFilePath, DateTime.fromMillisecondsSinceEpoch(message.createdAt!),);
        }
      } catch (e) {
        print('Error sending audio message: $e');
      }
    }
  }

  Future<List<int>> _createAudioData(String filePath) async {
    final file = File(filePath);
    print("File Path: $filePath");

    if (await file.exists()) {
      print("File exists, reading bytes...");
      return await file.readAsBytes();
    } else {
      print('Audio file not found at: $filePath');
      return [];
    }
  }

  void _playAudio(String? uri) async {
    if (uri != null) {
      final player = AudioPlayer();
      try {
        await player.play(UrlSource(uri));
      } catch (e) {
        print("Error playing audio: $e");
      }
    }
  }

      void _handleMessageTap(BuildContext context, types.Message message) async {
    final index =
    _messages.indexWhere((element) => element.id == message.id);
    if (index != -1) {
      final wrappedMessage = _messages[index];

      // Handle file messages
      if (wrappedMessage is types.FileMessage) {
        final fileMessage = wrappedMessage;

        // Handle images
        if (fileMessage.mimeType?.startsWith('image/') == true) {
          setState(() {
            _showFloatingButton = false;
          });

          // Show image in custom viewer
          await Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) =>
                  ImageViewerDialog(imageUrl: fileMessage.uri),
            ),
          );

          setState(() {
            _showFloatingButton = true;
          });
        }
        // Handle documents
        else {
          await _documentMessageBubble.downloadAndOpenDocument(
              fileMessage.uri, fileMessage.name, context);
        }
      }
    }
  }

  void _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);

    try {
      if (person) {
        print('Sender id: ${_user.id} \nReciever Id: ${widget.receiver!.ID}');
        await ApisMethods.sendDirectMsg(
          id: widget.receiver!.ID,
          participants: [_user.id, widget.receiver!.ID],
          sender: _user.id,
          content: message.text,
          createdAt:
          DateTime.fromMillisecondsSinceEpoch(textMessage.createdAt!),
        );
      } else {
        // await ApisMethods.sendGrpMsg(textMessage.id, textMessage.id, _user.id, message.text, null, null, null, DateTime.fromMillisecondsSinceEpoch(textMessage.createdAt!),);
      }
      print('Updated sending message');
    } catch (e) {
      print('Error sending message: $e');
    }

    _textController.clear();
  }


  @override
  Widget build(BuildContext context) {
    final bool isGroupChat = widget.groupName != null && widget.groupName!.contains(' ');
    final chatTheme = isGroupChat ? ChatThemes.groupChat : ChatThemes.personalChat;

    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _buildChatBody(context, chatTheme),
        floatingActionButton: _showFloatingButton ? _buildFloatingButton() : null,
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

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    if (widget.groupName != null && widget.groupName!.contains(' ')) {
      return GroupChatAppBar(
        groupName: widget.groupName!,
        membersNumber: widget.membersNumber,
        onBackPressed: () => Navigator.pop(context),
      );
    }
    return PersonalChatAppBar(
      username: widget.receiver?.username ?? 'Chat',
      avatarUrl: 'https://r2.starryai.com/results/911754633/bccb46bd-67fe-47c7-8e5e-3dd39329d638.webp',
      onBackPressed: () => Navigator.pop(context),
    );
  }

  Widget _buildChatBody(BuildContext context, ChatTheme theme) {
    return Chat(
      messages: _messages,
      onAttachmentPressed: _handleAttachmentPressed,
      onMessageTap: _handleMessageTap,
      onPreviewDataFetched: _handlePreviewDataFetched,
      onSendPressed: _handleSendPressed,
      showUserAvatars: person,
      showUserNames: true,
      user: _user,
      theme: theme,
      customBottomWidget: MessageInput(
        isRecording: _isRecording,
        textController: _textController,
        onAttachmentPressed: _handleAttachmentPressed,
        onSendPressed: _handleSendPressed,
      ),
      fileMessageBuilder: FileMessageBuilder(
        currentUser: _user,
        onPlayAudio: _playAudio,
        onOpenDocument: (url, fileName) => _documentMessageBubble.downloadAndOpenDocument(url, fileName, context),
      ).build,
    );
  }

  Widget _buildFloatingButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isTyping,
      builder: (context, isTyping, _) {
        return ChatFloatingButton(
          isTyping: isTyping,
          textController: _textController,
          onSendPressed: _handleSendPressed,
          onStartRecording: _startRecording,
          onStopRecording: _stopRecording,
        );
      },
    );
  }
}

class FileMessageBuilder {
  final types.User currentUser;
  final Function(String) onPlayAudio;
  final Function(String, String?) onOpenDocument;

  const FileMessageBuilder({
    required this.currentUser,
    required this.onPlayAudio,
    required this.onOpenDocument,
  });

  Widget build(types.Message message, {required int messageWidth}) {
    if (message is types.FileMessage) {
      final types.FileMessage fileMessage = message;

      if (fileMessage.name == 'Audio') {
        return AudioMessageBubble(
          message: fileMessage,
          currentUser: currentUser,
          onPlay: onPlayAudio,
        );
      }

      if (fileMessage.name == 'Document') {
        return DocumentMessageBubble(
          message: fileMessage,
          currentUser: currentUser,
          onOpen: onOpenDocument,
        );
      }
    }

    return Container(
      width: messageWidth.toDouble(),
      padding: const EdgeInsets.all(12),
      child: Text(
        message.toString(),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}