import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class DocumentMessageBubble extends StatelessWidget {
  final types.FileMessage? message;
  final types.User currentUser;
  final Function(String, String?) onOpen;
  final DefaultChatTheme theme;

  const DocumentMessageBubble({
    this.message,
    required this.currentUser,
    required this.onOpen,
    required this.theme,
    super.key,
  });

  bool get isCurrentUser => message?.author.id == currentUser.id;

  String getFileExtension(String contentType, String url) {
    switch (contentType.toLowerCase()) {
      case 'application/pdf':
        return 'pdf';
      case 'image/jpeg':
        return 'jpg';
      case 'image/png':
        return 'png';
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
        final uri = Uri.parse(url);
        final path = uri.path;
        final lastDot = path.lastIndexOf('.');
        if (lastDot != -1) {
          return path.substring(lastDot + 1).toLowerCase();
        }
        return 'unknown';
    }
  }

  String updateFileName(String originalName, String extension) {
    String baseName = originalName.contains('.')
        ? originalName.substring(0, originalName.lastIndexOf('.'))
        : originalName;

    return '$baseName.$extension';
  }

  Future<void> openFile(String filePath, String fileType) async {
    String mimeType;
    String uti = '';

    switch (fileType.toUpperCase()) {
      case 'PDF':
        mimeType = 'application/pdf';
        uti = 'com.adobe.pdf';
        break;
      case 'JPEG':
        mimeType = 'image/jpeg';
        uti = 'public.jpeg';
        break;
      case 'PNG':
        mimeType = 'image/png';
        uti = 'public.png';
        break;
      case 'MP3':
        mimeType = 'audio/mpeg';
        uti = 'public.mp3';
        break;
      case 'WAV':
        mimeType = 'audio/wav';
        uti = 'public.wav';
        break;
      case 'AAC':
        mimeType = 'audio/aac';
        uti = 'public.aac-audio';
        break;
      case 'OGG':
        mimeType = 'audio/ogg';
        uti = 'org.xiph.ogg';
        break;
      case 'M4A':
        mimeType = 'audio/m4a';
        uti = 'public.mpeg-4-audio';
        break;
      default:
        mimeType = 'application/octet-stream';
    }

    final result = await OpenFilex.open(
      filePath,
      type: mimeType,
      uti: uti,
    );

    if (result.type != ResultType.done) {
      throw Exception('Failed to open file: ${result.message}');
    }
  }

  Widget _getFileIcon() {
    final mimeType = message?.mimeType;
    final iconColor = isCurrentUser
        ? theme.sentMessageBodyTextStyle.color
        : theme.receivedMessageBodyTextStyle.color;

    if (mimeType?.startsWith('audio/') ?? false) {
      return Icon(Icons.audio_file, color: iconColor);
    }
    return Icon(Icons.insert_drive_file, color: iconColor);
  }

  Future<void> downloadAndOpenDocument(String url, String? fileName, BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
              color: theme.primaryColor,
            ),
          );
        },
      );

      final Directory? directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('Unable to access external storage');
      }

      final Dio dio = Dio();

      final headResponse = await dio.head(
        url,
        options: Options(
          followRedirects: true,
          validateStatus: (status) => status! < 500,
        ),
      );

      final contentType = headResponse.headers['content-type']?.first ?? '';
      final String fileExtension = getFileExtension(contentType, url);

      final String processedFileName = updateFileName(fileName!, fileExtension);
      final String fileDirectory = '${directory.path}/${fileExtension.toUpperCase()}s';
      await Directory(fileDirectory).create(recursive: true);

      final String filePath = '$fileDirectory/$processedFileName';

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
        throw Exception('Failed to download file: Status ${response.statusCode}');
      }

      final List<int> bytes = response.data;
      final File file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      await openFile(filePath, fileExtension);
    } catch (e) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: theme.errorColor ?? Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localTime = DateTime.fromMillisecondsSinceEpoch(message?.createdAt ?? 0).toLocal();
    final hour = localTime.hour % 12 == 0 ? 12 : localTime.hour % 12;
    final minute = localTime.minute.toString().padLeft(2, '0');
    final timePeriod = localTime.hour >= 12 ? 'PM' : 'AM';

    return Container(
      margin: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: isCurrentUser ? 20 : 0,
        right: isCurrentUser ? 0 : 20,
      ),
      child: GestureDetector(
        onTap: () {
          downloadAndOpenDocument(message!.uri, message?.name, context);
        },
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: isCurrentUser ? theme.primaryColor : theme.secondaryColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: Radius.circular(isCurrentUser ? 20 : 0),
              bottomRight: Radius.circular(isCurrentUser ? 0 : 20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _getFileIcon(),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      message?.name ?? 'Document',
                      style: isCurrentUser
                          ? theme.sentMessageBodyTextStyle
                          : theme.receivedMessageBodyTextStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: Text(
                  '$hour:$minute $timePeriod',
                  style: (isCurrentUser
                      ? theme.sentMessageBodyTextStyle
                      : theme.receivedMessageBodyTextStyle
                  ).copyWith(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}