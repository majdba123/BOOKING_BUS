import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/Driver/Driver.dart';
import 'package:mobile_app/screens/Dashborad_Driver/JourneyPage/JourneyCard.dart';
import 'package:provider/provider.dart';

class JourneyHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            var auth = Provider.of<AuthProvider>(context, listen: false);
            var driverProvider =
                Provider.of<DriverProvider>(context, listen: false);
            driverProvider.fetchMyTrip(auth.accessToken);
            driverProvider.setypePage('alltrip');
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Trip History',
          style: TextStyle(
            fontSize: screenHeight * 0.03,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: ListView(
          children: [
            SizedBox(height: screenHeight * 0.03),
            JourneyCard(),
          ],
        ),
      ),
    );
  }
}
