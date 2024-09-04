import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';

Widget BackButtonToTrip(BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;
  return Padding(
    padding: EdgeInsets.only(
      bottom: screenHeight * 0.02,
      left: screenWidth * 0.04,
      right: screenWidth * 0.04,
    ),
    child: ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.02,
        ),
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        'Back to Trip',
        style: TextStyle(
          fontSize: screenHeight * 0.02,
          color: Colors.white,
        ),
      ),
    ),
  );
}
