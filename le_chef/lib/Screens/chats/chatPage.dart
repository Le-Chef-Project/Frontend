// chat_screen.dart
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:le_chef/Models/direct_chat.dart' as direct_chat;
import 'package:le_chef/Models/group.dart';
import 'package:le_chef/Models/group_chat.dart';
import 'package:le_chef/services/messaging/direct_message.dart';
import 'package:le_chef/services/messaging/grp_message_service.dart';
import 'package:mime/mime.dart';
import 'package:uuid/uuid.dart';

import '../../Models/Admin.dart';
import '../../Widgets/chat_page/appbar.dart';
import '../../Widgets/chat_page/chat_floating_button.dart';
import '../../Widgets/chat_page/doc_msg.dart';
import '../../Widgets/chat_page/msg_input.dart';
import '../../main.dart';
import '../../services/auth/admin_service.dart';
import '../../services/student/student_service.dart';
import '../../theme/chat_theme.dart';
import 'image_viewer.dart';

class ChatPage extends StatefulWidget {
  final Group? group;
  final String? receiverId;
  final String? receiverName;
  final String? chatRoom;
  final bool person;
  final String? imgUrl;

  const ChatPage(
      {Key? key,
      this.group,
      this.receiverId,
      required this.person,
      this.receiverName,
      this.chatRoom,
      required this.imgUrl})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ValueNotifier<bool> _isTyping = ValueNotifier(false);

  // final ValueNotifier<bool> _isRecording = ValueNotifier(false);
  final String? _userId = sharedPreferences!.getString('_id');
  bool _isLoading = true;

  // FlutterSoundRecorder? _recorder;
  // String? _recordedFilePath;
  bool _showFloatingButton = true;
  late DocumentMessageBubble _documentMessageBubble;
  Admin? admin;
  bool isLoadingAdmin = true;

  @override
  void initState() {
    super.initState();
    getAdmin();
    _fetchMessages();
    _documentMessageBubble = DocumentMessageBubble(
      theme: widget.person ? ChatThemes.personalChat : ChatThemes.groupChat,
      currentUser: _user,
      onOpen: (String, str) {},
    );
  }

  types.User get _user {
    return types.User(id: _userId ?? '');
  }

  Future<void> getAdmin() async {
    try {
      if (role == 'admin') {
        admin = await AdminService.getAdmin(token!);
      } else {
        admin = await StudentService.getAdminDetails(token!);
      }
      if (admin != null) {
        print('Got Admin Successfully: ${admin!.username}');
      } else {
        print('Admin is null');
      }
      setState(() {
        isLoadingAdmin = false;
      });
    } catch (e) {
      print('Error fetching admin: $e');
      setState(() {
        isLoadingAdmin = false;
      });
    }
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
        if (widget.person) {
          print(
              'Image path: ${image.path} and Image file path: ${File(image.path)}');
          await DirectMsgService.sendDirectMsg(
            id: widget.receiverId!,
            participants: [_user.id, widget.receiverId!],
            sender: _user.id,
            content: 'Image',
            images: [File(image.path)],
            createdAt: DateTime.fromMillisecondsSinceEpoch(message.createdAt!),
          );
        } else {
          await GrpMsgService.sendgrpMsg(
            group: widget.group!.id,
            sender: _user.id,
            content: 'Image',
            images: [File(image.path)],
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
        if (widget.person) {
          await DirectMsgService.sendDirectMsg(
            id: widget.receiverId!,
            participants: [_user.id, widget.receiverId!],
            sender: _user.id,
            content: 'Documents',
            documents: [File(result.files.single.path!)],
            createdAt: DateTime.fromMillisecondsSinceEpoch(message.createdAt!),
          );
        } else {
          await GrpMsgService.sendgrpMsg(
            group: widget.group!.id,
            sender: _user.id,
            content: 'Documents',
            documents: [File(result.files.single.path!)],
          );
        }
      } catch (e) {
        print('Error sending file message: $e');
      }
      _textController.clear();
    }
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SizedBox(
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
    );
  }

  String _getMessageType(dynamic msg) {
    // For direct chat messages
    if (msg is direct_chat.Message) {
      if (msg.images != null && msg.images!.isNotEmpty) return 'image';
      if (msg.documents != null && msg.documents!.isNotEmpty) return 'file';
      if (msg.audio != null) return 'file';
      return 'text';
    }

    // For group chat messages
    if (msg is GroupChatMessage) {
      if (msg.images != null && msg.images!.isNotEmpty) return 'image';
      if (msg.documents != null && msg.documents!.isNotEmpty) return 'file';
      if (msg.audio != null && msg.audio!.isNotEmpty) return 'file';
      return 'text';
    }

    // Default case
    return 'text';
  }

