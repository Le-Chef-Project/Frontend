import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Api/apimethods.dart';
import 'package:le_chef/Shared/exams/exams.dart';
import 'package:le_chef/Shared/custom_elevated_button.dart';
import 'package:le_chef/Widgets/dialog_with_two_buttons.dart';
import '../../Models/Quiz.dart';
import '../../Widgets/quiz_time.dart';
import 'AddQuestion.dart';

class AddExam extends StatefulWidget {
  final List<QuizQuestion>? quizList;
  final bool? isPaid;
  final String? examName;
  final String? fees;
  final String? selectedLevel;
  final String? selectedUnit;
  final String? hours;
  final String? minutes;

  const AddExam({
    super.key,
    this.quizList,
    this.isPaid,
    this.examName,
    this.fees,
    this.selectedLevel,
    this.selectedUnit,
    this.hours,
    this.minutes,
  });

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
  List _units = [];
  String? selectedLevel;
  String? selectedUnit;

  @override
  void initState() {
    super.initState();
    getUnits();

    if (widget.isPaid != null) {
      light = widget.isPaid!;
    }
    if (widget.examName != null) {
      titleController.text = widget.examName!;
    }
    if (widget.fees != null) {
      quizFees.text = widget.fees!;
    }
    if (widget.selectedLevel != null) {
      selectedLevel = widget.selectedLevel;
    }
    if (widget.selectedUnit != null) {
      selectedUnit = widget.selectedUnit;
    }
    if (widget.hours != null) {
      var hours = widget.hours!.padLeft(2, '0');
      _hourOneController.text = hours[0];
      _hourTwoController.text = hours[1];
    }
    if (widget.minutes != null) {
      var minutes = widget.minutes!.padLeft(2, '0');
      _minuteOneController.text = minutes[0];
      _minuteTwoController.text = minutes[1];
    }
  }

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

  Future<void> getUnits() async{
    try{
      final units = await ApisMethods.getExamUnits();
      setState(() {
        _units = units;
      });
      print('Total units loaded: ${_units.length}');
    }catch(e){
      print('Error loading units: $e');
    }
  }


