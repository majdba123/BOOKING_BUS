import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/Driver/Driver.dart';
import 'package:mobile_app/screens/Dashborad_Driver/MainPage/FirstTripcard.dart';
import 'package:mobile_app/screens/Dashborad_Driver/MainPage/Headersection.dart';
import 'package:mobile_app/screens/Dashborad_Driver/MainPage/StatsSectionDriver.dart';
import 'package:mobile_app/screens/Dashborad_Driver/MainPage/WelcomeTextSection.dart';
import 'package:mobile_app/screens/WidgetApp/BottomBaronScreen.dart';
import 'package:provider/provider.dart';

class DashboardDriver extends StatefulWidget {
  @override
  State<DashboardDriver> createState() => _DashboardDriverState();
}

class _DashboardDriverState extends State<DashboardDriver> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
      var driverProvider = Provider.of<DriverProvider>(context, listen: false);

      driverProvider.fetchFirstTrip(auth.accessToken);
      driverProvider.fetchRateDriver(auth.accessToken);
      driverProvider.fetchMyBus(auth.accessToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.03),
                HeraderSection(),
                SizedBox(height: screenHeight * 0.03),
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: WelcomeText()),
                SizedBox(height: screenHeight * 0.03),
                FirstTrip(),
                SizedBox(height: screenHeight * 0.03),
                StateSection(),
                SizedBox(height: screenHeight * 0.12),
              ],
            ),
          ),
          buildBottomNavBar(context),
        ],
      ),
    );
  }
}
