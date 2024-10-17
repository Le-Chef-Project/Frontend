import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:le_chef/Screens/chats.dart';
import 'package:le_chef/Screens/user/payment.dart';
import 'package:le_chef/Shared/customBottomNavBar.dart';
import '../../Shared/custom_app_bar.dart';

import '../notification.dart';
import 'Home.dart';

class AllVid extends StatefulWidget {
  const AllVid({Key? key}) : super(key: key);

  @override
  State<AllVid> createState() => _AllVidState();
}

class _AllVidState extends State<AllVid> {
  bool isLocked = false;
  final List<String> _dropdownItems = ['Today', 'Yesterday'];
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(title: "All Videos"),
        body: ListView.builder(
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: double.infinity,
            decoration: const BoxDecoration(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 23),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today',
                        style: GoogleFonts.ibmPlexMono(
                          color: const Color(0xFF164863),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (index == 0)
                        DropdownButton(
                          dropdownColor: Colors.white,
                          value: _selectedItem,
                          hint: Text(
                            'Filter by date range',
                            style: GoogleFonts.ibmPlexMono(
                              color: const Color(0xFF888888),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_outlined,
                            size: 16,
                            color: Color(0xFF888888),
                          ),
                          items: _dropdownItems
                              .map<DropdownMenuItem<String>>((String val) {
                            return DropdownMenuItem<String>(
                              value: val,
                              child: Text(val),
                            );
                          }).toList(),
                          onChanged: (String? val) {
                            setState(() {
                              _selectedItem = val;
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 32.5,
                  ),
                  SizedBox(
                    height: 600,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 24,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (isLocked) {
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
                                    content: const Text(
                                      'This quiz is locked. You should pay quiz fees',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF083344),
                                        fontSize: 16,
                                        fontFamily: 'IBM Plex Mono',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                                      const PaymentScreen(),
                                                    ),
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                  const Color(0xFF427D9D),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(12),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Pay Fees',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontFamily: 'IBM Plex Mono',
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
                                                  side: const BorderSide(
                                                      color: Color(0xFF427D9D)),
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    side: const BorderSide(
                                                        width: 1,
                                                        color: Color(0xFF427D9D)),
                                                    borderRadius:
                                                    BorderRadius.circular(12),
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
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Card(
                            color: const Color(0xCC888888),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    "https://images.unsplash.com/reserve/bOvf94dPRxWu0u3QsPjF_tree.jpg?ixid=M3wxMjA3fDB8MXxzZWFyY2h8M3x8bmF0dXJhbHxlbnwwfHx8fDE3MjA5MjY0NjR8MA&ixlib=rb-4.0.36",
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                if (isLocked) ...[
                                  const Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: Icon(
                                      Icons.lock,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ],
                                Positioned(
                                  bottom: 10,
                                  left: 12,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Video name',
                                        style: GoogleFonts.ibmPlexMono(
                                          color: const Color(0xFF164863),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        'Unit 1',
                                        style: GoogleFonts.ibmPlexMono(
                                          color: const Color(0xFFDDF2FD),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      bottomNavigationBar: CustomBottomNavBar(
          onItemTapped: (index) {
            switch (index) {
              case 0:
                Get.to(() => const Home(),
                    transition: Transition.fade,
                    duration: const Duration(seconds: 1));

                break;
              case 1:
                Get.to(() => Notifications(),
                    transition: Transition.fade,
                    duration: const Duration(seconds: 1));

                break;
              case 2:
                Get.to(() => const Chats(),
                    transition: Transition.fade,
                    duration: const Duration(seconds: 1));

                break;
            }
          },
          context: context,
        ),
      ),
    );
  }
}
