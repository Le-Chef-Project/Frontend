import 'package:le_chef/Models/PDF.dart';

class PDFResponse {
  final List<PDF> pdfs;
  final List<String> paidPdfIds;

  PDFResponse({
    required this.pdfs,
    required this.paidPdfIds,
  });

  factory PDFResponse.fromJson(Map<String, dynamic> json) {
    return PDFResponse(
      pdfs: (json['pdfs'] as List).map((pdf) => PDF.fromjson(pdf)).toList(),
      paidPdfIds: List<String>.from(json['pdfPaidContentIds'] ?? []),
    );
  }
}
