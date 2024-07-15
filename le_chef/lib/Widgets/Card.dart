import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CustomCardWithText extends StatelessWidget {
  late final String title;
  late final String subtitle;
  late final String duration;

  CustomCardWithText({required this.title, required this.subtitle, required this.duration});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 80,  // Increased width
            height: 80,  // Increased height
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.image_rounded, size: 60, color: Colors.grey[400]),  // Increased icon size
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xFF164863),
                    fontSize: 16,
                    fontFamily: 'IBM Plex Mono',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Color(0xFF427D9D),
                    fontSize: 14,
                    fontFamily: 'IBM Plex Mono',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '• $duration',
                      style: TextStyle(
                        color: Color(0xFF49454F),
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        height: 0.11,
                        letterSpacing: 0.40,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.lock,
                      size: 20,
                      color: Color(0xFF164863),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

