import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Models/session.dart';
import 'join_meeting.dart';
import 'meeting_not_started.dart';

class BuildBody extends StatefulWidget {
  final String? role;
  final List<Session> sessions_list;
  final bool loading;

  const BuildBody({
    super.key,
    required this.role,
    required this.sessions_list,
    required this.loading,
  });

  @override
  State<BuildBody> createState() => _BuildBodyState();
}

class _BuildBodyState extends State<BuildBody> {
  bool level1 = true;
  bool level2 = false;
  bool level3 = false;

  @override
  Widget build(BuildContext context) {
    if (widget.role == 'admin') {
      return ListView(
        children: [
          ...List.generate(3, (index) {
            bool isActive = index == 0
                ? level1
                : index == 1
                ? level2
                : level3;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Level ${index + 1}',
                        style: GoogleFonts.ibmPlexMono(
                          color: const Color(0xFF164863),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Switch(
                        value: isActive,
                        activeColor: const Color(0xFF00B84A),
                        thumbColor:
                        const MaterialStatePropertyAll(Colors.white),
                        onChanged: (bool value) {
                          if (value) {
                            setState(() {
                              level1 = false;
                              level2 = false;
                              level3 = false;

                              if (index == 0) {
                                level1 = true;
                              } else if (index == 1) {
                                level2 = true;
                              } else {
                                level3 = true;
                              }
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Divider(
                    color: Color(0xFFC6C6C8),
                    thickness: 0.5,
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 20),
          JoinMeeting(
            role: widget.role,
            educationalLevel: level1 ? 1 : level2 ? 2 : 3,
            meetingId: null,
          ),
        ],
      );
    } else {
      if (widget.loading) {
        return const Center(child: CircularProgressIndicator());
      } else if (widget.sessions_list.isNotEmpty) {
        return JoinMeeting(
          role: widget.role,
          educationalLevel: null,
          meetingId: widget.sessions_list.last.zoomMeetingId,
        );
      } else {
        return meetingNotStarted(context);
      }
    }
  }
}