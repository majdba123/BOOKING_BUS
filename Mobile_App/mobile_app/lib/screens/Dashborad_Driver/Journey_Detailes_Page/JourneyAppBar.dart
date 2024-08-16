import 'package:flutter/material.dart';

class JourneyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return AppBar(
      backgroundColor: Color(0xFF0A3D5F),
      leading: Icon(Icons.arrow_back, size: screenHeight * 0.03),
      title: Text(
        'Coimbatore to Chennai',
        style: TextStyle(
          color: Colors.white,
          fontSize: screenHeight * 0.025,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
