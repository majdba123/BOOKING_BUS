import 'package:flutter/material.dart';
import 'package:mobile_app/screens/Dashborad_Driver/PopUp_widget/SafetyInformationPopup.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Start_Trip_Page/start_journey_screen.dart';

class StartJourneyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _showSafetyInformationPopup(context);
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Color(0xFF0A3D5F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Start Journey',
          style: TextStyle(
            fontSize: screenHeight * 0.025,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showSafetyInformationPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SafetyInformationPopup(
          onAgreePressed: () {
            Navigator.pop(context); // Close the dialog
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StartJourneyScreen(),
              ),
            );
          },
        );
      },
    );
  }
}
