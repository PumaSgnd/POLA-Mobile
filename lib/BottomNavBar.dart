import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final List<String> menuItems;

  const BottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.menuItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      height: 60,
      index: selectedIndex,
      onTap: onItemTapped,
      backgroundColor: Colors.transparent,
      color: const Color(0xff1F2855),
      buttonBackgroundColor: const Color(0xff1F2855),
      animationDuration: const Duration(milliseconds: 700),
      animationCurve: Curves.easeOut,
      items: menuItems.map((String menuItem) {
        return Icon(
          _getIconByMenuItem(menuItem),
          color: Colors.white,
        );
      }).toList(),
    );
  }

  IconData _getIconByMenuItem(String menuItem) {
    switch (menuItem) {
      case 'Home':
        return Icons.home;
      case 'Pemasangan':
        return Icons.build_rounded;
      case 'Penarikan':
        return Icons.remove_shopping_cart;
      case 'Profile':
        return Icons.person_sharp;
      default:
        return Icons.home;
    }
  }
}
