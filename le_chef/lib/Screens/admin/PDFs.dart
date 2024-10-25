import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Api/apimethods.dart';
import 'package:le_chef/Widgets/SmallCard.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../Models/PDF.dart';
import 'viewPDF.dart';

class AllPDFs extends StatefulWidget {
  const AllPDFs({Key? key}) : super(key: key);

  @override
  State<AllPDFs> createState() => _AllPDFsState();
}

class _AllPDFsState extends State<AllPDFs> {
  late Future<List<PDF>> pdfs;

  @override
  void initState() {
    super.initState();
    pdfs = ApisMethods().fetchAllPDFs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<PDF>>(
        future: pdfs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final pdfList = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: pdfList.length,
              itemBuilder: (context, index) {
                final pdf = pdfList[index];
                return Smallcard(
                  Title: pdf.title,
                  imageurl: 'assets/pdf.jpg',
                  description: pdf.description,
                  ontap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PDFViewerScreen(
                        pdfUrl: pdf.url,
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
