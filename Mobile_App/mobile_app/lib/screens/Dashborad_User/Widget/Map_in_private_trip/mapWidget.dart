import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final void Function(GoogleMapController) onMapCreated;

  const MapWidget({
    required this.markers,
    required this.polylines,
    required this.onMapCreated,
  });

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(37.7749, -122.4194),
        zoom: 10,
      ),
      markers: markers,
      polylines: polylines,
      onMapCreated: onMapCreated,
    );
  }
}
