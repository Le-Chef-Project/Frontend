import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> dialogWithButtons({
  required BuildContext context,
  required Widget icon,
  required String title,
  String? content,
  String? button1Text,
  VoidCallback? button1Action,
  String? button2Text,
  VoidCallback? button2Action,
  Color? buttonColor,
  Color? outlineButtonColor
}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        icon: icon,
        title:Text(title, style: GoogleFonts.ibmPlexMono(color: Color(0xFF164863),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        ),
        content: content != null ? Text(
          content,
          textAlign: TextAlign.center,
          style: GoogleFonts.ibmPlexMono(
            color: Color(0xFF888888),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ) : SizedBox.shrink(),
        actions: [
          if(button1Text != null && button1Action != null)
          if (button2Text != null && button2Action != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildButton(button1Text, button1Action, true, buttonColor: buttonColor != null ? buttonColor :  const Color(0xFF427D9D), outlineButtonColor: outlineButtonColor != null ? outlineButtonColor : const Color(0xFF427D9D)),
                const SizedBox(width: 20),
                _buildButton(button2Text, button2Action, false, buttonColor: buttonColor != null ? buttonColor :  const Color(0xFF427D9D), outlineButtonColor: outlineButtonColor != null ? outlineButtonColor : const Color(0xFF427D9D)),
              ],
            )
          else
            _buildButton(button1Text, button1Action, true, isExpanded: true, buttonColor: buttonColor != null ? buttonColor :  const Color(0xFF427D9D), outlineButtonColor: outlineButtonColor != null ? outlineButtonColor : const Color(0xFF427D9D)),
        ],
      );
    },
  );
}


Widget _buildButton(String text, VoidCallback onPressed, bool isPrimary, {bool isExpanded = false, Color buttonColor =  const Color(0xFF427D9D), Color outlineButtonColor = const Color(0xFF427D9D)}) {
  final buttonWidget = isPrimary
      ? ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: buttonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontFamily: 'IBM Plex Mono',
        fontWeight: FontWeight.w600,
        height: 0,
      ),
    ),
  )
      : OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: outlineButtonColor),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1, color: outlineButtonColor),
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: outlineButtonColor,
        fontSize: 16,
        fontFamily: 'IBM Plex Mono',
        fontWeight: FontWeight.w600,
        height: 0,
      ),
    ),
  );

  return isExpanded
      ? SizedBox(width: double.infinity, height: 48, child: buttonWidget)
      : Expanded(child: SizedBox(width: 140.50, height: 48, child: buttonWidget));
}