  Map<String, dynamic> _getMessageContent(dynamic msg) {
    // For direct chat messages
    if (msg is direct_chat.Message) {
      if (msg.images != null && msg.images!.isNotEmpty) {
        return {
          'name': 'Image',
          'size': 0,
          'uri': msg.images![0],
        };
      }
      if (msg.documents != null && msg.documents!.isNotEmpty) {
        // Extract filename from the URI
        String documentUri = msg.documents![0];
        String fileName = _extractFileName(documentUri);

        return {
          'name': fileName,
          'size': 0,
          'uri': documentUri,
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

    // For group chat messages (similar modification)
    if (msg is GroupChatMessage) {
      if (msg.images != null && msg.images!.isNotEmpty) {
        return {
          'name': 'Image',
          'size': 0,
          'uri': msg.images![0],
        };
      }
      if (msg.documents != null && msg.documents!.isNotEmpty) {
        // Extract filename from the URI
        String documentUri = msg.documents![0];
        String fileName = _extractFileName(documentUri);

        return {
          'name': fileName,
          'size': 0,
          'uri': documentUri,
        };
      }
      if (msg.audio != null && msg.audio!.isNotEmpty) {
        return {
          'name': 'Voice Message',
          'size': 0,
          'uri': msg.audio![0],
          'mimeType': 'audio/aac',
        };
      }
      return {
        'text': msg.content,
      };
    }

    // Fallback for unknown message type
    return {
      'text': '',
    };
  }

// Add this method to the _ChatPageState class
  String _extractFileName(String uri) {
    try {
      // Try to parse the URI and get the last segment
      Uri parsedUri = Uri.parse(uri);
      String? lastSegment = parsedUri.pathSegments.lastOrNull;

      if (lastSegment != null && lastSegment.isNotEmpty) {
        return lastSegment;
      }

      // If parsing fails or no segment found, extract from the end of the string
      int lastSlashIndex = uri.lastIndexOf('/');
      if (lastSlashIndex != -1 && lastSlashIndex < uri.length - 1) {
        return uri.substring(lastSlashIndex + 1);
      }
    } catch (e) {
      print('Error extracting filename: $e');
    }

    // Fallback to a generic name if all else fails
    return 'Document';
  }

  Future<void> _fetchMessages() async {
    try {
      List<types.Message> convertedMessages;

      if (widget.person && widget.receiverId != null) {
        setState(() => _isLoading = true);

        final direct_chat.DirectChat directChat =
            await DirectMsgService.getDirectMessages(widget.chatRoom!);

        convertedMessages = directChat.messages.map((msg) {
          // Safely handle createdAt
          final int createdAtMillis = _parseCreatedAt(msg.createdAt);

          return types.Message.fromJson({
            'author': {
              'id':
                  msg.sender != widget.receiverId ? _user.id : widget.receiverId
            },
            'createdAt': createdAtMillis,
            'id': msg.id ?? const Uuid().v4(),
            'imageUrl': widget.imgUrl,
            'type': _getMessageType(msg),
            ...(_getMessageContent(msg)),
          });
        }).toList();
      } else {
        print('Group id: ${widget.group!.id}');
        final GroupChat groupChat =
            await GrpMsgService.getGrpMessages(widget.group!.id);

        convertedMessages = groupChat.messages.map((msg) {
          final int createdAtMillis = _parseCreatedAt(msg.createdAt);

          // Extract sender information from the API response
          final sender = msg.sender;

          return types.Message.fromJson({
            'author': {
              'id': sender?['_id'] ?? '',
              'firstName': admin?.firstName == sender?['firstName']
                  ? 'Hany'
                  : sender?['firstName'] ?? '',
              'lastName': admin?.lastName == sender?['lastName']
                  ? 'Azmy'
                  : sender?['lastName'] ?? '',
              'username': sender?['username'] ?? '',
              'imageUrl': sender?['image']?['url'] ?? '',
            },
            'createdAt': createdAtMillis,
            'id': msg.id ?? const Uuid().v4(),
            'type': _getMessageType(msg),
            ...(_getMessageContent(msg)),
          });
        }).toList();
      }

      convertedMessages
          .sort((b, a) => (b.createdAt ?? 0).compareTo(a.createdAt ?? 0));

      setState(() {
        _messages = convertedMessages;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      print('Error fetching messages: $e');
      print('Stack trace: $stackTrace');
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

  void _handlePreviewDataFetched(
      types.Message message, types.PreviewData previewData) {
    final index = _messages.indexWhere((element) => element.id == message.id);

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

  // Future<void> _startRecording() async {
  //   if (_recorder == null) {
  //     _recorder = FlutterSoundRecorder();
  //     await _recorder!.openRecorder();
  //   }
  //
  //   if (!_recorder!.isRecording) {
  //     try {
  //       final tempDir = await getTemporaryDirectory();
  //       _recordedFilePath = '${tempDir.path}/audio_recording.aac';
  //
  //       await _recorder!.startRecorder(
  //         toFile: _recordedFilePath,
  //         codec: Codec.aacADTS,
  //       );
  //       setState(() {
  //         _isRecording.value = true;
  //       });
  //     } catch (e) {
  //       print('Error starting recording: $e');
  //     }
  //   }
  // }
  //
  // void _stopRecording() async {
  //   await _recorder!.stopRecorder();
  //   _isRecording.value = false;
  //
  //   if (_recordedFilePath != null) {
  //     final message = types.FileMessage(
  //       author: _user,
  //       createdAt: DateTime.now().millisecondsSinceEpoch,
  //       id: const Uuid().v4(),
  //       mimeType: 'audio/aac', // Adjust MIME type if needed
  //       name: 'Audio',
  //       size: File(_recordedFilePath!).lengthSync(),
  //       uri: _recordedFilePath!,
  //     );
  //
  //     // Add message to UI
  //     _addMessage(message);
  //
  //     // Send to database
  //     try {
  //       final audioData = await _createAudioData(_recordedFilePath!);
  //
  //       if (widget.person) {
  //         // Convert audio to base64 string and send
  //
  //         // Check if audio data is non-empty before sending
  //         if (audioData.isNotEmpty) {
  //           print("Audio Data Length: ${audioData.length}");
  //
  //           await DirectMsgService.sendDirectMsg(
  //             id: widget.receiverId!,
  //             participants: [_user.id, widget.receiverId!],
  //             sender: _user.id,
  //             content: 'Audio',
  //             audio: audioData, // Send the raw audio data here
  //             createdAt:
  //                 DateTime.fromMillisecondsSinceEpoch(message.createdAt!),
  //           );
  //         } else {
  //           print("Error: Audio data is empty.");
  //         }
  //       } else {
  //         await GrpMsgService.sendgrpMsg(
  //             group: widget.group!.id,
  //             sender: _user.id,
  //             content: 'Audio',
  //             audio: audioData);
  //       }
  //     } catch (e) {
  //       print('Error sending audio message: $e');
  //     }
  //   }
  // }
  //
  // Future<String> _createAudioData(String filePath) async {
  //   final file = File(filePath);
  //   if (await file.exists()) {
  //     final bytes = await file.readAsBytes();
  //     return base64Encode(bytes); // Convert bytes to Base64 string
  //   }
  //   return '';
  // }
  //
  // void _playAudio(String? uri) async {
  //   if (uri != null) {
  //     final player = AudioPlayer();
  //     try {
  //       await player.play(UrlSource(uri));
  //     } catch (e) {
  //       print("Error playing audio: $e");
  //     }
  //   }
  // }

  void _handleMessageTap(BuildContext context, types.Message message) async {
    print('Message tapped: ${message.runtimeType}'); // Debug message
    final index = _messages.indexWhere((element) => element.id == message.id);
    if (index != -1) {
      final wrappedMessage = _messages[index];

      // Handle image messages
      if (wrappedMessage is types.ImageMessage) {
        final imageMessage = wrappedMessage;
        print(
            'Image message detected. URI: ${imageMessage.uri}'); // Debug message

        // Show image in custom viewer
        await Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => ImageViewerDialog(
                imageUrl: imageMessage.uri,
                person: widget.person,
                group: widget.group,
                receiverId: widget.receiverId,
                receiverName: widget.receiverName,
                chatRoom: widget.chatRoom,
            imgUrl: widget.imgUrl,),
          ),
        );

        return;
      }
      // Handle file messages (if needed)
      else if (wrappedMessage is types.FileMessage) {
        final fileMessage = wrappedMessage;
        print(
            'File message detected. MimeType: ${fileMessage.mimeType}'); // Debug message

        // Handle documents
        if (fileMessage.mimeType?.startsWith('image/') == true) {
          // Show image in custom viewer
          await Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => ImageViewerDialog(
                imageUrl: fileMessage.uri,
                person: widget.person,
                group: widget.group,
                receiverId: widget.receiverId,
                receiverName: widget.receiverName,
                chatRoom: widget.chatRoom,
                imgUrl: widget.imgUrl,),
            ),
          );
        }
        // Handle other file types
        else {
          print('Document message detected'); // Debug message
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
      if (widget.person) {
        print('Sender id: ${_user.id} \nReciever Id: ${widget.receiverId!}');
        await DirectMsgService.sendDirectMsg(
          id: widget.receiverId!,
          participants: [_user.id, widget.receiverId!],
          sender: _user.id,
          content: message.text,
          createdAt:
              DateTime.fromMillisecondsSinceEpoch(textMessage.createdAt!),
        );
      } else {
        await GrpMsgService.sendgrpMsg(
            group: widget.group!.id, sender: _user.id, content: message.text);
      }
      print('Updated sending message');
    } catch (e) {
      print('Error sending message: $e');
    }

    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final chatTheme =
        widget.person ? ChatThemes.personalChat : ChatThemes.groupChat;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: _buildChatBody(context, chatTheme),
      floatingActionButton: _showFloatingButton ? _buildFloatingButton() : null,
    );
  }

  void _handleBackPress() {
    Navigator.pop(context, true); // Pass true to indicate changes were made
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    if (widget.person) {
      return PersonalChatAppBar(
        username: widget.receiverName ?? 'Chat',
        avatarUrl: widget.imgUrl ??
            'https://t4.ftcdn.net/jpg/02/15/84/43/360_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg',
        onBackPressed: () => _handleBackPress(),
      );
    }
    return GroupChatAppBar(
      groupName: widget.group!.title,
      membersNumber: widget.group!.members.length,
      onBackPressed: () => _handleBackPress(),
      grpId: widget.group!.id,
    );
  }

  Widget _buildChatBody(BuildContext context, ChatTheme theme) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      children: [
        Expanded(
          child: _messages.isEmpty
              ? const Center(
                  child: Text('No messages here yet'),
                )
              : Chat(
                  key: ValueKey(_messages.length),
                  messages: _messages,
                  onAttachmentPressed: _handleAttachmentPressed,
                  onMessageTap: _handleMessageTap,
                  onPreviewDataFetched: _handlePreviewDataFetched,
                  onSendPressed: _handleSendPressed,
                  showUserAvatars: true,
                  showUserNames: true,
                  user: _user,
                  theme: theme,
                  avatarBuilder: (types.User user) {
                    String? userImage =
                        widget.person ? widget.imgUrl : user.imageUrl;

                    return CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[200],
                      child: userImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                userImage,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.person,
                                      size: 20, color: Colors.grey[400]);
                                },
                              ),
                            )
                          : Icon(Icons.person,
                              size: 20, color: Colors.grey[400]),
                    );
                  },
                  customBottomWidget: _messages.isNotEmpty
                      ? MessageInput(
                          textController: _textController,
                          onAttachmentPressed: _handleAttachmentPressed,
                          onSendPressed: _handleSendPressed,
                        )
                      : null,
                  // Hide the customBottomWidget when there are no messages
                  fileMessageBuilder: FileMessageBuilder(
                    person: widget.person,
                    currentUser: _user,
                    onOpenDocument: (url, fileName) => _documentMessageBubble
                        .downloadAndOpenDocument(url, fileName!, context),
                  ).build,
                ),
        ),
        // Show the MessageInput only when there are no messages
        if (_messages.isEmpty)
          MessageInput(
            textController: _textController,
            onAttachmentPressed: _handleAttachmentPressed,
            onSendPressed: _handleSendPressed,
          ),
      ],
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
          // onStartRecording: _startRecording,
          // onStopRecording: _stopRecording,
        );
      },
    );
  }
}

class FileMessageBuilder {
  final types.User currentUser;

  // final Function(String) onPlayAudio;
  final Function(String, String?) onOpenDocument;
  final bool person;

  const FileMessageBuilder({
    required this.currentUser,
    // required this.onPlayAudio,
    required this.onOpenDocument,
    required this.person,
  });

  Widget build(types.Message message, {required int messageWidth}) {
    if (message is types.FileMessage) {
      final types.FileMessage fileMessage = message;

      // Check for audio messages first
      // if (fileMessage.name == 'Audio') {
      //   return AudioMessageBubble(
      //     message: fileMessage,
      //     currentUser: currentUser,
      //     // onPlay: onPlayAudio,
      //   );
      // }

      // Handle document messages more robustly
      return DocumentMessageBubble(
        message: fileMessage,
        currentUser: currentUser,
        onOpen: onOpenDocument,
        theme: person ? ChatThemes.personalChat : ChatThemes.groupChat,
      );
    }

    // Fallback for non-file messages
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
