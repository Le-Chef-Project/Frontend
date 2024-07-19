import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:le_chef/Screens/chats.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:audio_service/audio_service.dart';

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
  List<types.Message> _messages = [];
  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  );

  final TextEditingController _textController = TextEditingController();
  final ValueNotifier<bool> _isTyping = ValueNotifier(false);

  bool person = true;
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? _recordedFilePath;

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
    _recorder?.closeRecorder();
    super.dispose();
  }

  void _onTextChanged() {
    _isTyping.value = _textController.text.isNotEmpty;
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _addCustomVoiceMessage(String filePath, Duration duration) {
    final message = types.CustomMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      metadata: {
        'filePath': filePath,
        'duration': duration.inMilliseconds,
      },
    );

    _addMessage(message);
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

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index = _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage = (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
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

    // Clear the text input field
    _textController.clear();
  }

  void _loadMessages() async {
    final response = await rootBundle.loadString('assets/messages.json');
    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
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

    setState(() {
      _isRecording = true;
      _recordedFilePath = path;
    });
  }

  void _stopRecording() async {
    await _recorder!.stopRecorder();
    setState(() {
      _isRecording = false;
    });

    if (_recordedFilePath != null) {
      final duration = await getAudioDuration(_recordedFilePath!);
      _addCustomVoiceMessage(_recordedFilePath!, duration);
    }
  }

  Future<Duration> getAudioDuration(String filePath) async {
    final audioPlayer = FlutterSoundPlayer();
    await audioPlayer.openPlayer();

    Duration? duration;

    // Start playing the audio to get the duration
    await audioPlayer.startPlayer(
      fromURI: filePath,
      whenFinished: () {
        // Not used, but required for playback completion
      },
    );

    // Wait for the duration to be set
    while (duration == null) {
      await Future.delayed(Duration(milliseconds: 100));
    }

    await audioPlayer.stopPlayer();
    await audioPlayer.closePlayer();

    return duration!;
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
        appBar: person? CustomAppBar(
          title: "Thaowpsta",avatarUrl: 'https://r2.starryai.com/results/911754633/bccb46bd-67fe-47c7-8e5e-3dd39329d638.webp',
        ): CustomAppBar(
          title: "Group",
          avatarUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZeR6Y0pmPtmNaWamoKJ7soTxAERZIMrjHbg&s',
        ),
        body: Stack(
          children: [
            Chat(
              messages: _messages,
              onAttachmentPressed: _handleAttachmentPressed,
              onMessageTap: _handleMessageTap,
              onPreviewDataFetched: _handlePreviewDataFetched,
              onSendPressed: _handleSendPressed,
              showUserAvatars: person,
              showUserNames: true,
              user: _user,
              theme: person ? personalChatTheme : groupChatTheme,
              customBottomWidget: _isRecording
                  ? Center(child: _SoundWaveAnimation()) // Sound wave animation widget
                  : Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 85, 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBFAFA), // Blue background color
                    borderRadius: BorderRadius.circular(16.0), // Rounded corners
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.black), // Hint text color
                          ),
                          style: const TextStyle(color: Colors.black), // Input text color
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              _handleSendPressed(types.PartialText(text: value));
                            }
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.attach_file, color: Colors.black), // White attachment icon
                        onPressed: _handleAttachmentPressed,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
        ),
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

class _SoundWaveAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 85, 16),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Color(0xFF0E7490),
          borderRadius: BorderRadius.circular(16), // Adjust the radius as needed
        ),
        child: Center(
          child: Text(
            'Recording...',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class CustomVoiceMessage extends StatefulWidget {
  final String filePath;
  final Duration duration;

  const CustomVoiceMessage({
    Key? key,
    required this.filePath,
    required this.duration,
  }) : super(key: key);

  @override
  _CustomVoiceMessageState createState() => _CustomVoiceMessageState();
}

class _CustomVoiceMessageState extends State<CustomVoiceMessage> {
  FlutterSoundPlayer? _player;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  late StreamSubscription _playerSubscription;

  @override
  void initState() {
    super.initState();
    _player = FlutterSoundPlayer();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    await _player!.openPlayer();
    _playerSubscription = _player!.onProgress?.listen((e) {
      setState(() {
        _currentPosition = e.position;
      });
    }) as StreamSubscription;
  }

  Future<void> _playPause() async {
    if (_isPlaying) {
      await _player!.pausePlayer();
    } else {
      await _player!.startPlayer(
        fromURI: widget.filePath,
        whenFinished: () {
          setState(() {
            _isPlaying = false;
          });
        },
      );
    }

    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  void dispose() {
    _player?.closePlayer();
    _playerSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Voice Message')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Duration: ${widget.duration.inSeconds}s'),
            SizedBox(height: 20),
            Text('Current Position: ${_currentPosition.inSeconds}s'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _playPause,
              child: Text(_isPlaying ? 'Pause' : 'Play'),
            ),
          ],
        ),
      ),
    );
  }
}
