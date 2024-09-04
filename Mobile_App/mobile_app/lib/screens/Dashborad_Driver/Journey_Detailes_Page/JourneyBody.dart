import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Journey_Detailes_Page/JourneyDetailsHeader.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Journey_Detailes_Page/JourneyInfoBox.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Journey_Detailes_Page/JourneyRouteInfo.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Journey_Detailes_Page/StartJourneyButton.dart';

class JourneyBody extends StatelessWidget {
  // final Function(GoogleMapController) onMapCreated;

  // JourneyBody({
  //   required this.onMapCreated,
  // });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      children: [
        SizedBox(height: 15.0),
        JourneyRouteInfo(),
        SizedBox(height: screenHeight * 0.02),
        JourneyDetailsHeader(),
        SizedBox(height: screenHeight * 0.02),
        JourneyInfoBox(),
        SizedBox(height: screenHeight * 0.03),
        StartJourneyButton(),
      ],
    );
  }
}
