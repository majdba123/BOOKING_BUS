import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: Color(0xFF003144)),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard, color: Color(0xFF003144)),
          label: 'Menu',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: Color(0xFF003144)),
          label: 'Profile',
        ),
      ],
      selectedItemColor: Color(0xFF003144),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
    );
  }
}
