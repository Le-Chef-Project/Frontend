import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int? selectedIndex;
  final Function(int) onItemTapped;
  final BuildContext context;

  const CustomBottomNavBar({
    Key? key,
    this.selectedIndex,
    required this.onItemTapped,
    required this.context,
  }) : super(key: key);

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {

  static const Color defaultIconColor = Color(0xFF164863);
  static const Color defaultBackgroundColor = Colors.white;
  static const IconData conversation_bubble = IconData(0xf3fb,
      fontFamily: "CupertinoIcons", fontPackage: 'cupertino_icons');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: defaultBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Container(
                decoration: BoxDecoration(
                  color: widget.selectedIndex == 0
                      ? defaultIconColor
                      : defaultBackgroundColor,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.home_outlined,
                    color: widget.selectedIndex == 0
                        ? defaultBackgroundColor
                        : defaultIconColor),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Container(
                decoration: BoxDecoration(
                  color: widget.selectedIndex == 1
                      ? defaultIconColor
                      : defaultBackgroundColor,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.notifications_none_outlined,
                    color: widget.selectedIndex == 1
                        ? defaultBackgroundColor
                        : defaultIconColor),
              ),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Container(
                decoration: BoxDecoration(
                  color: widget.selectedIndex == 2
                      ? defaultIconColor
                      : defaultBackgroundColor,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8.0),
                child: Icon(conversation_bubble,
                    color: widget.selectedIndex == 2
                        ? defaultBackgroundColor
                        : defaultIconColor),
              ),
              label: 'Messages',
            ),
          ],
          currentIndex: widget.selectedIndex ?? 0,
          selectedItemColor: defaultIconColor,
          unselectedItemColor: defaultIconColor,
          backgroundColor: Colors.transparent,
          elevation: 0,
          onTap: widget.onItemTapped,
        ),
      ),
    );
  }
}