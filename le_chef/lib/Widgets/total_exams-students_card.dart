import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Screens/admin/AddExam.dart';

Widget totalStudent(BuildContext context, String total, String number,
    {String? buttonText}) {
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
                  color: Color(0xFF164863),
                  fontSize: 18,
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
                      color: Color(0xFF164863),
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12,),
          buttonText != null
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AddExam())),
                      child: Row(
                        children: [
                          Text(
                            buttonText,
                            style: GoogleFonts.ibmPlexMono(
                              color: Color(0xFFFBFAFA),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Icon(
                            Icons.add,
                            size: 25,
                            color: Colors.white,
                          )
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF427D9D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    )
                  ],
                )
              : SizedBox.shrink()
        ],
      ),
    ),
  );
}
