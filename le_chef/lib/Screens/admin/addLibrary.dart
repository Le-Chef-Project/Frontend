import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:le_chef/Shared/custom_app_bar.dart';
import 'package:image_picker/image_picker.dart';

import '../../Api/apimethods.dart';
import '../../Shared/custom_elevated_button.dart';
import '../../Widgets/SmallCard.dart';
import '../../theme/custom_button_style.dart';
import 'viewPDF.dart';
import 'viewVideo.dart';

class AddLibrary extends StatefulWidget {
  @override
  _AddLibraryState createState() => _AddLibraryState();
}

class _AddLibraryState extends State<AddLibrary> {
  bool isPaid = false;
  String? selectedSection;
  String? selectedlevel;
  bool isLoading_video = false; // Track loading status
  bool isLoading_pdf = false; // Track loading status

  final TextEditingController amountController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController itemDescriptionController =
      TextEditingController();

  File? _videoFile;

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadVideo() async {
    if (_videoFile != null) {
      setState(() {
        isLoading_video = true; // Start loading
      });

      _showLoadingDialog(); // Show the loading dialog

      // Call the API and handle the response
      await ApisMethods.uploadVideo(
        videoFile: _videoFile!,
        title: itemNameController.text,
        description: itemDescriptionController.text,
        amountToPay: isPaid ? double.tryParse(amountController.text) : null,
        paid: isPaid,
        educationLevel: int.parse(selectedlevel!.replaceFirst('Level ', '')),
      ).then((_) {
        // On success, close the loading dialog
        setState(() {
          isLoading_video = false; // Stop loading
          Navigator.of(context, rootNavigator: true).pop(); // Close the dialog
        });
      }).catchError((error) {
        // Handle the error if needed
        print('Error uploading video: $error');
        setState(() {
          isLoading_video = false; // Stop loading
          Navigator.of(context, rootNavigator: true).pop(); // Close the dialog
        });
      });
    } else {
      print('No video selected');
    }
  }

  Future<void> _uploadPDF() async {
    if (selectedFile != null) {
      setState(() {
        isLoading_pdf = true; // Start loading
      });

      _showLoadingDialog(); // Show the loading dialog

      // Call the API and handle the response
      await ApisMethods.uploadPDF(
        title: itemNameController.text,
        description: itemDescriptionController.text,
        amountToPay: isPaid ? double.tryParse(amountController.text) : null,
        paid: isPaid,
        educationLevel: int.parse(selectedlevel!.replaceFirst('Level ', '')),
        PDF: selectedFile!,
      ).then((_) {
        // On success, close the loading dialog
        setState(() {
          isLoading_pdf = false; // Stop loading
          Navigator.of(context, rootNavigator: true).pop(); // Close the dialog
        });
      }).catchError((error) {
        // Handle the error if needed
        print('Error uploading PDF: $error');
        setState(() {
          isLoading_pdf = false; // Stop loading
          Navigator.of(context, rootNavigator: true).pop(); // Close the dialog
        });
      });
    } else {
      print('No PDF selected');
    }
  }

