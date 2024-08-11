import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Start_Trip_Page/full_map_view_screen.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Start_Trip_Page/journey_map_widget.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Journey_Detailes_Page/Breck_Strop_screens/StopDetailsScreen.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Start_Trip_Page/timeline_tile_widget.dart';
import 'package:timeline_tile/timeline_tile.dart';

class JourneyInfoBox extends StatelessWidget {
  final List<LatLng> routeCoordinates;
  final LatLng initialPosition;
  final LatLng destinationPosition;
  final Function(GoogleMapController p1) onMapCreated;

  JourneyInfoBox({
    required this.routeCoordinates,
    required this.initialPosition,
    required this.destinationPosition,
    required this.onMapCreated,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(screenHeight * 0.015),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Route Summary (Passengers, Duration, Distance)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.people,
                color: Colors.grey,
                size: screenHeight * 0.022,
              ),
              SizedBox(width: screenWidth * 0.01),
              Text(
                '48',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenHeight * 0.018,
                ),
              ),
              SizedBox(width: screenWidth * 0.01),
              Text(
                'Passengers · ',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: screenHeight * 0.018,
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              Icon(
                Icons.access_time,
                color: Colors.grey,
                size: screenHeight * 0.022,
              ),
              SizedBox(width: screenWidth * 0.01),
              Text(
                '7:04 hrs',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: screenHeight * 0.018,
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              Icon(
                Icons.map,
                color: Colors.grey,
                size: screenHeight * 0.022,
              ),
              SizedBox(width: screenWidth * 0.01),
              Text(
                '647 kms',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: screenHeight * 0.018,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),

          // Map and Route Details
          JourneyMapWidget(
            initialPosition: initialPosition,
            routeCoordinates: routeCoordinates,
            enableOpenMapButton: true,
            onOpenMapPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullMapViewScreen(
                    initialPosition: initialPosition,
                    routeCoordinates: routeCoordinates,
                    destinationPosition: destinationPosition,
                    stopPlaces: [
                      LatLng(11.004556, 76.961632), // Gandhipuram
                      LatLng(12.9165, 79.1325), // Vellore
                      LatLng(12.7904, 78.7047), // Ambur
                      LatLng(12.8342, 79.7036), // Kanchipuram
                    ],
                  ),
                ),
              );
            },
            mapController: onMapCreated,
          ),
          SizedBox(height: screenHeight * 0.02),

          // Timeline of Stops
          Column(
            children: [
              TimelineTileWidget(
                time: '10:30 pm',
                description: 'Starting Point',
                location: 'Coimbatore',
                up: '12',
                down: '2',
                total: '12',
                isFirst: true,
                isLast: false,
                isCurrent: true,
                passed: true,
              ),
              TimelineTileWidget(
                time: '10:40 pm',
                description: '',
                location: 'Gandhipuram',
                up: '2',
                down: '4',
                total: '14',
                isFirst: false,
                isLast: false,
                isCurrent: false,
                passed: false,
              ),
              TimelineTileWidget(
                time: '11:00 pm',
                description: '',
                location: 'Gandhipuram',
                up: '4',
                down: '6',
                total: '18',
                isFirst: false,
                isLast: false,
                isCurrent: false,
                passed: false,
              ),
              TimelineTileWidget(
                time: '02:27 am',
                description: '',
                location: 'Vellore',
                up: '-6',
                down: '2',
                total: '14',
                isFirst: false,
                isLast: false,
                isCurrent: false,
                passed: false,
              ),
              TimelineTileWidget(
                time: '03:27 am',
                description: '',
                location: 'Ambur',
                up: '3',
                down: '3',
                total: '17',
                isFirst: false,
                isLast: false,
                isCurrent: false,
                passed: false,
              ),
              TimelineTileWidget(
                time: '04:27 am',
                description: '',
                location: 'Kanchipuram',
                up: '-6',
                down: '6',
                total: '17',
                isFirst: false,
                isLast: false,
                isCurrent: false,
                passed: false,
              ),
              TimelineTileWidget(
                time: '06:30 am',
                description: 'Ending Point',
                location: 'Chennai',
                up: '17',
                down: '0',
                total: '0',
                isFirst: false,
                isLast: true,
                isCurrent: false,
                passed: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  LatLngBounds _getLatLngBounds(List<LatLng> coordinates) {
    double southWestLat =
        coordinates.map((e) => e.latitude).reduce((a, b) => a < b ? a : b);
    double southWestLng =
        coordinates.map((e) => e.longitude).reduce((a, b) => a < b ? a : b);
    double northEastLat =
        coordinates.map((e) => e.latitude).reduce((a, b) => a > b ? a : b);
    double northEastLng =
        coordinates.map((e) => e.longitude).reduce((a, b) => a > b ? a : b);

    return LatLngBounds(
      southwest: LatLng(southWestLat, southWestLng),
      northeast: LatLng(northEastLat, northEastLng),
    );
  }
}
