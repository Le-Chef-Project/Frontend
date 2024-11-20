import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Api/apimethods.dart';
import '../../Models/Student.dart';
import '../../Shared/textInputDecoration.dart';

class StudentSelectionScreen extends StatefulWidget {
  final bool is_exist;
  const StudentSelectionScreen({super.key, required this.is_exist});

  @override
  _StudentSelectionScreenState createState() => _StudentSelectionScreenState();
}

class _StudentSelectionScreenState extends State<StudentSelectionScreen> {
  List<Student>? _Std;
  bool _isLoading_Std = true;
  final TextEditingController _TitleController = TextEditingController();
  final TextEditingController _DescriptionController = TextEditingController();

  Future<void> getStd() async {
    _Std = await ApisMethods.AllStudents();
    print('Std infooooooooo ${_Std!}');
    setState(() {
      _isLoading_Std = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getStd();
  }

  final Set<String> selectedStudentIds = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Select Students'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            color: const Color(0xFF164863),
            iconSize: 35,
            onPressed: () {
              /*// Display selected student IDs
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Selected Student IDs'),
                  content: Text(selectedStudentIds.join(', ')),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );*/
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: Image.asset(
                      'assets/group.jpg',
                      width: 96.53,
                      height: 96.37,
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 275,
                            child: Text(
                              'Add Group Title',
                              style: GoogleFonts.ibmPlexMono(
                                color: const Color(0xFF164863),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _TitleController,
                            decoration:
                                textInputDecoration.copyWith(hintText: 'Title'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter a Title';
                              } //TODO
                              //check isFound or not
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: 275,
                            child: Text(
                              'Add Group Description',
                              style: GoogleFonts.ibmPlexMono(
                                color: const Color(0xFF164863),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _DescriptionController,
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Description'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter a Description';
                              } //TODO
                              //check isFound or not
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: 140.50,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_TitleController.text.isEmpty ||
                                        _DescriptionController.text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please fill in all fields')),
                                      );
                                    } else {
                                      await ApisMethods.createGrp(
                                          _TitleController.text.toString(),
                                          _DescriptionController.text
                                              .toString(),
                                          selectedStudentIds.toList());
                                      _TitleController.clear();
                                      _DescriptionController.clear();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF427D9D),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Create Group',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.ibmPlexMono(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: SizedBox(
                                width: 140.50,
                                height: 48,
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        color: Color(0xFF427D9D)),
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 1, color: Color(0xFF427D9D)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.ibmPlexMono(
                                      color: const Color(0xFF427D9D),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: _isLoading_Std
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _Std!.length,
              itemBuilder: (context, index) {
                final isSelected = selectedStudentIds.contains(_Std![index].ID);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: ShapeDecoration(
                      color: const Color.fromARGB(255, 246, 245, 245),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        '${_Std![index].firstname} ${_Std![index].Lastname}',
                        style: const TextStyle(
                          color: Color(0xFF164863),
                          fontSize: 16,
                          fontFamily: 'Heebo',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                      trailing: Icon(
                        isSelected
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: isSelected ? const Color(0xFF0E7490) : null,
                      ),
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedStudentIds.remove(_Std![index].ID);
                          } else {
                            selectedStudentIds.add(_Std![index].ID);
                          }
                        });
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
