import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackBusSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Track your bus',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        SizedBox(height: 8.0),
        Container(
          height: 200.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(12.9715987,
                  77.5945627), // Set the initial location to Bangalore
              zoom: 12,
            ),
            markers: {
              Marker(
                markerId: MarkerId('bus_location'),
                position: LatLng(12.9715987,
                    77.5945627), // Set the marker to the initial location
              ),
            },
          ),
        ),
      ],
    );
  }
}
