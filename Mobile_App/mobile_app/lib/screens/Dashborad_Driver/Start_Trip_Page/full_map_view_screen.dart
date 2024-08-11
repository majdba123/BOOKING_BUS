import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Journey_Detailes_Page/CompleteJourneyPage/JourneyCompletedScreen.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Start_Trip_Page/journey_buttons_widget.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Start_Trip_Page/next_stop_info_widget.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Start_Trip_Page/timeline_tile_widget.dart';

class FullMapViewScreen extends StatefulWidget {
  final LatLng initialPosition;
  final List<LatLng> routeCoordinates;

  FullMapViewScreen({
    required this.initialPosition,
    required this.routeCoordinates,
  });

  @override
  _FullMapViewScreenState createState() => _FullMapViewScreenState();
}

class _FullMapViewScreenState extends State<FullMapViewScreen> {
  bool _showTimeline = true;

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
          // Full-screen Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.initialPosition,
              zoom: 7.5,
            ),
            markers: widget.routeCoordinates
                .map((LatLng position) => Marker(
                      markerId: MarkerId(position.toString()),
                      position: position,
                    ))
                .toSet(),
            polylines: {
              Polyline(
                polylineId: PolylineId('route'),
                points: widget.routeCoordinates,
                color: Color(0xFF0A3D5F),
                width: 4,
              ),
            },
            // myLocationButtonEnabled: false,
            // zoomControlsEnabled: false,
          ),
          // Overlay card at the bottom
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
                  NextStopInfoWidget(
                    showTimeline: _showTimeline,
                    onToggleVisibility: _toggleTimelineVisibility,
                  ),
                  if (_showTimeline) SizedBox(height: screenHeight * 0.02),
                  if (_showTimeline)
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
                          isCurrent: false,
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
                          isCurrent: true,
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
                        // Add more TimelineTileWidget as needed...
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
                          isJourneyComplete: true,
                        ),
                      ],
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
