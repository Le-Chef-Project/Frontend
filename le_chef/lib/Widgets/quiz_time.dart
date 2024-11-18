import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScrollableTimeInput extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final int maxValue;
  final bool isHour;

  const ScrollableTimeInput({
    Key? key,
    required this.controller,
    this.validator,
    this.onChanged,
    this.maxValue = 9,
    this.isHour = false,
  }) : super(key: key);

  @override
  State<ScrollableTimeInput> createState() => _ScrollableTimeInputState();
}

class _ScrollableTimeInputState extends State<ScrollableTimeInput> {
  late FixedExtentScrollController _scrollController;
  late String currentValue;
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    currentValue = widget.controller.text.isEmpty ? '0' : widget.controller.text;
    _scrollController = FixedExtentScrollController(
      initialItem: int.parse(currentValue),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _updateValue(int value) {
    String newValue = value.toString();
    setState(() {
      currentValue = newValue;
      widget.controller.text = newValue;
    });
    widget.onChanged?.call(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isScrolling = true);
      },
      onTapUp: (_) {
        setState(() => _isScrolling = false);
      },
      child: Container(
        width: 55,
        height: 55,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              color: Color(0xFFCFD4DC),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x0C101828),
              blurRadius: 2,
              offset: Offset(0, 1),
              spreadRadius: 0,
            )
          ],
        ),
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification) {
              setState(() => _isScrolling = false);
            } else if (notification is ScrollStartNotification) {
              setState(() => _isScrolling = true);
            }
            return true;
          },
          child: ListWheelScrollView(
            controller: _scrollController,
            itemExtent: 55,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: _updateValue,
            children: List.generate(
              widget.maxValue + 1,
                  (index) => Container(
                alignment: Alignment.center,
                child: Text(
                  index.toString(),
                  style: GoogleFonts.heebo(
                    color: _isScrolling || index.toString() == currentValue
                        ? const Color(0xFF101828)
                        : const Color(0xFFCFD4DC),
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Example usage in a time picker widget:
class TimePicker extends StatefulWidget {
  const TimePicker({super.key});

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  final TextEditingController _hourOneController = TextEditingController();
  final TextEditingController _hourTwoController = TextEditingController();
  final TextEditingController _minuteOneController = TextEditingController();
  final TextEditingController _minuteTwoController = TextEditingController();

  String? _validateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required';
    }
    int? number = int.tryParse(value);
    if (number == null || number < 0 || number > 9) {
      return 'Invalid';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ScrollableTimeInput(
          controller: _hourOneController,
          validator: _validateTime,
          maxValue: 2,
          isHour: true,
        ),
        const SizedBox(width: 8),
        ScrollableTimeInput(
          controller: _hourTwoController,
          validator: _validateTime,
          maxValue: _hourOneController.text == '2' ? 3 : 9,
          isHour: true,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            ':',
            style: GoogleFonts.heebo(
              fontSize: 32,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ScrollableTimeInput(
          controller: _minuteOneController,
          validator: _validateTime,
          maxValue: 5,
        ),
        const SizedBox(width: 8),
        ScrollableTimeInput(
          controller: _minuteTwoController,
          validator: _validateTime,
          maxValue: 9,
        ),
      ],
    );
  }
}