import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';

class CustomVoiceMessage extends StatefulWidget {
  final String filePath;
  final Duration duration;
  final DefaultChatTheme chatTheme;

  const CustomVoiceMessage({
    Key? key,
    required this.filePath,
    required this.duration,
    required this.chatTheme,
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
      appBar: AppBar(
        title: Text('Voice Message'),
        backgroundColor: widget.chatTheme.primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Duration: ${widget.duration.inSeconds}s',
              style: TextStyle(color: widget.chatTheme.receivedMessageBodyTextStyle.color),
            ),
            SizedBox(height: 20),
            Text(
              'Current Position: ${_currentPosition.inSeconds}s',
              style: TextStyle(color: widget.chatTheme.receivedMessageBodyTextStyle.color),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _playPause,
              child: Text(
                _isPlaying ? 'Pause' : 'Play',
                style: TextStyle(color: widget.chatTheme.primaryColor),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.chatTheme.secondaryColor, // Background color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
