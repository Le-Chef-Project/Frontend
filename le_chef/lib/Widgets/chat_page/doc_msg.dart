import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class DocumentMessageBubble extends StatelessWidget {
  final FileMessage? message;
  final User currentUser;
  final Function(String, String?) onOpen;

  const DocumentMessageBubble({
    this.message,
    required this.currentUser,
    required this.onOpen,
    super.key,
  });

  String getFileExtension(String contentType, String url) {
    // First try to get extension from content type
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

  String updateFileName(String originalName, String extension) {
    // Remove any existing extension
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

  String? detectFileType(List<int> bytes) {
    if (bytes.length < 8) return null;

    // Check for common file signatures
    if (isPDF(bytes)) return 'PDF';

    // ZIP, DOCX, XLSX, etc.
    if (bytes[0] == 0x50 && bytes[1] == 0x4B) return 'ZIP-based';

    // JPEG
    if (bytes[0] == 0xFF && bytes[1] == 0xD8) return 'JPEG';

    // PNG
    if (bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) return 'PNG';

    // MP3
    if (bytes[0] == 0x49 && bytes[1] == 0x44 && bytes[2] == 0x33) return 'MP3';

    // WAV
    if (bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46) return 'WAV';

    // Check content type from message if available
    final contentType = message?.mimeType?.toLowerCase() ?? '';
    if (contentType.startsWith('audio/')) {
      return contentType.split('/').last.toUpperCase();
    }

    return null;
  }

  bool isPDF(List<int> bytes) {
    if (bytes.length < 4) return false;
    // Check for PDF magic number '%PDF'
    return bytes[0] == 0x25 && // %
        bytes[1] == 0x50 && // P
        bytes[2] == 0x44 && // D
        bytes[3] == 0x46; // F
  }

  bool isAudioFile(String? mimeType, String fileName) {
    if (mimeType?.startsWith('audio/') ?? false) return true;

    final audioExtensions = [
      '.mp3', '.wav', '.aac', '.ogg', '.m4a', '.wma', '.flac'
    ];
    return audioExtensions.any((ext) => fileName.toLowerCase().endsWith(ext));
  }

  Widget _getFileIcon() {
    final fileName = message?.name ?? '';
    final mimeType = message?.mimeType;

    if (isAudioFile(mimeType, fileName)) {
      return const Icon(Icons.audio_file, color: Colors.white);
    }

    // Default document icon for other file types
    return const Icon(Icons.insert_drive_file, color: Colors.white);
  }

  Future<void> downloadAndOpenDocument(
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
      final String? detectedType = detectFileType(bytes);
      if (detectedType == null) {
        throw Exception('Unable to determine file type');
      }
      final File file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);

      // Close loading indicator
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Open file with appropriate handler
      await openFile(filePath, detectedType);
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
              const Text('Error handling file:'),
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        downloadAndOpenDocument(
            message!.uri, message?.name, context); // Open the document on tap
      },
      child: Container(
        height: 65,
        width: 190,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            _getFileIcon(), // Dynamic icon based on file type
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                message?.name ?? 'Document',
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