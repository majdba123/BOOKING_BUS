import 'package:flutter/material.dart';

class SafetyInformationPopup extends StatelessWidget {
  final VoidCallback onAgreePressed;

  SafetyInformationPopup({required this.onAgreePressed});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenHeight * 0.02),
      ),
      child: Padding(
        padding: EdgeInsets.all(screenHeight * 0.03),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Safety Information',
              style: TextStyle(
                fontSize: screenHeight * 0.025,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Before starting the journey, be sure of the below mentioned SOPs',
              style: TextStyle(
                fontSize: screenHeight * 0.018,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.02),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSafetyPoint(
                    'Follow traffic rules and maintain the speed limits. If limit exceeds, it affects your driving score.',
                    screenHeight,
                    screenWidth),
                _buildSafetyPoint(
                    'Respect the passengers.', screenHeight, screenWidth),
                _buildSafetyPoint(
                    'Greet the passengers.', screenHeight, screenWidth),
                _buildSafetyPoint(
                    'Don’t drive under the influence of alcohol; if found, you’ll be replaced by other drivers.',
                    screenHeight,
                    screenWidth),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAgreePressed,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                      ),
                      backgroundColor: Color(0xFF0A3D5F),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(screenHeight * 0.01),
                      ),
                    ),
                    child: Text(
                      'I agree / Start Journey',
                      style: TextStyle(
                        fontSize: screenHeight * 0.02,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyPoint(
      String text, double screenHeight, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.01),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.circle,
            size: screenHeight * 0.015,
            color: Colors.black54,
          ),
          SizedBox(width: screenWidth * 0.03),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: screenHeight * 0.018,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