  void _submitQuiz() async {
    if (_formKey.currentState!.validate() && titleController.text.isNotEmpty) {
      _updateQuizTime();
      List<Map<String, dynamic>> questions = widget.quizList!.map((quiz) {
        return {
          'question': quiz.questionText,
          'options': quiz.options,
          'answer': quiz.answer,
        };
      }).toList();

      try {
        print('Waiting...');
        await ApisMethods.addQuiz(
          title: titleController.text,
          questions: questions,
          hours: int.tryParse(_hourOneController.text.trim() + _hourTwoController.text.trim()) ?? 0,
          minutes: int.tryParse(_minuteOneController.text.trim() + _minuteTwoController.text.trim()) ?? 0,
          level: int.parse(selectedLevel!.replaceFirst('Level ', '')),
          unit: int.parse(selectedUnit!.replaceFirst('Unit ', '')),
          isPaid: light,
          amountToPay: light ? double.tryParse(quizFees.text) : null,
        );
        print('added...');

        if (mounted) {
          
          dialogWithButtons(context: context, icon: const Icon(
            Icons.check_circle_outline,
            color: Color(0xFF2ED573),
            size: 150,
          ), title: 'Success !', content: 'Exam posted to students.');

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) =>  Exams(selectedLevel: int.parse(selectedLevel!.replaceFirst('Level ', '')),)),
                (Route<dynamic> route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error submitting quiz: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _updateQuizTime() {
    // Get the individual digits
    String hourFirst = _hourOneController.text.trim();
    String hourSecond = _hourTwoController.text.trim();
    String minuteFirst = _minuteOneController.text.trim();
    String minuteSecond = _minuteTwoController.text.trim();

    // Calculate hours and minutes properly
    int hours = 0;
    int minutes = 0;

    // Parse hours if both digits are present
    if (hourFirst.isNotEmpty && hourSecond.isNotEmpty) {
      hours = int.parse(hourFirst + hourSecond);
    } else if (hourFirst.isNotEmpty) {
      hours = int.parse(hourFirst);
    } else if (hourSecond.isNotEmpty) {
      hours = int.parse(hourSecond);
    }

    // Parse minutes if both digits are present
    if (minuteFirst.isNotEmpty && minuteSecond.isNotEmpty) {
      minutes = int.parse(minuteFirst + minuteSecond);
    } else if (minuteFirst.isNotEmpty) {
      // If only first digit is present, multiply by 10 (e.g., 3 becomes 30)
      minutes = int.parse(minuteFirst) * 10;
    } else if (minuteSecond.isNotEmpty) {
      // If only second digit is present, use it as is
      minutes = int.parse(minuteSecond);
    }

    // Validate minutes
    if (minutes >= 60) {
      // Add overflow to hours
      hours += minutes ~/ 60;
      minutes = minutes % 60;
    }

    // Close the dialog
    Navigator.pop(context);

  }

  String? _validateTime(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Allow empty values as we'll handle them in _updateQuizTime
    }
    final int? digit = int.tryParse(value);
    if (digit == null || digit < 0 || digit > 9) {
      return 'Enter 0-9';
    }
    return null;
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
                                  color: const Color(0xFF164863),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 50),
                              Switch(
                                value: light,
                                activeColor: const Color(0xFF00B84A),
                                thumbColor:
                                    const WidgetStatePropertyAll(Colors.white),
                                onChanged: (bool value) {
                                  setState(() {
                                    light = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 25),
                        Expanded(
                          child: Text(
                            'Exam name',
                            style: GoogleFonts.ibmPlexMono(
                              color: const Color(0xFF164863),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: ShapeDecoration(
                              color: const Color(0xFFFBFAFA),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: TextFormField(
                              controller: quizFees,
                              enabled: light,
                              style: GoogleFonts.ibmPlexMono(
                                color: light ? const Color(0xFF164863) : Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                hintText: 'amount to pay',
                                hintStyle: GoogleFonts.ibmPlexMono(
                                  color:
                                      light ? const Color(0xFF164863) : Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
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
                                fillColor: const Color(0xFFFBFAFA),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            decoration: ShapeDecoration(
                              color: const Color(0xFFFBFAFA),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: TextFormField(
                              controller: titleController,
                              enabled: true,
                              style: GoogleFonts.ibmPlexMono(
                                color: const Color(0xFF164863),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                hintText: 'write exam name',
                                hintMaxLines: 2,
                                hintStyle: GoogleFonts.ibmPlexMono(
                                  color: const Color(0xFF164863),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
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
                                fillColor: const Color(0xFFFBFAFA),
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
                            color: const Color(0xFF164863),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                        Expanded(
                            child: Text(
                          'Choose Unit',
                          style: GoogleFonts.ibmPlexMono(
                            color: const Color(0xFF164863),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ))
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            child: DropdownMenu(
                          hintText: 'Select Level',
                          textStyle: const TextStyle(
                            color: Color(0xFF667084),
                            fontSize: 12,
                            fontFamily: 'IBM Plex Mono',
                            fontWeight: FontWeight.w400,
                          ),
                          menuStyle: MenuStyle(
                            backgroundColor:
                                const WidgetStatePropertyAll(Colors.white),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          onSelected: (String? value) {
                            setState(() {
                              selectedLevel = value;
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
                              borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF164863)),
                            ),
                          ),
                          dropdownMenuEntries: levels
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                                value: value,
                                label: value,
                                style: MenuItemButton.styleFrom(
                                    textStyle: GoogleFonts.ibmPlexMono(
                                  color: const Color(0xFF0F1728),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                )));
                          }).toList(),
                        )),
                        Expanded(
                            child: DropdownMenu(
                          hintText: 'Select unit',
                          textStyle: const TextStyle(
                            color: Color(0xFF667084),
                            fontSize: 12,
                            fontFamily: 'IBM Plex Mono',
                            fontWeight: FontWeight.w400,
                          ),
                          menuStyle: MenuStyle(
                            backgroundColor:
                                const WidgetStatePropertyAll(Colors.white),
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
                              borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF164863)),
                            ),
                          ),
                          dropdownMenuEntries: [
                            ..._units
                                .map<DropdownMenuEntry<String>>((dynamic value) {
                              return DropdownMenuEntry<String>(
                                  value: value,
                                  label: value,
                                  style: MenuItemButton.styleFrom(
                                      textStyle: GoogleFonts.ibmPlexMono(
                                    color: const Color(0xFF0F1728),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  )));
                            }).toList(),
                            DropdownMenuEntry<String>(
                              value: 'add_new',
                              label: 'Add Unit',
                              enabled: false,
                              style: MenuItemButton.styleFrom(
                                  backgroundColor: const Color(0xFFDDF2FD),
                                  padding: const EdgeInsets.all(8),
                                  textStyle: GoogleFonts.ibmPlexMono(
                                    color: Colors.transparent,
                                    fontSize: 0,
                                  )),
                              leadingIcon: SizedBox(
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
                                            color: const Color(0xFF164863),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        style: GoogleFonts.ibmPlexMono(
                                          color: const Color(0xFF0F1728),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        onFieldSubmitted: (value) {
                                          if (value.isNotEmpty) {
                                            setState(() {
                                              _units.add(value);
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
                                    padding: const EdgeInsets.all(8),
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
                                          _units.add(value);
                                          addController.clear();
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF427D9D),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14.5, horizontal: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Add Unit',
                                      style: TextStyle(color: Colors.white),
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
                    color: const Color(0xFFFBFAFA),
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
                                  color: const Color(0xFF888888),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                'Minutes',
                                style: GoogleFonts.heebo(
                                  color: const Color(0xFF888888),
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
                            ScrollableTimeInput(
                              controller: _hourOneController,
                              validator: _validateTime,
                              maxValue: 9, // For first minute digit
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            ScrollableTimeInput(
                              controller: _hourTwoController,
                              validator: _validateTime,
                              maxValue: 9, // For first minute digit
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                '-',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFFCFD4DC),
                                  fontSize: 60,
                                  fontWeight: FontWeight.w500,
                                  height: 0.02,
                                ),
                              ),
                            ),
                            // Minutes Input Field
                            ScrollableTimeInput(
                              controller: _minuteOneController,
                              validator: _validateTime,
                              maxValue: 6, // For first minute digit
                            ),

                            const SizedBox(
                              width: 12,
                            ),
                            ScrollableTimeInput(
                              controller: _minuteTwoController,
                              validator: _validateTime,
                              maxValue: 9, // For first minute digit
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
                                    physics: const NeverScrollableScrollPhysics(),
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
            onPressed: ()
            => dialogWithButtons(context: context, icon: const Icon(Icons.error_outline_rounded,
              color: Color(0xFF164863),
              size: 150,),
              title: 'Are you sure you finish putting Exam ?', 
              button1Text: 'Finish Exam', 
              button1Action: _submitQuiz, 
              button2Text: 'Cancel',
              button2Action: () => Navigator.pop(context)),
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
                  isPaid: light,
                  examName: titleController.text,
                  fees: quizFees.text,
                  selectedLevel: selectedLevel,
                  selectedUnit: selectedUnit,
                  hours: "${_hourOneController.text}${_hourTwoController.text}",
                  minutes: "${_minuteOneController.text}${_minuteTwoController.text}",
                ),
              ),
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
