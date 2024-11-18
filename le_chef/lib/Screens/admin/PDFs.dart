import 'package:flutter/material.dart';
import 'package:le_chef/Api/apimethods.dart';
import 'package:le_chef/Widgets/SmallCard.dart';
import '../../Models/PDF.dart';
import 'viewPDF.dart';

class AllPDFs extends StatefulWidget {
  final int selectedLevel;

  const AllPDFs({Key? key, required this.selectedLevel}) : super(key: key);

  @override
  State<AllPDFs> createState() => _AllPDFsState();
}

class _AllPDFsState extends State<AllPDFs> {
  late Future<List<PDF>> pdfs;
  List<PDF> _filteredPDFs = [];
  bool isloading = true;
  // Fetch and filter PDFs based on selected level
  void _fetchAndFilterPDFs() async {
    List<PDF> allPDFs = await ApisMethods().fetchAllPDFs();

    setState(() {
      isloading = false;
      _filteredPDFs = allPDFs
          .where((pdf) => pdf.educationLevel == widget.selectedLevel)
          .toList();
      print(
          'Filtered PDFs for unit ${widget.selectedLevel}: ${_filteredPDFs.length}');
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchAndFilterPDFs(); // Fetch and filter PDFs on initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isloading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator while fetching
          : _filteredPDFs.isEmpty
              ? const Center(
                  child: Text(
                      "No PDFs available")) // Show message if no PDFs match
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: _filteredPDFs.length,
                  itemBuilder: (context, index) {
                    final pdf = _filteredPDFs[index];
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
                      ), isLocked: false,
                    );
                  },
                ),
    );
  }
}
