import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'customExamWidgets.dart';

Widget totalStudent(
  BuildContext context,
  String total,
  String number, {
  String? buttonText,
  Function? ontap,
  bool isLibrary = false,
  int? videoslenght,
  int? pdfslenght,
  int? examsslenght,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 16),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x4C427D9D),
            blurRadius: 32.50,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                total,
                style: GoogleFonts.ibmPlexMono(
                  color: const Color(0xFF164863),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              const SizedBox(width: 50),
              Container(
                decoration: ShapeDecoration(
                  color: const Color(0xFFDDF2FD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    number,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ibmPlexMono(
                      color: const Color(0xFF164863),
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (isLibrary)
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  customExamContainer(videoslenght, 'Videos'),
                  customExamContainer(pdfslenght, 'Books'),
                  customExamContainer(pdfslenght, 'PDFs')
                ],
              ),
            ),
          const SizedBox(
            height: 12,
          ),
          if (buttonText != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: ontap != null ? () => ontap() : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF427D9D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        buttonText,
                        style: GoogleFonts.ibmPlexMono(
                          color: const Color(0xFFFBFAFA),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      const Icon(
                        Icons.add,
                        size: 25,
                        color: Colors.white,
                      )
                    ],
                  ),
                )
              ],
            ),
        ],
      ),
    ),
  );
}
