import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Data_Models/Driver/TripForDriver.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/Driver/Driver.dart';
import 'package:mobile_app/screens/Dashborad_Driver/JourneyPage/herader_section.dart';
import 'package:mobile_app/screens/WidgetApp/filtter_Bar_main_ui.dart';
import 'package:provider/provider.dart';
import 'JourneyCard.dart';
import 'JourneyHistoryScreen.dart';

class JourneysScreen extends StatefulWidget {
  @override
  _JourneysScreenState createState() => _JourneysScreenState();
}

class _JourneysScreenState extends State<JourneysScreen> {
  void initState() {
    super.initState();
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
    Provider.of<DriverProvider>(context, listen: false)
        .fetchMyTrip(auth.accessToken);
  }

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

            // SectionHeader(
            //   title: 'Today',
            //   fontSize: screenHeight * 0.025,
            // ),
            Expanded(
              child: ListView(
                children: [JourneyCard()],
              ),
            ),

            SizedBox(height: screenHeight * 0.015),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.1,
          vertical: screenHeight * 0.01,
        ),
        child: FilterBarUserUi(
          height: screenHeight * 0.07,
          iconSize: screenHeight * 0.03,
        ),
      ),
    );
  }
}
