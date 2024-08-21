import 'package:flutter/material.dart';

class JourneyDetailsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Text(
      'Journey Details',
      style: TextStyle(
        fontSize: screenHeight * 0.022,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
