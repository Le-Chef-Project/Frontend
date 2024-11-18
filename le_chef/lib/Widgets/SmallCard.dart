import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Screens/user/payment.dart';

class Smallcard extends StatelessWidget {
  final Function ontap;
  final String? Title;
  final String? description;
  final String imageurl;
  final bool isLocked;
  const Smallcard({
    super.key,
    this.Title,
    this.description,
    required this.imageurl,
    required this.ontap,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {if (isLocked) {
      showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Icon(
            Icons.lock_outline,
            color: Color(0xFF164863),
            size: 100,
          ),
          content: Text(
            'This Video is locked.. You should pay Video fees',
            textAlign: TextAlign.center,
            style: GoogleFonts.ibmPlexMono(
              color: const Color(0xFF083344),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: 140.50,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const PaymentScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF427D9D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Pay Fees',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.ibmPlexMono(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: SizedBox(
                      width: 140.50,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          side:
                          const BorderSide(color: Color(0xFF427D9D)),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Color(0xFF427D9D)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF427D9D),
                            fontSize: 16,
                            fontFamily: 'IBM Plex Mono',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    )
  }else ontap()} ,
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
                  if (Title != null)
                    Text(
                      Title!,
                      style: GoogleFonts.ibmPlexMono(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  if (description != null)
                    Text(
                      description!,
                      style: GoogleFonts.ibmPlexMono(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                ],
              ),
            ),
            if (isLocked) const Positioned(bottom: 75, right: 10,child: Icon(Icons.lock_outline, color: Color(0xFF164863))),
          ],
        ),
      ),
    );
  }
}
