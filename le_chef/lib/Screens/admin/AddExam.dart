import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Api/apimethods.dart';
import 'package:le_chef/Screens/ExamForm.dart';
import 'package:le_chef/Screens/exams.dart';
import 'package:le_chef/Shared/custom_elevated_button.dart';
import 'package:le_chef/Widgets/dialog_with_two_buttons.dart';
import '../../Models/Quiz.dart';
import '../../theme/custom_button_style.dart';
import 'AddQuestion.dart';

class AddExam extends StatefulWidget {
  final List<QuizQuestion>? quizList;

  const AddExam({super.key, this.quizList});

  @override
  _AddExamState createState() => _AddExamState();
}

class _AddExamState extends State<AddExam> {
  final _formKey = GlobalKey<FormState>();
  final _hourOneController = TextEditingController();
  final _hourTwoController = TextEditingController();
  final _minuteOneController = TextEditingController();
  final _minuteTwoController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController quizFees = TextEditingController();
  final TextEditingController addController = TextEditingController();
  bool light = true;
  List<String> levels = ['Level 1', 'Level 2', 'Level 3'];
  List<String> units = ['Unit 1', 'Unit 2', 'Unit 3'];
  String? selectedLevels;
  String? selectedUnit;

  @override
  void dispose() {
    _hourOneController.dispose();
    _hourTwoController.dispose();
    _minuteOneController.dispose();
    _minuteTwoController.dispose();
    titleController.dispose();
    quizFees.dispose();
    addController.dispose();
    super.dispose();
  }

