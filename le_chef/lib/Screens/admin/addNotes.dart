import 'package:flutter/material.dart';
import 'package:le_chef/Shared/custom_app_bar.dart';
import 'package:le_chef/services/content/note_service.dart';

import '../../Shared/custom_elevated_button.dart';
import '../../theme/custom_button_style.dart';

class addNotes extends StatefulWidget {
  const addNotes({super.key});

  @override
  _addNotesState createState() => _addNotesState();
}

class _addNotesState extends State<addNotes> {
  String? selectedlevel;

  final TextEditingController noteContentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: const CustomAppBar(
              title: 'Add Note',
            ),
            backgroundColor: Colors.grey[100],
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22.0, 0, 22.0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Choose level',
                        style: TextStyle(
                          color: Color(0xFF164863),
                          fontSize: 16,
                          fontFamily: 'IBM Plex Mono',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: selectedlevel,
                        hint: const Text('Select Level'),
                        items: ['Level 1', 'Level 2', 'Level 3']
                            .map((section) => DropdownMenuItem(
                                  value: section,
                                  child: Text(section),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedlevel = value;
                          });
                        },
                        decoration: const InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Note Content',
                        style: TextStyle(
                          color: Color(0xFF164863),
                          fontSize: 16,
                          fontFamily: 'IBM Plex Mono',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(6.0, 11, 6, 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: TextField(
                          controller: noteContentController,
                          decoration: const InputDecoration(
                            hintText: 'Write your note here....',
                            border: InputBorder.none, // No border
                            focusedBorder:
                                InputBorder.none, // No border when focused
                            enabledBorder:
                                InputBorder.none, // No border when enabled
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: (selectedlevel == null ||
                    (noteContentController == ''))
                ? Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: CustomElevatedButton(
                      onPressed: () {},
                      text: 'Add Note',
                      buttonStyle: CustomButtonStyles.darkgrey,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: CustomElevatedButton(
                      onPressed: () async {
                        print('from Uiiiiii ${noteContentController.text}${int.tryParse(selectedlevel!)?.toString() ?? ''}');

                        await NoteService.addNote(
                            noteContentController.text.toString(),
                            selectedlevel == 'Level 1'
                                ? 1
                                : (selectedlevel == 'Level 2' ? 2 : 3));
                      },
                      text: 'Add Note',
                      buttonStyle: CustomButtonStyles.fillPrimaryTL5,
                    ),
                  )));
  }
}
