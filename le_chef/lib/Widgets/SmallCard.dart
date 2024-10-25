import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Smallcard extends StatelessWidget {
  final Function ontap;
  final String Title;
  final String description;
  final String imageurl;
  const Smallcard(
      {super.key,
      required this.Title,
      required this.description,
      required this.imageurl,
      required this.ontap});

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ontap(),
      child: Container(
        width: 273, // Fixed width for each item in the horizontal ListView
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.asset(
                imageurl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Title,
                    style: GoogleFonts.ibmPlexMono(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    description,
                    style: GoogleFonts.ibmPlexMono(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
