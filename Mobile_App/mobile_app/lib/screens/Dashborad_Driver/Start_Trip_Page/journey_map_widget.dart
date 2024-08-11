import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class JourneyMapWidget extends StatelessWidget {
  final LatLng initialPosition;
  final List<LatLng> routeCoordinates;
  final Function() onOpenMapPressed;
  final Function(GoogleMapController) mapController;

  JourneyMapWidget({
    required this.initialPosition,
    required this.routeCoordinates,
    required this.onOpenMapPressed,
    required this.mapController,
  });

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
              markers: routeCoordinates
                  .map((LatLng position) => Marker(
                        markerId: MarkerId(position.toString()),
                        position: position,
                      ))
                  .toSet(),
              polylines: {
                Polyline(
                  polylineId: PolylineId('route'),
                  points: routeCoordinates,
                  color: Color(0xFF0A3D5F),
                  width: 4,
                ),
              },
              myLocationButtonEnabled: false,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false, // Hides the + and - controls
              onMapCreated: (GoogleMapController controller) {
                mapController(controller);
                controller.animateCamera(
                  CameraUpdate.newLatLngBounds(
                    _getLatLngBounds(routeCoordinates),
                    50,
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 2,
          child: ElevatedButton(
            onPressed: onOpenMapPressed,
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
