import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:le_chef/Api/apimethods.dart';
import 'package:le_chef/Models/Student.dart';
import 'package:le_chef/Screens/chats/chats.dart';
import 'package:le_chef/main.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import '../../Models/direct_chat.dart' as direct_chat;
import '../../Shared/customBottomNavBar.dart';
import '../../Shared/custom_app_bar.dart';
import '../user/Home.dart';
import '../notification.dart';

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

  List<WrappedMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ValueNotifier<bool> _isTyping = ValueNotifier(false);
  final ValueNotifier<bool> _isRecording = ValueNotifier(false);
  final String? _userId = sharedPreferences!.getString('_id');
  bool _isLoading = true;
  FlutterSoundRecorder? _recorder;
  String? _recordedFilePath;
  bool person = true;
  bool _showFloatingButton = true;

  types.User get _user {
    return types.User(id: _userId ?? '');
  }


  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
    _initRecorder();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    try {
      if (widget.receiver != null) {
        setState(() => _isLoading = true);

        final direct_chat.DirectChat directChat = await ApisMethods.getDirectMessages('673b769659474de61ff3c7a8');

        final List<WrappedMessage> convertedMessages = directChat.messages.map((msg) {
          // Safely handle createdAt
          final int createdAtMillis = _parseCreatedAt(msg.createdAt);

          return WrappedMessage(
            message: types.Message.fromJson({
              'author': {
                'id': msg.sender != widget.receiver?.ID ? _user.id : widget.receiver?.ID
              },
              'createdAt': createdAtMillis,
              'id': msg.id ?? const Uuid().v4(),
              'type': _getMessageType(msg),
              ...(_getMessageContent(msg)),
            }),
          );
        }).toList();

        convertedMessages.sort((b, a) =>
            (b.message.createdAt ?? 0).compareTo(a.message.createdAt ?? 0));

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

// Helper method to safely parse createdAt
  int _parseCreatedAt(dynamic createdAt) {
    if (createdAt == null) {
      return DateTime.now().millisecondsSinceEpoch;
    }

    try {
      if (createdAt is String) {
        return DateTime.parse(createdAt).millisecondsSinceEpoch;
      } else if (createdAt is Map<String, dynamic>) {
        return createdAt['millisecondsSinceEpoch'] ?? DateTime.now().millisecondsSinceEpoch;
      }
    } catch (e) {
      print('Error parsing createdAt: $e');
    }

    return DateTime.now().millisecondsSinceEpoch;
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

  void _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);

    try {
      if(person) {
        print('Sender id: ${_user.id} \nReciever Id: ${widget.receiver!.ID}');
        await ApisMethods.sendDirectMsg(
        id: widget.receiver!.ID,
          participants: [_user.id, widget.receiver!.ID],
          sender: _user.id,
          content: message.text,
          createdAt: DateTime.fromMillisecondsSinceEpoch(textMessage.createdAt!),
      );
      }else{
        // await ApisMethods.sendGrpMsg(textMessage.id, textMessage.id, _user.id, message.text, null, null, null, DateTime.fromMillisecondsSinceEpoch(textMessage.createdAt!),);
      }
      print('Updated sending message');
    } catch (e) {
      print('Error sending message: $e');
    }

    _textController.clear();
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
            print('Image path: ${image.path} and Image file path: ${File(image.path)}');
            await ApisMethods.sendDirectMsg(
              id: widget.receiver!.ID,
              participants: [_user.id, widget.receiver!.ID],
              sender: _user.id,
              content: 'Image',
              images: [File(image.path)],
              createdAt: DateTime.fromMillisecondsSinceEpoch(
                  message.createdAt!),
            );
          }
        }catch(e){
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
        if(person) {
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

  Future<direct_chat.AudioData> _createAudioData(String filePath) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();
    final base64Data = base64Encode(bytes);

    return direct_chat.AudioData(
      data: base64Data,
      contentType: 'audio/aac',
    );
  }

  Future<void> _downloadAndOpenDocument(String url) async {
    try {
      // Step 1: Get the document name and extension
      String fileName = url.split('/').last;

      // Step 2: Get the app's document directory to save the file
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String savePath = '${appDocDir.path}/$fileName';

      // Step 3: Download the file
      Dio dio = Dio();
      await dio.download(url, savePath);

      print('File downloaded to: $savePath');

      // Step 4: Open the downloaded file
      final result = await OpenFilex.open(savePath);
      print('File open result: ${result.message}');
    } catch (e) {
      print('Error: $e');
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

      // Add message to UI
      _addMessage(message);

      // Send to database
      try {
        if(person) {
          final audioData = await _createAudioData(_recordedFilePath!);
          await ApisMethods.sendDirectMsg(
          id: widget.receiver!.ID,
            participants: [_user.id, widget.receiver!.ID],
          sender: _user.id,
          content: 'Audio',
            audio: audioData,
          // Audio path
            createdAt: DateTime.fromMillisecondsSinceEpoch(message.createdAt!),
        );
        }else{
          // await ApisMethods.sendGrpMsg(message.id, message.id, _user.id, '', null, null, _recordedFilePath, DateTime.fromMillisecondsSinceEpoch(message.createdAt!),);
        }
      } catch (e) {
        print('Error sending audio message: $e');
      }
    }
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, WrappedMessage(message: message));
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

  void _handleMessageTap(BuildContext _, types.Message message) async {
    final index =
        _messages.indexWhere((element) => element.message.id == message.id);
    if (index != -1) {
      final wrappedMessage = _messages[index];
      if (wrappedMessage.message is CustomMessage) {
        final updatedMessage = wrappedMessage.message as CustomMessage;
        if (!wrappedMessage.seen) {
          setState(() {
            _messages[index] = WrappedMessage(
              message: updatedMessage,
              // seen: true,
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
    final index =
        _messages.indexWhere((element) => element.message.id == message.id);

    if (index != -1 && message is types.TextMessage) {
      final wrappedMessage = _messages[index];

      // Cast the message to TextMessage and update preview data
      final updatedMessage = types.TextMessage(
        id: wrappedMessage.message.id,
        author: wrappedMessage.message.author,
        createdAt: wrappedMessage.message.createdAt,
        text: (wrappedMessage.message as types.TextMessage).text,
        // Cast to TextMessage to access text
        previewData: previewData, // Update preview data
      );

      setState(() {
        _messages[index] = WrappedMessage(
          message: updatedMessage,
          // seen: wrappedMessage.seen,
        );
      });
    }
  }

  Future<void> _initRecorder() async {
    _recorder = FlutterSoundRecorder();

    await _recorder!.openRecorder();
    if (await Permission.microphone.request().isGranted) {
      await _recorder!
          .setSubscriptionDuration(const Duration(milliseconds: 10));
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

  @override
  Widget build(BuildContext context) {
    const groupChatTheme = DefaultChatTheme(
      primaryColor: Color(0xFF0E7490),
      secondaryColor: Color(0xFFFBFAFA),
      backgroundColor: Colors.white,
      receivedMessageBodyTextStyle: TextStyle(color: Color(0xFF083344)),
      sentMessageBodyTextStyle: TextStyle(color: Colors.white),
      inputBackgroundColor: Colors.white,
      // Message input background color
      attachmentButtonIcon: Icon(Icons.attach_file), // Attachment button icon
    );

    const personalChatTheme = DefaultChatTheme(
      primaryColor: Color(0xFF0E7490),
      secondaryColor: Color(0xFFFBFAFA),
      backgroundColor: Colors.white,
      receivedMessageBodyTextStyle: TextStyle(color: Color(0xFF083344)),
      sentMessageBodyTextStyle: TextStyle(color: Colors.white),
      inputBackgroundColor: Colors.white,
      // Message input background color
      attachmentButtonIcon: Icon(Icons.attach_file), // Attachment button icon
    );

    if (widget.groupName != null && widget.groupName!.contains(' ')) {
      final names = widget.groupName!.split(' ');
      final abbreviatedName = names[0][0] + names[1][0];

      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.black,
            ),
            title: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF0E7490),
                  child: Text(
                    abbreviatedName,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.groupName!,
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (widget.membersNumber != null)
                      Text(
                        '${widget.membersNumber} members',
                        style: GoogleFonts.ibmPlexMono(
                          color: const Color(0xFF888888),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                  ],
                ),
              ],
            ),
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
              theme: groupChatTheme,
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
                                    decoration: InputDecoration(
                                        hintText: 'Type a message...',
                                        border: InputBorder.none,
                                        hintStyle: GoogleFonts.ibmPlexMono(
                                          color: const Color(0xFF888888),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        )),
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
                if (message.mimeType?.startsWith('audio/') == true) {
                  // Existing audio message handling code
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: message.author.id == _user.id ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: message.author.id == _user.id
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.audiotrack,
                                color: message.author.id == _user.id
                                    ? Colors.white
                                    : Colors.black),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                'Voice Message',
                                style: TextStyle(
                                  color: message.author.id == _user.id
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.play_arrow,
                                  color: message.author.id == _user.id
                                      ? Colors.white
                                      : Colors.black),
                              onPressed: () {
                                _playAudio(message.uri);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 4.0),
                        Row(
                          mainAxisAlignment: message.author.id == _user.id
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('hh:mm a').format(
                                  DateTime.fromMillisecondsSinceEpoch(message.createdAt!)),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }

                // Handle images
                if (message.mimeType?.startsWith('image/') == true) {
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey[200],
                    ),
                    child: Image.network(
                      message.uri,
                      fit: BoxFit.cover,
                      width: messageWidth.toDouble(),
                    ),
                  );
                }

                // Handle documents
                if (message.mimeType?.startsWith('application/') == true) {
                  return GestureDetector(
                    onTap: () {
                      _downloadAndOpenDocument(message.uri); // Open the document on tap
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.grey[300],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.insert_drive_file, color: Colors.black),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              message.name ?? 'Document',
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Default case
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
                                _handleSendPressed(
                                    types.PartialText(text: text));
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

    }else{
      return SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: widget.receiver?.username ?? 'Chat',
            avatarUrl: 'https://r2.starryai.com/results/911754633/bccb46bd-67fe-47c7-8e5e-3dd39329d638.webp',
          ),
          // Rest of the Scaffold remains the same
          body:Chat(
              messages: _messages.map((wm) => wm.message).toList(),
              onAttachmentPressed: _handleAttachmentPressed,
              onMessageTap: _handleMessageTap,
              onPreviewDataFetched: _handlePreviewDataFetched,
              onSendPressed: _handleSendPressed,
              showUserAvatars: person,
              showUserNames: true,
              user: _user,
              theme: personalChatTheme,
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
                          style:
                          TextStyle(color: Colors.white, fontSize: 16),
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
                              decoration: InputDecoration(
                                  hintText: 'Type a message...',
                                  border: InputBorder.none,
                                  hintStyle: GoogleFonts.ibmPlexMono(
                                    color: const Color(0xFF888888),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  )),
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
              if (message.mimeType?.startsWith('audio/') == true) {
                // Existing audio message code...
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: message.author.id == _user.id ? Colors.blue : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: message.author.id == _user.id
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.audiotrack,
                              color: message.author.id == _user.id
                                  ? Colors.white
                                  : Colors.black),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              'Voice Message',
                              style: TextStyle(
                                color: message.author.id == _user.id
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.play_arrow,
                                color: message.author.id == _user.id
                                    ? Colors.white
                                    : Colors.black),
                            onPressed: () {
                              _playAudio(message.uri);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        mainAxisAlignment: message.author.id == _user.id
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('hh:mm a').format(
                                DateTime.fromMillisecondsSinceEpoch(message.createdAt!)),
                            style: const TextStyle(color: Colors.white, fontSize: 10.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else if (message.mimeType?.startsWith('application/') == true) {
                // For document files (PDF, Word, etc.)
                return GestureDetector(
                  onTap: () {
                    _downloadAndOpenDocument(message.uri);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: message.author.id == _user.id ? Colors.green : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.insert_drive_file,
                            color: message.author.id == _user.id
                                ? Colors.white
                                : Colors.black),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            'Document',
                            style: TextStyle(
                              color: message.author.id == _user.id
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // For other file messages
              return _buildCustomMessage(message, messageWidth: messageWidth);
            },
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

  Widget _buildCustomMessage(types.Message message,
      {required int messageWidth}) {
    final messageTime = DateFormat('hh:mm a')
        .format(DateTime.fromMillisecondsSinceEpoch(message.createdAt!));

    // Define the colors based on whether the message is sent or received
    final messageColor =
        message.author.id == _user.id ? Colors.blue : Colors.grey[300];
    final textColor =
        message.author.id == _user.id ? Colors.white : Colors.black;

    Widget seenIndicator = const SizedBox.shrink(); // Default to no indicator

    if (message is WrappedMessage) {
      final wrappedMessage = message as WrappedMessage;
      if (wrappedMessage.seen) {
        seenIndicator = const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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
          crossAxisAlignment: message.author.id == _user.id
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(color: textColor), // Use the same color for text
            ),
            const SizedBox(height: 4.0),
            Row(
              mainAxisAlignment: message.author.id == _user.id
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
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
          color:
              messageColor, // Use the same color for image message background
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: message.author.id == _user.id
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Image.file(File(message.uri),
                width: message.width, height: message.height),
            const SizedBox(height: 4.0),
            Row(
              mainAxisAlignment: message.author.id == _user.id
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
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
          crossAxisAlignment: message.author.id == _user.id
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
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
              mainAxisAlignment: message.author.id == _user.id
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
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
}

class WrappedMessage {
  final types.Message message;
  final bool seen = false;

  WrappedMessage({required this.message});

  Map<String, dynamic> toJson() {
    return {
      'message': message.toJson(),
      'seen': seen,
    };
  }
}