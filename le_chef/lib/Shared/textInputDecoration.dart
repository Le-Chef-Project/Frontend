import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


final textInputDecoration = InputDecoration(
  hintText: '12%fTks,l',
  fillColor: const Color(0xFFFBFAFA),
  filled: true,
  hintStyle: GoogleFonts.ibmPlexMono(
    color: Color(0xFF767B91),
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 0,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: const BorderSide(
      color: Colors.transparent,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: const BorderSide(
      color: Colors.transparent,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: const BorderSide(
      color: Colors.transparent,
    ),
  ),
);
