import 'package:flutter/material.dart';

import '../../Api/apimethods.dart';
import '../../Models/Student.dart';

class StudentSelectionScreen extends StatefulWidget {
  final List<dynamic> existmembers;
  final String groupId;
  const StudentSelectionScreen(
      {super.key, required this.existmembers, required this.groupId});

  @override
  _StudentSelectionScreenState createState() => _StudentSelectionScreenState();
}

class _StudentSelectionScreenState extends State<StudentSelectionScreen> {
  List<Student>? _Std;
  bool _isLoading_Std = true;

  Future<void> getStd() async {
    _Std = await ApisMethods.AllStudents();
    print('Std infooooooooo ${_Std!}');
    // Filter out existing members based on IDs

    // Extract _id from existmembers
    final existingMemberIds =
        widget.existmembers.map((member) => member['_id']).toSet();

    // Remove existing members from _Std based on _id
    _Std = _Std?.where((student) => !existingMemberIds.contains(student.ID))
        .toList();
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
            onPressed: () async {
              await ApisMethods.addStudentstoGroup(
                  groupId: widget.groupId,
                  studentIds: selectedStudentIds.toList());
            },
          ),
        ],
      ),
      body: _isLoading_Std
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _Std!.isEmpty
              ? const Center(child: Text("No students available"))
              : ListView.builder(
                  itemCount: _Std!.length,
                  itemBuilder: (context, index) {
                    final isSelected =
                        selectedStudentIds.contains(_Std![index].ID);
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
