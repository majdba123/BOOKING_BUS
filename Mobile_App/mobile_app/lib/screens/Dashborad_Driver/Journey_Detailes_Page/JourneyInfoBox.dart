import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/Provider/Driver/Driver.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Start_Trip_Page/journey_map_widget.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Start_Trip_Page/timeline_tile_widget.dart';
import 'package:provider/provider.dart';

class JourneyInfoBox extends StatefulWidget {
  @override
  State<JourneyInfoBox> createState() => _JourneyInfoBoxState();
}

class _JourneyInfoBoxState extends State<JourneyInfoBox> {
  @override
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

          JourneyMapWidget(),
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
}
