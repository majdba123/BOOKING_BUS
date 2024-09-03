import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/screens/Dashborad_Driver/Journey_Detailes_Page/CompleteJourneyPage/JourneyCompletedScreen.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Start_Trip_Page/journey_buttons_widget.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Start_Trip_Page/timeline_tile_widget.dart';

class FullMapViewScreen extends StatefulWidget {
  final LatLng initialPosition;
  final LatLng destinationPosition;
  final List<LatLng> stopPlaces;

  FullMapViewScreen({
    required this.initialPosition,
    required this.destinationPosition,
    required this.stopPlaces,
    required List<LatLng> routeCoordinates,
  });

  @override
  _FullMapViewScreenState createState() => _FullMapViewScreenState();
}

class _FullMapViewScreenState extends State<FullMapViewScreen> {
  List<LatLng> _routeCoordinates = [];
  final String _googleAPIKey = 'AIzaSyDd9RLeRSNjmt1AIx22VeWqwbxYh3myC44';
  bool _showTimeline = true;

  @override
  void initState() {
    super.initState();
    _fetchRoute();
  }

  Future<void> _fetchRoute() async {
    final stops = widget.stopPlaces
        .map((stop) => '${stop.latitude},${stop.longitude}')
        .join('|');
    final directionsResponse = await http.get(
      Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${widget.initialPosition.latitude},${widget.initialPosition.longitude}&destination=${widget.destinationPosition.latitude},${widget.destinationPosition.longitude}&waypoints=$stops&mode=driving&key=$_googleAPIKey',
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
          _routeCoordinates = snappedRoute;
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

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.initialPosition,
              zoom: 14.0,
            ),
            markers: {
              Marker(
                markerId: MarkerId('start'),
                position: widget.initialPosition,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
              ),
              Marker(
                markerId: MarkerId('end'),
                position: widget.destinationPosition,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
              ),
              ...widget.stopPlaces.map((stop) => Marker(
                    markerId: MarkerId(stop.toString()),
                    position: stop,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueOrange),
                  )),
            },
            polylines: {
              if (_routeCoordinates.isNotEmpty)
                Polyline(
                  polylineId: PolylineId('route'),
                  points: _routeCoordinates,
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
                      children: widget.stopPlaces.asMap().entries.map((entry) {
                        int index = entry.key;
                        LatLng stop = entry.value;

                        String timeText;
                        String description;
                        String location;
                        bool isFirst = index == 0;
                        bool isLast = index == widget.stopPlaces.length - 1;
                        bool isCurrent = index == 2; // Example for current stop

                        if (isFirst) {
                          timeText = '6:00 AM';
                          description = 'Starting Point';
                          location = 'Coimbatore';
                        } else if (isLast) {
                          timeText = '12:30 PM';
                          description = 'Ending Point';
                          location = 'Chennai';
                        } else if (isCurrent) {
                          timeText = '10:00 AM';
                          description = 'Current Stop';
                          location = 'Vellore';
                        } else {
                          timeText = '10:40 AM';
                          description = 'Stop ${index}';
                          location = 'Location ${index}';
                        }

                        return TimelineTileWidget(
                            // time: timeText,
                            // description: description,
                            // location: location,
                            // up: '${index + 1}',
                            // // down: '${index + 1}',
                            // total: '${index + 1}',
                            // isFirst: isFirst,
                            // isLast: isLast,
                            // isCurrent: isCurrent,
                            // passed: index < 2,
                            );
                      }).toList(),
                    ),
                  SizedBox(height: screenHeight * 0.02),
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
