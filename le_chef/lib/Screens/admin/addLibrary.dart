import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:le_chef/Shared/custom_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:le_chef/services/content/media_service.dart';
import '../../Shared/custom_elevated_button.dart';
import '../../Widgets/SmallCard.dart';
import '../../theme/custom_button_style.dart';
import 'viewPDF.dart';
import 'viewVideo.dart';

class AddLibrary extends StatefulWidget {
  const AddLibrary({super.key});

  @override
  _AddLibraryState createState() => _AddLibraryState();
}

class _AddLibraryState extends State<AddLibrary> {
  bool isPaid = false;
  String? responseVideo;
  String? selectedSection;
  String? selectedlevel;
  bool isLoading_video = false; // Track loading status
  bool isLoading_pdf = false; // Track loading status
  String? responsePDF;
  File? _thumbnailFile;

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

  Future<void> _pickThumbnail() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _thumbnailFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadVideo() async {
    if (_videoFile != null) {
      setState(() {
        isLoading_video = true; // Start loading
      });

      _showLoadingDialog(); // Show the loading dialog
      try {
        // Call the API
        responseVideo = await MediaService.uploadVideo(
          videoFile: _videoFile!,
          title: itemNameController.text,
          thumbnailFile: _thumbnailFile!,
          description: itemDescriptionController.text,
          amountToPay: isPaid ? double.tryParse(amountController.text) : null,
          paid: isPaid,
          educationLevel: int.parse(selectedlevel!.replaceFirst('Level ', '')),
        );
      } catch (error) {
        print('Error uploading video: $error');
      } finally {
        // Close the loading dialog
        if (Navigator.canPop(context)) {
          Navigator.of(context, rootNavigator: true).pop();
        }

        setState(() {
          isLoading_video = false; // Stop loading
        });

        // Show the success or error dialog
        if (responseVideo == 'success') {
          showDialog(
            context: context,
            builder: (context) {
              return const SimpleDialog(
                title: Text('Success'),
                contentPadding: EdgeInsets.all(20),
                children: [Text('Video uploaded successfully!')],
              );
            },
          );

          amountController.clear();
          itemNameController.clear();
          itemDescriptionController.clear();
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: const Text('Error'),
                contentPadding: const EdgeInsets.all(20),
                children: [Text('Failed to upload video')],
              );
            },
          );
        }
      }
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

      try {
        // Call the API
        responsePDF = await MediaService.uploadPDF(
          title: itemNameController.text,
          description: itemDescriptionController.text,
          amountToPay: isPaid ? double.tryParse(amountController.text) : null,
          paid: isPaid,
          educationLevel: int.parse(selectedlevel!.replaceFirst('Level ', '')),
          PDF: selectedFile!,
        );
      } catch (error) {
        print('Error uploading PDF: $error');
      } finally {
        // Close the loading dialog
        if (Navigator.canPop(context)) {
          Navigator.of(context, rootNavigator: true).pop();
        }

        setState(() {
          isLoading_pdf = false; // Stop loading
        });

        // Show the success or error dialog
        if (responsePDF == 'success') {
          showDialog(
            context: context,
            builder: (context) {
              return const SimpleDialog(
                title: Text('Success'),
                contentPadding: EdgeInsets.all(20),
                children: [Text('PDF uploaded successfully!')],
              );
            },
          );
          amountController.clear();
          itemNameController.clear();
          itemDescriptionController.clear();
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: const Text('Error'),
                contentPadding: const EdgeInsets.all(20),
                children: [Text('Failed to upload PDF')],
              );
            },
          );
        }
      }
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
          child: const Padding(
            padding: EdgeInsets.all(16.0),
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

    return Scaffold(
      appBar: const CustomAppBar(
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
                        const Text(
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
                      decoration: const ShapeDecoration(
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
                      decoration: const InputDecoration(
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
              const SizedBox(height: 50),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
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
                  hint: const Text('Select Level Section'),
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
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
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
                  hint: const Text('Select Library Section'),
                  items: ['Video', 'PDF']
                      .map((section) => DropdownMenuItem(
                            value: section,
                            child: Text(section),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSection = value;
                    });
                  },
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
              const SizedBox(height: 16),
              // Item name input
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
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
                    decoration: const InputDecoration(
                      hintText: 'Item name',
                      border: InputBorder.none, // No border
                      focusedBorder: InputBorder.none, // No border when focused
                      enabledBorder: InputBorder.none, // No border when enabled
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Item description input

              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
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
                    decoration: const InputDecoration(
                      hintText: 'Item description',
                      border: InputBorder.none, // No border
                      focusedBorder: InputBorder.none, // No border when focused
                      enabledBorder: InputBorder.none, // No border when enabled
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
// upload image for video

              if (selectedSection == 'Video')
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Video Background',
                        style: TextStyle(
                          color: Color(0xFF164863),
                          fontSize: 16,
                          fontFamily: 'IBM Plex Mono',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ),
                    _thumbnailFile != null
                        ? Center(
                            child: Container(
                              width: 200, // Set the desired width
                              height: 150, // Set the desired height
                              child: Image.file(
                                File(_thumbnailFile!
                                    .path), // Use Image.file for local files
                                fit: BoxFit
                                    .cover, // Adjust the image to cover the available space
                              ),
                            ),
                          )
                        : Center(
                            child: IconButton(
                              onPressed: () {
                                _pickThumbnail();
                              },
                              icon: const Icon(
                                Icons.cloud_upload,
                                size: 40,
                                color: Color(0xFF427D9D),
                              ),
                            ),
                          ),
                  ],
                ),

              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Upload Item',
                  style: TextStyle(
                    color: Color(0xFF164863),
                    fontSize: 16,
                    fontFamily: 'IBM Plex Mono',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Upload button
              if (hasFile)
                Column(
                  children: [
                    // Text prompting the user to click
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        selectedSection == 'Video'
                            ? 'Tap to preview the video' // For videos
                            : 'Tap to open the PDF', // For PDFs
                        style: TextStyle(
                          color: Color(0xFF164863),
                          fontSize: 12,
                          fontFamily: 'IBM Plex Mono',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ),

                    Center(
                      child: Smallcard(amountToPay:0 ,
                        file: true,
                        type: selectedSection.toString(),
                        imageurl: selectedSection == 'Video' &&
                                _videoFile != null
                            ? _thumbnailFile != null
                                ? _thumbnailFile!.path
                                : 'https://media.gettyimages.com/id/1754241080/video/book-stack-education-with-learning-and-laptop-in-library-or-classroom-to-study-for-knowledge.jpg?s=640x640&k=20&c=Qtrfax72OFeXoglGlGr1rSmZUCdCkpgtCilcOM7Vq9U='
                            : 'assets/pdf.jpg',
                        ontap: () => _handleNavigation(context),
                        isLocked: false,
                      ),
                    ),
                  ],
                )
              else
                Center(
                  child: GestureDetector(
                    onTap: () {
                      if (selectedSection == 'Video') {
                        _pickVideo();
                      } else if (selectedSection == 'PDF') {
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
                          radius: const Radius.circular(12),
                          dashPattern: const [6, 3],
                          child: SizedBox(
                            width: 157,
                            height: 157,
                            child: Center(
                              child: IconButton(
                                onPressed: () {
                                  if (selectedSection == 'Video') {
                                    _pickVideo();
                                  } else if (selectedSection == 'PDF') {
                                    pickFile();
                                  }
                                },
                                icon: const Icon(
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

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ((selectedSection == 'Video' &&
                  (_videoFile == null || _thumbnailFile == null)) ||
              (selectedSection == 'PDF' && selectedFile == null) ||
              ((isPaid && amountController.text.isEmpty) ||
                  itemDescriptionController.text.isEmpty ||
                  itemNameController.text.isEmpty))
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
    );
  }
}
