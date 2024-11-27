import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioMessageBubble extends StatefulWidget {
  final FileMessage? message;
  final User currentUser;
  final Function(String) onPlay;

  const AudioMessageBubble({
    this.message,
    required this.currentUser,
    required this.onPlay,
    Key? key,
  }) : super(key: key);

  @override
  _AudioMessageBubbleState createState() => _AudioMessageBubbleState();
}

class _AudioMessageBubbleState extends State<AudioMessageBubble> {
  bool _isPlaying = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  String getFileExtension(String contentType, String url) {
    // Similar to DocumentMessageBubble, but focus on audio types
    switch (contentType.toLowerCase()) {
      case 'audio/mpeg':
      case 'audio/mp3':
        return 'mp3';
      case 'audio/wav':
        return 'wav';
      case 'audio/aac':
        return 'aac';
      case 'audio/ogg':
        return 'ogg';
      case 'audio/m4a':
        return 'm4a';
      default:
      // If content type is not specific, try to get from URL
        final uri = Uri.parse(url);
        final path = uri.path;
        final lastDot = path.lastIndexOf('.');
        if (lastDot != -1) {
          return path.substring(lastDot + 1).toLowerCase();
        }
        return 'unknown';
    }
  }

  Future<void> _playAudio(String filePath) async {
    try {
      setState(() {
        _isPlaying = true;
      });

      await _audioPlayer.play(DeviceFileSource(filePath));

      // Listen for when audio finishes playing
      _audioPlayer.onPlayerComplete.listen((_) {
        setState(() {
          _isPlaying = false;
        });
      });
    } catch (e) {
      print('Error playing audio: $e');
      setState(() {
        _isPlaying = false;
      });
    }
  }

  Future<void> _stopAudio() async {
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
    });
  }

  Future<void> downloadAndPlayAudio(
      String url, String? fileName, BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      final Directory? directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('Unable to access external storage');
      }

      final Dio dio = Dio();

      // Check content type first
      final headResponse = await dio.head(
        url,
        options: Options(
          followRedirects: true,
          validateStatus: (status) => status! < 500,
        ),
      );

      final contentType = headResponse.headers['content-type']?.first ?? '';
      final String fileExtension = getFileExtension(contentType, url);

      // Update filename with correct extension
      final String processedFileName = updateFileName(fileName!, fileExtension);
      final String fileDirectory =
          '${directory.path}/Audio';
      await Directory(fileDirectory).create(recursive: true);

      final String filePath = '$fileDirectory/$processedFileName';

      // Download the file
      final response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          headers: {
            'Accept': '*/*',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to download audio file: Status ${response.statusCode}');
      }

      final List<int> bytes = response.data;
      final File file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);

      // Close loading indicator
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Play the audio file
      await _playAudio(filePath);
    } catch (e) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Error handling audio:'),
              Text(
                e.toString(),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  String updateFileName(String originalName, String extension) {
    // Remove any existing extension
    String baseName = originalName.contains('.')
        ? originalName.substring(0, originalName.lastIndexOf('.'))
        : originalName;

    return '$baseName.$extension';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        downloadAndPlayAudio(
            widget.message!.uri, widget.message?.name, context);
      },
      child: Container(
        height: 65,
        width: 190,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: _isPlaying ? Colors.green[700] : Colors.blue[700],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                widget.message?.name ?? 'Audio Message',
                style: GoogleFonts.ibmPlexMono(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}