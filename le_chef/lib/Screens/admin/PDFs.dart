import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:le_chef/Widgets/SmallCard.dart';
import 'package:le_chef/services/content/media_service.dart';
import '../../Models/PDF.dart';
import '../../main.dart';
import 'THome.dart';
import 'viewPDF.dart';

class AllPDFs extends StatefulWidget {
  final int selectedLevel;

  const AllPDFs({Key? key, required this.selectedLevel}) : super(key: key);

  @override
  State<AllPDFs> createState() => _AllPDFsState();
}

class _AllPDFsState extends State<AllPDFs> {
  Future<List<PDF>>? pdfs;
  List<String> _allDateRanges = [];

  @override
  void initState() {
    super.initState();
    pdfs = _fetchAndFilterPDFs(); // Fetch and filter PDFs on initialization
  }

  // Fetch and filter PDFs based on selected level
  Future<List<PDF>> _fetchAndFilterPDFs() async {
    final _pdfs = await MediaService.fetchAllPDFs(token!);

    final _filteredPDFs = _pdfs.where((pdf) {
      return pdf.educationLevel == widget.selectedLevel;
    }).toList();

    _filteredPDFs.sort((a, b) =>
        DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)));

    _allDateRanges = _filteredPDFs
        .map((pdf) => _getDateText(pdf.createdAt))
        .toSet()
        .toList();

    return _filteredPDFs;
  }

  Map<String, List<PDF>> _grouppdfsByDate(List<PDF> pdfs) {
    Map<String, List<PDF>> groupedpdfs = {};

    for (var pdf in pdfs) {
      final dateText = _getDateText(pdf.createdAt);
      if (groupedpdfs[dateText] == null) {
        groupedpdfs[dateText] = [];
      }
      groupedpdfs[dateText]!.add(pdf);
    }
    return groupedpdfs;
  }

  String _getDateText(String createdAt) {
    final dateTime = DateTime.parse(createdAt);
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    final days = difference.inDays;

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return "Today";
    } else if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day - 1) {
      return "Yesterday";
    } else if (days < 7) {
      return "Last 7 days";
    } else if (days < 30) {
      return "Last 30 days";
    } else {
      return DateFormat.yMMMd().format(dateTime);
    }
  }

  Future<List<PDF>> _applyDateFilter(List<String> selectedRanges) async {
    // Fetch all PDFs
    final allPDFs = await MediaService.fetchAllPDFs(token!);

    // Apply both filters: education level and date range
    final filteredPDFs = allPDFs.where((pdf) {
      final pdfDateText = _getDateText(pdf.createdAt);

      // Ensure both conditions are satisfied
      return pdf.educationLevel == widget.selectedLevel &&
          selectedRanges.contains(pdfDateText);
    }).toList();

    // Sort the filtered PDFs
    filteredPDFs.sort((a, b) =>
        DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)));

    return filteredPDFs;
  }

  void _showFilterModal(BuildContext context, List<String> allDates) {
    Set<String> selectedDates = {};

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Filters",
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF164863),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: allDates.length,
                      itemBuilder: (context, index) {
                        final dateText = allDates[index];
                        return CheckboxListTile(
                          title: Text(dateText),
                          value: selectedDates.contains(dateText),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selectedDates.add(dateText);
                              } else {
                                selectedDates.remove(dateText);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, selectedDates.toList());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF427D9D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 15),
                        child: Text(
                          "Show Results",
                          style: GoogleFonts.ibmPlexMono(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          pdfs = _fetchAndFilterPDFs();
                        });

                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 15),
                        child: Text(
                          "Reset",
                          style: GoogleFonts.ibmPlexMono(
                            color: const Color(0xFF427D9D),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((selectedRanges) {
      if (selectedRanges != null && selectedRanges.isNotEmpty) {
        // Filter videos based on selected ranges
        setState(() {
          pdfs = _applyDateFilter(selectedRanges);
        });
      } else {
        setState(() {
          pdfs = _fetchAndFilterPDFs();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<PDF>>(
          future: pdfs,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No PDFs available"));
            }

            final groupedpdfs = _grouppdfsByDate(snapshot.data!);

            return ListView(
              children: groupedpdfs.entries.map((entry) {
                final dateText = entry.key;
                final pdfs = entry.value;
                final isFirst = entry.key == groupedpdfs.keys.first;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            dateText,
                            style: const TextStyle(
                              color: Color(0xFF164863),
                              fontSize: 20,
                              fontFamily: 'IBM Plex Mono',
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (isFirst)
                          TextButton(
                            onPressed: () {
                              _showFilterModal(context, _allDateRanges);
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFFFBFAFA),
                              padding: const EdgeInsets.all(16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Filter by date range',
                                  style: GoogleFonts.ibmPlexMono(
                                    color: const Color(0xFF888888),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_down_rounded,
                                    color: Color(0xFF888888))
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: pdfs.length,
                      itemBuilder: (context, index) {
                        final pdf = pdfs[index];
                        return Smallcard(
                          id: pdf.id,
                          type: 'PDF',
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
                          isLocked: false,
                        );
                      },
                    ),
                  ],
                );
              }).toList(),
            );
          }),
    );
  }
}
