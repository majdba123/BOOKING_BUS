import 'package:flutter/material.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Journey_Detailes_Page/JourneyAppBar.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Journey_Detailes_Page/JourneyBody.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class JourneyDetailsScreen extends StatefulWidget {
  @override
  _JourneyDetailsScreenState createState() => _JourneyDetailsScreenState();
}

class _JourneyDetailsScreenState extends State<JourneyDetailsScreen> {
  late GoogleMapController mapController;

  final LatLng _initialPosition = LatLng(11.0168, 76.9558); // Coimbatore
  final LatLng _destinationPosition = LatLng(13.0827, 80.2707); // Chennai

  // List of stops with their coordinates
  final List<LatLng> _routeCoordinates = [
    LatLng(11.0168, 76.9558), // Coimbatore
    LatLng(11.004556, 76.961632), // Gandhipuram
    LatLng(12.9165, 79.1325), // Vellore
    LatLng(12.7904, 78.7047), // Ambur
    LatLng(12.8342, 79.7036), // Kanchipuram
    LatLng(13.0827, 80.2707), // Chennai
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JourneyAppBar(),
      body: JourneyBody(
        routeCoordinates: _routeCoordinates,
        initialPosition: _initialPosition,
        destinationPosition: _destinationPosition,
        onMapCreated: (controller) {
          mapController = controller;
        },
      ),
    );
  }
}
