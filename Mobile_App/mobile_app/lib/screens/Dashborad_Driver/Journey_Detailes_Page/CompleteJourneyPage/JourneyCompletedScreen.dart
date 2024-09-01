import 'package:flutter/material.dart';
import 'package:mobile_app/screens/Dashborad_Driver/MainPage/Dashbord.dart';

class JourneyCompletedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0A3D5F),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(screenHeight * 0.04),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: screenHeight * 0.1,
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              Text(
                'Journey Completed Successfully',
                style: TextStyle(
                  fontSize: screenHeight * 0.022,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                'This journey has been completed successfully and here we generated your stats',
                style: TextStyle(
                  fontSize: screenHeight * 0.018,
                  color: Colors.teal,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.05),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DashboardDriver(),
                      )); // Go back to the previous screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0A3D5F), // Button color
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                    horizontal: screenWidth * 0.15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Go back',
                  style: TextStyle(
                    fontSize: screenHeight * 0.018,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
