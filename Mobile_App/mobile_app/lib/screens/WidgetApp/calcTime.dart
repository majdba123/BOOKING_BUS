import 'package:flutter/material.dart';

class TripTimeDifference extends StatelessWidget {
  final String tripTimeString;

  TripTimeDifference({required this.tripTimeString});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    DateTime tripTime = DateTime.parse(tripTimeString);

    DateTime now = DateTime.now();

    Duration difference = tripTime.difference(now);
    double hoursDifference =
        difference.inHours + (difference.inMinutes.remainder(60) / 60);

    return Text(
      hoursDifference.toStringAsFixed(0),
      style: TextStyle(
        fontSize: screenHeight * 0.055,
        fontWeight: FontWeight.bold,
        color: Color(0xFF4267B2),
      ),
    );
  }
}
