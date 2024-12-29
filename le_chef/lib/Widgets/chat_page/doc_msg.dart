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

// Improved document download and open function
  Future<void> downloadAndOpenDocument(
      String url, String fileName, BuildContext context) async {
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
      final String fileExtension = _getFileExtension(contentType, url);

      // Update filename with correct extension
      final String processedFileName = _updateFileName(fileName, fileExtension);

      // Create appropriate directory based on file type
      final String fileDirectory =
          '${directory.path}/${fileExtension.toUpperCase()}s';
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
            'Failed to download file: Status ${response.statusCode}');
      }

      final List<int> bytes = response.data;

      // Verify file type from actual content
      final String? detectedType = _detectFileType(bytes);
      if (detectedType == null) {
        throw Exception('Unable to determine file type');
      }

      // Save the file
      final File file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);

      // Close loading indicator
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Open file with appropriate handler
      await _openFile(filePath, detectedType);
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
              Text('Error handling file:'),
              Text(
                e.toString(),
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  String _getFileExtension(String contentType, String url) {
    // First try to get extension from content type
    switch (contentType.toLowerCase()) {
      case 'application/pdf':
        return 'pdf';
      case 'image/jpeg':
        return 'jpg';
      case 'image/png':
        return 'png';
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

  String _updateFileName(String originalName, String extension) {
    // Remove any existing extension
    String baseName = originalName.contains('.')
        ? originalName.substring(0, originalName.lastIndexOf('.'))
        : originalName;

    return '$baseName.$extension';
  }

  Future<void> _openFile(String filePath, String fileType) async {
    try {
      // Open the file using open_filex
      final result = await OpenFilex.open(filePath);

      if (result.type != ResultType.done) {
        throw Exception('Failed to open file: ${result.message}');
      }
    } catch (e) {
      debugPrint('Error opening file: $e');
    }
  }

// Helper function to detect file type based on magic numbers
  String? _detectFileType(List<int> bytes) {
    if (bytes.length < 8) return null;

    // Check for common file signatures
    if (_isPDF(bytes)) return 'PDF';

    // ZIP, DOCX, XLSX, etc.
    if (bytes[0] == 0x50 && bytes[1] == 0x4B) return 'ZIP-based';

    // JPEG
    if (bytes[0] == 0xFF && bytes[1] == 0xD8) return 'JPEG';

    // PNG
    if (bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) return 'PNG';

    return null;
  }

  bool _isPDF(List<int> bytes) {
    if (bytes.length < 4) return false;
    // Check for PDF magic number '%PDF'
    return bytes[0] == 0x25 && // %
        bytes[1] == 0x50 && // P
        bytes[2] == 0x44 && // D
        bytes[3] == 0x46; // F
  }

  @override
  Widget build(BuildContext context) {
    final localTime =
        DateTime.fromMillisecondsSinceEpoch(message?.createdAt ?? 0).toLocal();
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
          downloadAndOpenDocument(message!.uri, message!.name, context);
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
                          : theme.receivedMessageBodyTextStyle)
                      .copyWith(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