  String? _validateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter minutes';
    }
    final int? minutes = int.tryParse(value);
    if (minutes == null || minutes < 0 || minutes > 9) {
      return 'Enter valid minutes (0-59)';
    }
    return null;
  }

  // Function to handle submitting the form
  void _submitQuiz() async {
    if (_formKey.currentState!.validate() && titleController.text.isNotEmpty) {
      List<Map<String, dynamic>> questions = widget.quizList!.map((quiz) {
        return {
          'question': quiz.questionText,
          'options': quiz.options,
          'answer': quiz.answer,
        };
      }).toList();

      print('Waiting...');
      await ApisMethods.AddQuiz(titleController.text, questions, _hourOneController.text + _hourTwoController.text, _minuteOneController.text + _minuteTwoController.text, selectedLevels!, selectedUnit!, light);
      print('added...');
    }

    dialogWithButtons(
        context: context,
        icon: Image.asset('assets/error-16_svgrepo.com.jpg'),
        title: 'Are you sure you finish putting Exam ?',
        button1Text: 'Finish Exam',
        button1Action: () {
          dialogWithButtons(
              context: context,
              icon: const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 117,
              ),
              title: 'Success !',
              content: 'Exam posted to students.');
          Future.delayed((const Duration(seconds: 2)), () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => Exams()));
          });
        },
        button2Text: 'Cancel',
        button2Action: () => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    final List<QuizQuestion> quizList = widget.quizList ?? [];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Select Exam Time'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 38, 24, 48),
                child: Text(
                  'Press (+) If you want to add question.',
                  style: TextStyle(
                    color: Color(0xFF888888),
                    fontSize: 12,
                    fontFamily: 'IBM Plex Mono',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                'Paid',
                                style: GoogleFonts.ibmPlexMono(
                                  color: Color(0xFF164863),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 50),
                              Switch(
                                value: light,
                                activeColor: Color(0xFF00B84A),
                                thumbColor:
                                    WidgetStatePropertyAll(Colors.white),
                                onChanged: (bool value) {
                                  setState(() {
                                    light = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 25),
                        Expanded(
                          child: Text(
                            'Exam name',
                            style: GoogleFonts.ibmPlexMono(
                              color: Color(0xFF164863),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: ShapeDecoration(
                              color: Color(0xFFFBFAFA),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: TextFormField(
                              controller: quizFees,
                              enabled: light,
                              style: GoogleFonts.ibmPlexMono(
                                color: light ? Color(0xFF164863) : Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                hintText: 'amount to pay',
                                hintStyle: GoogleFonts.ibmPlexMono(
                                  color:
                                      light ? Color(0xFF164863) : Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 25, horizontal: 25),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Color(0xFFFBFAFA),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            decoration: ShapeDecoration(
                              color: Color(0xFFFBFAFA),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: TextFormField(
                              controller: titleController,
                              enabled: true,
                              style: GoogleFonts.ibmPlexMono(
                                color: Color(0xFF164863),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                hintText: 'write exam name',
                                hintMaxLines: 2,
                                hintStyle: GoogleFonts.ibmPlexMono(
                                  color: Color(0xFF164863),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 25),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Color(0xFFFBFAFA),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 23.0, horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            child: Text(
                          'Choose Level',
                          style: GoogleFonts.ibmPlexMono(
                            color: Color(0xFF164863),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                        Expanded(
                            child: Text(
                          'Choose Unit',
                          style: GoogleFonts.ibmPlexMono(
                            color: Color(0xFF164863),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ))
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            child: DropdownMenu(
                          hintText: 'Select Level',
                          textStyle: TextStyle(
                            color: Color(0xFF667084),
                            fontSize: 12,
                            fontFamily: 'IBM Plex Mono',
                            fontWeight: FontWeight.w400,
                          ),
                          // trailingIcon: Icon(Icons.keyboard_arrow_down_sharp, color: Color(0xFF667085),),
                          menuStyle: MenuStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.white),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          onSelected: (String? value) {
                            setState(() {
                              selectedLevels = value;
                            });
                          },
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xFFD0D5DD)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xFF164863)),
                            ),
                          ),
                          dropdownMenuEntries: levels
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                                value: value,
                                label: value,
                                style: MenuItemButton.styleFrom(
                                    textStyle: GoogleFonts.ibmPlexMono(
                                  color: Color(0xFF0F1728),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                )));
                          }).toList(),
                        )),
                        Expanded(
                            child: DropdownMenu(
                          hintText: 'Select unit',
                          textStyle: TextStyle(
                            color: Color(0xFF667084),
                            fontSize: 12,
                            fontFamily: 'IBM Plex Mono',
                            fontWeight: FontWeight.w400,
                          ),
                          menuStyle: MenuStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.white),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          onSelected: (String? value) {
                            setState(() {
                              selectedUnit = value;
                            });
                          },
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xFFD0D5DD)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xFF164863)),
                            ),
                          ),
                          dropdownMenuEntries: [
                            ...units
                                .map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(
                                  value: value,
                                  label: value,
                                  style: MenuItemButton.styleFrom(
                                      textStyle: GoogleFonts.ibmPlexMono(
                                    color: Color(0xFF0F1728),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  )));
                            }).toList(),
                            DropdownMenuEntry<String>(
                              value: 'add_new',
                              label: 'Add Unit',
                              enabled: false,
                              style: MenuItemButton.styleFrom(
                                  backgroundColor: Color(0xFFDDF2FD),
                                  padding: EdgeInsets.all(8),
                                  textStyle: GoogleFonts.ibmPlexMono(
                                    color: Colors.transparent,
                                    fontSize: 0,
                                  )),
                              leadingIcon: Container(
                                width: 100,
                                height: 40,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: addController,
                                        decoration: InputDecoration(
                                          hintText: 'Add Unit',
                                          hintStyle: GoogleFonts.ibmPlexMono(
                                            color: Color(0xFF164863),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        style: GoogleFonts.ibmPlexMono(
                                          color: Color(0xFF0F1728),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        onFieldSubmitted: (value) {
                                          if (value.isNotEmpty) {
                                            setState(() {
                                              units.add(value);
                                              addController.clear();
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            DropdownMenuEntry<String>(
                                value: 'add_button',
                                label: 'Add Unit',
                                style: MenuItemButton.styleFrom(
                                    padding: EdgeInsets.all(8),
                                    textStyle: GoogleFonts.ibmPlexMono(
                                      color: Colors.transparent,
                                      fontSize: 0,
                                    )),
                                leadingIcon: Padding(
                                  padding: const EdgeInsets.only(left: 38.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      String value = addController.text;

                                      if (value.isNotEmpty) {
                                        setState(() {
                                          units.add(value);
                                          addController.clear();
                                        });
                                      }
                                    },
                                    child: Text(
                                      'Add Unit',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF427D9D),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14.5, horizontal: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ))
                          ],
                        ))
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: double.infinity,
                  height: 180,
                  padding: const EdgeInsets.all(16),
                  decoration: ShapeDecoration(
                    color: Color(0xFFFBFAFA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Exam Time',
                          style: TextStyle(
                            color: Color(0xFF164863),
                            fontSize: 14,
                            fontFamily: 'Heebo',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 14.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Hours',
                                style: GoogleFonts.heebo(
                                  color: Color(0xFF888888),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                'Minutes',
                                style: GoogleFonts.heebo(
                                  color: Color(0xFF888888),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Hours Input Field
                            Container(
                              width: 55,
                              height: 55,
                              padding: const EdgeInsets.all(8),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1, color: Color(0xFFCFD4DC)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                shadows: [
                                  BoxShadow(
                                    color: Color(0x0C101828),
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: TextFormField(
                                controller: _hourOneController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '0',
                                  hintStyle: GoogleFonts.heebo(
                                    color: Color(0xFFCFD4DC),
                                    fontSize: 32,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: InputBorder.none,
                                ),
                                textAlign: TextAlign.center,
                                validator: _validateTime,
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Container(
                              width: 55,
                              height: 55,
                              padding: const EdgeInsets.all(8),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1, color: Color(0xFFCFD4DC)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                shadows: [
                                  BoxShadow(
                                    color: Color(0x0C101828),
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: TextFormField(
                                controller: _hourTwoController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '0',
                                  hintStyle: GoogleFonts.heebo(
                                    color: Color(0xFFCFD4DC),
                                    fontSize: 32,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: InputBorder.none,
                                ),
                                textAlign: TextAlign.center,
                                validator: _validateTime,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                '-',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: Color(0xFFCFD4DC),
                                  fontSize: 60,
                                  fontWeight: FontWeight.w500,
                                  height: 0.02,
                                ),
                              ),
                            ),
                            // Minutes Input Field
                            Container(
                              width: 55,
                              height: 55,
                              padding: const EdgeInsets.all(8),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1, color: Color(0xFFCFD4DC)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                shadows: [
                                  BoxShadow(
                                    color: Color(0x0C101828),
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: TextFormField(
                                controller: _minuteOneController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '0',
                                  hintStyle: GoogleFonts.heebo(
                                    color: Color(0xFFCFD4DC),
                                    fontSize: 32,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: InputBorder.none,
                                ),
                                textAlign: TextAlign.center,
                                validator: _validateTime,
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Container(
                              width: 55,
                              height: 55,
                              padding: const EdgeInsets.all(8),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1, color: Color(0xFFCFD4DC)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                shadows: [
                                  BoxShadow(
                                    color: Color(0x0C101828),
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: TextFormField(
                                controller: _minuteTwoController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '0',
                                  hintStyle: GoogleFonts.heebo(
                                    color: Color(0xFFCFD4DC),
                                    fontSize: 32,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: InputBorder.none,
                                ),
                                textAlign: TextAlign.center,
                                validator: _validateTime,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //question
              quizList.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      // Add this line
                      physics: const NeverScrollableScrollPhysics(),
                      // Prevents it from scrolling independently
                      itemCount: quizList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            color: Colors.grey[100],
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // The main heading
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  // Aligns delete icon to the right

                                  children: [
                                    Text(
                                      '${index + 1}. ${quizList[index].questionText}',
                                      style: const TextStyle(
                                        color: Color(0xFF164863),
                                        fontSize: 14,
                                        fontFamily: 'IBM Plex Mono',
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          widget.quizList!.removeAt(
                                              index); // Remove the question at the given index
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                // The nested ListView with constrained height
                                SizedBox(
                                  height:
                                      200, // Set a fixed height for the inner ListView
                                  child: ListView.builder(
                                    shrinkWrap: true, // Add this line as well
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: quizList[index].options.length,
                                    itemBuilder: (context, innerIndex) {
                                      return _buildListItem(
                                          '${innerIndex + 1}. ${quizList[index].options[innerIndex]}.');
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'No questions added yet.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(24.0),
          child: CustomElevatedButton(
            height: 55,
            onPressed: _submitQuiz,
            // Submit the form and add the quiz
            text: 'Submit',
            buttonStyle: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF427D9D),
              padding:
                  const EdgeInsets.symmetric(vertical: 14.5, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddQuestion(
                        quizList: quizList,
                      )),
            );
          },
          backgroundColor: const Color(0xFFDDF2FD),
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add,
            color: Color(0xFF164863),
            size: 44,
          ),
        ),
      ),
    );
  }

  // Helper method to build each list item
  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF164863),
              fontSize: 14,
              fontFamily: 'IBM Plex Mono',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
        ),
      ),
    );
  }
}