  void _handleNavigation(BuildContext context) {
    if (selectedSection == 'Video' && _videoFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(
            url: _videoFile!.path,
          ),
        ),
      );
    } else if (selectedSection == 'PDF' && selectedFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerScreen(
            pdfUrl: selectedFile!.path,
          ),
        ),
      );
    }
  }

  File? selectedFile;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFile = File(result.files.single.path!.toString());
      });
    }
  }

  Future<void> _showLoadingDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text("Uploading, please wait..."),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasFile = _videoFile != null || selectedFile != null;

    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(
        title: 'Add Item to library',
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
              Padding(
                padding: const EdgeInsets.fromLTRB(6.0, 28, 6, 0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Paid',
                          style: TextStyle(
                            color: Color(0xFF164863),
                            fontSize: 16,
                            fontFamily: 'IBM Plex Mono',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                        Switch(
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey,
                          activeTrackColor: Colors.green,
                          activeColor: Colors.white,
                          value: isPaid,
                          onChanged: (value) {
                            setState(() {
                              isPaid = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Container(
                      width: 400,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0.50,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: Color(0xFFC6C6C8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (isPaid)
                Padding(
                  padding: const EdgeInsets.fromLTRB(6.0, 11, 6, 0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Amount to pay',
                        border: InputBorder.none, // No border
                        focusedBorder:
                            InputBorder.none, // No border when focused
                        enabledBorder:
                            InputBorder.none, // No border when enabled
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Level Section',
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: DropdownButtonFormField<String>(
                  value: selectedlevel,
                  hint: Text('Select Level Section'),
                  items: ['Level 1', 'Level 2', 'Level 3']
                      .map((section) => DropdownMenuItem(
                            child: Text(section),
                            value: section,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedlevel = value;
                    });
                  },
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Library Section',
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: DropdownButtonFormField<String>(
                  value: selectedSection,
                  hint: Text('Select Library Section'),
                  items: ['Video', 'Book', 'PDF']
                      .map((section) => DropdownMenuItem(
                            child: Text(section),
                            value: section,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSection = value;
                    });
                  },
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(height: 16),
              // Item name input
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Item name',
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: TextField(
                    controller: itemNameController,
                    decoration: InputDecoration(
                      hintText: 'Item name',
                      border: InputBorder.none, // No border
                      focusedBorder: InputBorder.none, // No border when focused
                      enabledBorder: InputBorder.none, // No border when enabled
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Item description input

              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Item description',
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: TextField(
                    controller: itemDescriptionController,
                    decoration: InputDecoration(
                      hintText: 'Item description',
                      border: InputBorder.none, // No border
                      focusedBorder: InputBorder.none, // No border when focused
                      enabledBorder: InputBorder.none, // No border when enabled
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              // Upload button
              if (hasFile)
                Center(
                  child: Smallcard(
                    imageurl: selectedSection == 'Video' && _videoFile != null
                        ? 'assets/desk_book_apple.jpeg'
                        : 'assets/pdf.jpg',
                    ontap: () => _handleNavigation(context), isLocked: false,
                  ),
                )
              else
                Center(
                  child: GestureDetector(
                    onTap: () {
                      if (selectedSection == 'Video') {
                        _pickVideo();
                      } else if (selectedSection == 'Book' ||
                          selectedSection == 'PDF') {
                        pickFile();
                      }
                    },
                    child: Container(
                      width: 320,
                      height: 275,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: DottedBorder(
                          borderType: BorderType.Circle,
                          radius: Radius.circular(12),
                          dashPattern: [6, 3],
                          child: Container(
                            width: 157,
                            height: 157,
                            child: Center(
                              child: IconButton(
                                onPressed: () {
                                  if (selectedSection == 'Video') {
                                    _pickVideo();
                                  } else if (selectedSection == 'Book' ||
                                      selectedSection == 'PDF') {
                                    pickFile();
                                  }
                                },
                                icon: Icon(
                                  Icons.cloud_upload,
                                  size: 40,
                                  color: Color(0xFF427D9D),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: (selectedSection == 'Video' && _videoFile == null) ||
              (selectedSection == 'PDF' && selectedFile == null)
          ? Padding(
              padding: const EdgeInsets.all(24.0),
              child: CustomElevatedButton(
                onPressed: () {},
                text: 'Add Item',
                buttonStyle: CustomButtonStyles.darkgrey,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: CustomElevatedButton(
                onPressed: () {
                  if (selectedSection == 'Video') _uploadVideo();
                  if (selectedSection == 'PDF') _uploadPDF();
                },
                text: 'Add Item',
                buttonStyle: CustomButtonStyles.fillPrimaryTL5,
              ),
            ),
    ));
  }
}
