import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/Provider/Driver/Driver.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Start_Trip_Page/BreakGeolocation.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Start_Trip_Page/full_map_view_screen.dart';
import 'package:provider/provider.dart';

class JourneyMapWidget extends StatelessWidget {
  late GoogleMapController mapController;

  late LatLng initialPosition;

  late LatLng destinationPosition;

  final bool showStopDetails = true;
  final bool enableOpenMapButton = true;

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

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    var driverProvider = Provider.of<DriverProvider>(context, listen: false);

    initialPosition = LatLng(driverProvider.TripDriverDetail!.from_lat,
        driverProvider.TripDriverDetail!.from_long);

    return Stack(
      children: [
        Container(
          height: screenHeight * 0.25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: initialPosition,
                zoom: 7.5,
              ),
              markers: LatLngHelper.getBreaksMarkers(context),
              polylines: {
                Polyline(
                  polylineId: PolylineId('route'),
                  points: LatLngHelper.getBreaksLatLng(context),
                  color: Color(0xFF0A3D5F),
                  width: 4,
                ),
              },
              myLocationButtonEnabled: false,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                controller.animateCamera(
                  CameraUpdate.newLatLngBounds(
                    _getLatLngBounds(LatLngHelper.getBreaksLatLng(context)),
                    50,
                  ),
                );
              },
            ),
          ),
        ),
        if (showStopDetails &&
            enableOpenMapButton) // Conditionally show the button
          Positioned(
            bottom: 0,
            right: 2,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullMapViewScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.map, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Open in Map',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenHeight * 0.018,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
