import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Journey_Detailes_Page/CompleteJourneyPage/JourneyCompletedScreen.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Journey_Detailes_Page/JourneyRouteInfo.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Journey_Detailes_Page/JourneyInfoBox.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Start_Trip_Page/full_map_view_screen.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Start_Trip_Page/journey_buttons_widget.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Start_Trip_Page/timeline_tile_widget.dart';

class StartJourneyScreen extends StatefulWidget {
  @override
  _StartJourneyScreenState createState() => _StartJourneyScreenState();
}

class _StartJourneyScreenState extends State<StartJourneyScreen> {
  late GoogleMapController mapController;

  final LatLng _initialPosition = LatLng(11.0168, 76.9558); // Coimbatore
  final LatLng _destinationPosition = LatLng(13.0827, 80.2707); // Chennai

  final List<LatLng> _routeCoordinates = [
    LatLng(11.0168, 76.9558), // Coimbatore
    LatLng(11.004556, 76.961632), // Gandhipuram
    LatLng(12.9165, 79.1325), // Vellore
    LatLng(12.7904, 78.7047), // Ambur
    LatLng(12.8342, 79.7036), // Kanchipuram
    LatLng(13.0827, 80.2707), // Chennai
  ];

  void _onOpenMapPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullMapViewScreen(
          initialPosition: _initialPosition,
          routeCoordinates: _routeCoordinates,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0A3D5F),
        leading: Icon(Icons.arrow_back, size: screenHeight * 0.03),
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
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        children: [
          SizedBox(height: screenHeight * 0.015),
          // Journey Information Header
          JourneyRouteInfo(
            status: 'ONGOING',
          ),
          SizedBox(height: screenHeight * 0.02),

          // Journey Details Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Journey Details',
                style: TextStyle(
                  fontSize: screenHeight * 0.022,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(Icons.info_outline, color: Colors.grey),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),

          // Map and Route Details
          JourneyInfoBox(
            routeCoordinates: _routeCoordinates,
            initialPosition: _initialPosition,
            destinationPosition: _destinationPosition,
            onMapCreated: (controller) {
              mapController = controller;
            },
          ),
          SizedBox(height: screenHeight * 0.02),

          // Timeline of Stops
          // Column(
          //   children: _buildTimelineTiles(),
          // ),
          SizedBox(height: screenHeight * 0.03),

          // Emergency and End Journey Buttons
          JourneyButtons(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            onEmergencyStopPressed: () {
              // Emergency Stop logic
            },
            onEndJourneyPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JourneyCompletedScreen(),
                ),
              );
            },
            isJourneyComplete: false,
          ),
        ],
      ),
    );
  }
}
