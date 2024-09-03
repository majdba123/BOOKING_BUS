import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/Provider/Driver/Driver.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Start_Trip_Page/full_map_view_screen.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Start_Trip_Page/journey_map_widget.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Journey_Detailes_Page/Breck_Strop_screens/StopDetailsScreen.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Start_Trip_Page/timeline_tile_widget.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class JourneyInfoBox extends StatefulWidget {
  // final LatLng initialPosition;
  // final LatLng destinationPosition;
  final Function(GoogleMapController p1) onMapCreated;

  JourneyInfoBox({
    // required this.routeCoordinates,
    // required this.initialPosition,
    // required this.destinationPosition,
    required this.onMapCreated,
  });

  @override
  State<JourneyInfoBox> createState() => _JourneyInfoBoxState();
}

class _JourneyInfoBoxState extends State<JourneyInfoBox> {
  late List<LatLng> routeCoordinates = [];
  @override
  void initState() {
    super.initState();
    var driverProvider = Provider.of<DriverProvider>(context, listen: false);
    var breaksData = driverProvider.TripDriverDetail?.breaks_data ?? [];
    setState(() {
      routeCoordinates = breaksData
          .map((breakData) => LatLng(
                (breakData.latitude),
                (breakData.longitude),
              ))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    var driverProvider = Provider.of<DriverProvider>(context, listen: false);
    var trip = driverProvider.MyTrip?[driverProvider.indextrip];

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
                '${trip?.Passengers}',
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
                '${trip?.trip_duration} hrs',
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
                '${trip?.Distance} kms',
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
            initialPosition: LatLng(driverProvider.TripDriverDetail!.from_lat,
                driverProvider.TripDriverDetail!.from_long),
            routeCoordinates: routeCoordinates,
            enableOpenMapButton: true,
            onOpenMapPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullMapViewScreen(
                    initialPosition: LatLng(
                        driverProvider.TripDriverDetail!.from_lat,
                        driverProvider.TripDriverDetail!.from_long),
                    routeCoordinates: routeCoordinates,
                    destinationPosition: LatLng(
                        driverProvider.TripDriverDetail!.to_lat,
                        driverProvider.TripDriverDetail!.to_long),
                    stopPlaces: routeCoordinates,
                  ),
                ),
              );
            },
            mapController: widget.onMapCreated,
          ),
          SizedBox(height: screenHeight * 0.02),

          // Timeline of Stops
          Column(
            children: [
              TimelineTileWidget(),
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
