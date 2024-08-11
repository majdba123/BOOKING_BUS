import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/screens/Dashborad_Driver/JourneyPage/filtter_bar.dart';
import 'package:mobile_app/screens/Dashborad_Driver/JourneyPage/herader_section.dart';
import 'JourneyCard.dart';
import 'toggle_button.dart';
import 'JourneyHistoryScreen.dart'; // Import the new screen

class JourneysScreen extends StatefulWidget {
  @override
  _JourneysScreenState createState() => _JourneysScreenState();
}

class _JourneysScreenState extends State<JourneysScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.1),
        child: AppBar(
          backgroundColor: AppColors.primaryColor,
          leading: Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.04),
            child: Icon(Icons.arrow_back, size: screenHeight * 0.035),
          ),
          title: Text(
            'Journeys',
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
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.03),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to JourneyHistoryScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JourneyHistoryScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppColors.primaryColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.12,
                    vertical: screenHeight * 0.015,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'History',
                  style: TextStyle(
                    fontSize: screenHeight * 0.025,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Expanded(
              child: ListView(
                children: [
                  // Today Section
                  SectionHeader(
                    title: 'Today',
                    fontSize: screenHeight * 0.025,
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  JourneyCard(
                    from: 'Coimbatore',
                    to: 'Chennai',
                    timeLeft: 'IN 4 HOURS',
                    departureTime: '6:50AM',
                    arrivalTime: '12:15PM',
                    stops: '28 Stops',
                    passengers: '48 Passengers',
                    bgColor: Colors.white,
                    tagColor: Colors.redAccent,
                    fontSize: screenHeight * 0.02,
                    iconSize: screenHeight * 0.025,
                    dashColor: Colors.grey,
                    showArrowIcon: true,
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  JourneyCard(
                    from: 'Chennai',
                    to: 'Coimbatore',
                    timeLeft: 'IN 12 HOURS',
                    departureTime: '6:50AM',
                    arrivalTime: '12:15PM',
                    stops: '28 Stops',
                    passengers: '48 Passengers',
                    bgColor: Colors.white,
                    tagColor: Colors.blueAccent,
                    fontSize: screenHeight * 0.02,
                    iconSize: screenHeight * 0.025,
                    dashColor: Colors.grey,
                    showArrowIcon: true,
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  // Tomorrow Section
                  SectionHeader(
                    title: 'Tomorrow',
                    fontSize: screenHeight * 0.025,
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  JourneyCard(
                    from: 'Bangalore',
                    to: 'Chennai',
                    timeLeft: 'TOMORROW',
                    departureTime: '6:50AM',
                    arrivalTime: '12:15PM',
                    stops: '28 Stops',
                    passengers: '48 Passengers',
                    bgColor: Colors.white,
                    tagColor: Colors.greenAccent,
                    fontSize: screenHeight * 0.02,
                    iconSize: screenHeight * 0.025,
                    dashColor: Colors.grey,
                    showArrowIcon: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.1,
          vertical: screenHeight * 0.02,
        ),
        child: FilterBarJorney(
          height: screenHeight * 0.07,
          iconSize: screenHeight * 0.03,
        ),
      ),
    );
  }
}
