import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> dialogWithButtons({
  required BuildContext context,
  required Widget icon,
  required String title,
  required String content,
  required String button1Text,
  required VoidCallback button1Action,
  String? button2Text,
  VoidCallback? button2Action,
}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      // Widget iconWidget;
      // if (icon is IconData) {
      //   iconWidget = Icon(
      //     icon,
      //     color: const Color(0xFF164863),
      //     size: 100,
      //   );
      // } else if (icon is AssetImage) {
      //   iconWidget = Image(
      //     image: icon,
      //     width: 100,
      //     height: 100,
      //   );
      // } else if (icon is Widget) {
      //   iconWidget = SizedBox(
      //     width: 100,
      //     height: 100,
      //     child: icon,
      //   );
      // } else {
      //   iconWidget = const SizedBox(); // Fallback empty widget
      // }
      return AlertDialog(
        icon: icon,
        title: Text(title, style: GoogleFonts.ibmPlexMono(color: Color(0xFF888888),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),),
        content: Text(
          content,
          textAlign: TextAlign.center,
          style: GoogleFonts.ibmPlexMono(
            color: Color(0xFF083344),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (button2Text != null && button2Action != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildButton(button1Text, button1Action, true),
                const SizedBox(width: 20),
                _buildButton(button2Text, button2Action, false),
              ],
            )
          else
            _buildButton(button1Text, button1Action, true, isExpanded: true),
        ],
      );
    },
  );
}


Widget _buildButton(String text, VoidCallback onPressed, bool isPrimary, {bool isExpanded = false}) {
  final buttonWidget = isPrimary
      ? ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF427D9D),
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
      side: const BorderSide(color: Color(0xFF427D9D)),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: Color(0xFF427D9D)),
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Color(0xFF427D9D),
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