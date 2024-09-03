import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/Provider/Driver/Driver.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Journey_Detailes_Page/CompleteJourneyPage/JourneyCompletedScreen.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Start_Trip_Page/journey_buttons_widget.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Start_Trip_Page/timeline_tile_widget.dart';
import 'package:provider/provider.dart';

class FullMapViewScreen extends StatefulWidget {
  @override
  _FullMapViewScreenState createState() => _FullMapViewScreenState();
}

class _FullMapViewScreenState extends State<FullMapViewScreen> {
  late List<LatLng> routeCoordinates = [];
  final String _googleAPIKey = 'AIzaSyDd9RLeRSNjmt1AIx22VeWqwbxYh3myC44';
  bool _showTimeline = true;
  late LatLng initialPosition;
  late LatLng destinationPosition;
  void initState() {
    super.initState();

    var driverProvider = Provider.of<DriverProvider>(context, listen: false);

    initialPosition = LatLng(driverProvider.TripDriverDetail!.from_lat,
        driverProvider.TripDriverDetail!.from_long);

    destinationPosition = LatLng(driverProvider.TripDriverDetail!.to_lat,
        driverProvider.TripDriverDetail!.to_long);

    _fetchRoute();
  }

  Future<void> _fetchRoute() async {
    final stops = routeCoordinates
        .map((stop) => '${stop.latitude},${stop.longitude}')
        .join('|');
    final directionsResponse = await http.get(
      Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&waypoints=$stops&mode=driving&key=$_googleAPIKey',
      ),
    );

    if (directionsResponse.statusCode == 200) {
      final data = json.decode(directionsResponse.body);

      if (data['routes'] != null && data['routes'].isNotEmpty) {
        final route = data['routes'][0]['overview_polyline']['points'];
        List<LatLng> decodedRoute = _decodePolyline(route);

        // Optionally, snap to roads for more accuracy
        List<LatLng> snappedRoute = await _snapToRoads(decodedRoute);

        setState(() {
          routeCoordinates = snappedRoute;
        });
      }
    } else {
      throw Exception('Failed to load directions');
    }
  }

  Future<List<LatLng>> _snapToRoads(List<LatLng> path) async {
    final pathString =
        path.map((p) => '${p.latitude},${p.longitude}').join('|');

    final snapResponse = await http.get(
      Uri.parse(
        'https://roads.googleapis.com/v1/snapToRoads?path=$pathString&interpolate=true&key=$_googleAPIKey',
      ),
    );

    if (snapResponse.statusCode == 200) {
      final data = json.decode(snapResponse.body);
      if (data['snappedPoints'] != null) {
        List<LatLng> snappedRoute = data['snappedPoints']
            .map<LatLng>((point) => LatLng(
                  point['location']['latitude'],
                  point['location']['longitude'],
                ))
            .toList();
        return snappedRoute;
      }
    }
    // Return original path if snapping fails
    return path;
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble()));
    }

    return points;
  }

  void _toggleTimelineVisibility() {
    setState(() {
      _showTimeline = !_showTimeline;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    var driverProvider = Provider.of<DriverProvider>(context, listen: false);
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: initialPosition,
              zoom: 14.0,
            ),
            markers: {
              Marker(
                markerId: MarkerId('start'),
                position: initialPosition,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
              ),
              Marker(
                markerId: MarkerId('end'),
                position: destinationPosition,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
              ),
              ...routeCoordinates.map((stop) => Marker(
                    markerId: MarkerId(stop.toString()),
                    position: stop,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueOrange),
                  )),
            },
            polylines: {
              if (routeCoordinates.isNotEmpty)
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
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              // Optionally handle map creation
            },
          ),
          // Overlay container at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.all(screenHeight * 0.02),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _toggleTimelineVisibility,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Next Stop: Vellore', // Example for next stop
                          style: TextStyle(
                            fontSize: screenHeight * 0.025,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          _showTimeline
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                          size: screenHeight * 0.035,
                        ),
                      ],
                    ),
                  ),
                  if (_showTimeline) SizedBox(height: screenHeight * 0.02),
                  if (_showTimeline)
                    Column(
                      children: [TimelineTileWidget()],
                    ),
                  SizedBox(height: screenHeight * 0.02),
                  JourneyButtons(
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    onEmergencyStopPressed: () {},
                    onEndJourneyPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JourneyCompletedScreen(),
                        ),
                      );
                    },
                    isJourneyComplete:
                        true, // Ensure this flag is set appropriately
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
