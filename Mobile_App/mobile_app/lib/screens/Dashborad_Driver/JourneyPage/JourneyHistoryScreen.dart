import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'JourneyCard.dart';

class JourneyHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.1),
        child: AppBar(
          backgroundColor: AppColors.primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: screenHeight * 0.035),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Journey History',
            style: TextStyle(
              fontSize: screenHeight * 0.03,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: ListView(
          children: [
            SizedBox(height: screenHeight * 0.03),
            // JourneyCard(
            //   from: 'Coimbatore',
            //   to: 'Chennai',
            //   timeLeft: 'DONE',
            //   departureTime: '6:50AM',
            //   arrivalTime: '12:15PM',
            //   stops: '28 Stops',
            //   passengers: '48 Passengers',
            //   bgColor: Colors.white,
            //   tagColor: Colors.green,
            //   fontSize: screenHeight * 0.02,
            //   iconSize: screenHeight * 0.025,
            //   dashColor: Colors.grey,
            //   showArrowIcon: false,
            //   showDetailsButton: false, // Hide the "VIEW DETAILS" button
            // ),
            // SizedBox(height: screenHeight * 0.015),
            // JourneyCard(
            //   from: 'Chennai',
            //   to: 'Bangalore',
            //   timeLeft: 'DONE',
            //   departureTime: '2:30PM',
            //   arrivalTime: '8:15PM',
            //   stops: '15 Stops',
            //   passengers: '35 Passengers',
            //   bgColor: Colors.white,
            //   tagColor: Colors.green,
            //   fontSize: screenHeight * 0.02,
            //   iconSize: screenHeight * 0.025,
            //   dashColor: Colors.grey,
            //   showArrowIcon: false,
            //   showDetailsButton: false, // Hide the "VIEW DETAILS" button
            // ),
            // SizedBox(height: screenHeight * 0.015),
            // JourneyCard(
            //   from: 'Bangalore',
            //   to: 'Mumbai',
            //   timeLeft: 'DONE',
            //   departureTime: '5:00AM',
            //   arrivalTime: '5:00PM',
            //   stops: '20 Stops',
            //   passengers: '60 Passengers',
            //   bgColor: Colors.white,
            //   tagColor: Colors.green,
            //   fontSize: screenHeight * 0.02,
            //   iconSize: screenHeight * 0.025,
            //   dashColor: Colors.grey,
            //   showArrowIcon: false,
            //   showDetailsButton: false, // Hide the "VIEW DETAILS" button
            // ),
          ],
        ),
      ),
    );
  }
}
