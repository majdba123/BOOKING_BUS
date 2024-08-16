import 'package:flutter/material.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Journey_Detailes_Page/CompleteJourneyPage/JourneyCompletedScreen.dart';

class JourneyButtons extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final bool isJourneyComplete;
  final VoidCallback onEmergencyStopPressed;

  JourneyButtons({
    required this.screenHeight,
    required this.screenWidth,
    required this.isJourneyComplete,
    required this.onEmergencyStopPressed, required Null Function() onEndJourneyPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onEmergencyStopPressed,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02,
                ),
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenHeight * 0.01),
                ),
              ),
              child: Text(
                'Emergency Stop',
                style: TextStyle(
                  fontSize: screenHeight * 0.02,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: ElevatedButton(
              onPressed: isJourneyComplete
                  ? () => _showEndJourneyDialog(context)
                  : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02,
                ),
                backgroundColor:
                    isJourneyComplete ? Colors.green : Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenHeight * 0.01),
                ),
              ),
              child: Text(
                'End Journey',
                style: TextStyle(
                  fontSize: screenHeight * 0.02,
                  color:
                      isJourneyComplete ? Colors.white : Colors.grey.shade700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEndJourneyDialog(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                  'End Journey',
                  style: TextStyle(
                    fontSize: screenHeight * 0.025,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'Are you sure you want to end the journey?',
                  style: TextStyle(
                    fontSize: screenHeight * 0.02,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.02),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.circle,
                          size: screenHeight * 0.015,
                          color: Colors.black54,
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Expanded(
                          child: Text(
                            'Please check every passenger has left the bus.',
                            style: TextStyle(
                              fontSize: screenHeight * 0.02,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.circle,
                          size: screenHeight * 0.015,
                          color: Colors.black54,
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Expanded(
                          child: Text(
                            'Check for any belongings of passengers.',
                            style: TextStyle(
                              fontSize: screenHeight * 0.02,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Navigate to JourneyCompletedScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JourneyCompletedScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                          ),
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              screenHeight * 0.01,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'End Journey',
                              style: TextStyle(
                                fontSize: screenHeight * 0.02,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Icon(Icons.arrow_forward, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black87,
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: screenHeight * 0.02,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
