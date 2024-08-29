import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Map_in_private_trip/LocationProvider.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  bool _isOriginSelected = false;
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Maps with Polyline")),
      body: Stack(
        children: [
          Consumer<LocationProvider>(
            builder: (context, provider, child) {
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target:
                      LatLng(37.77483, -122.41942), // Default to San Francisco
                  zoom: 10,
                ),
                markers: provider.markers,
                polylines: provider.polylines,
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                onTap: (position) {
                  if (!_isOriginSelected) {
                    provider.setOrigin(position);
                    _isOriginSelected = true;
                  } else {
                    provider.setDestination(position);
                  }
                },
              );
            },
          ),
          Positioned(
            top: 10,
            left: 15,
            right: 15,
            child: Column(
              children: [
                _buildSearchBox(
                  hint: 'Enter source location',
                  textEditingController: _sourceController,
                  onSelected: (LatLng location) {
                    _mapController?.animateCamera(
                        CameraUpdate.newLatLngZoom(location, 14));
                  },
                ),
                SizedBox(height: 100),
                if (_isOriginSelected)
                  _buildSearchBox(
                    hint: 'Enter destination location',
                    textEditingController: _destinationController,
                    onSelected: (LatLng location) {
                      _mapController?.animateCamera(
                          CameraUpdate.newLatLngZoom(location, 14));
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox({
    required String hint,
    required TextEditingController textEditingController,
    required Function(LatLng) onSelected,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
      ),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: textEditingController,
        googleAPIKey: "AIzaSyAeLUpyozCjrCIxNBNmwVfCERYrHZh3MbU",
        debounceTime: 800,
        // placeholder: hint,
        itemClick: (prediction) async {
          LatLng selectedLocation = LatLng(
            double.parse(prediction.lat ?? "0.0"),
            double.parse(prediction.lng ?? "0.0"),
          );
          onSelected(selectedLocation);
          textEditingController.text = prediction.description ?? '';
        },
        inputDecoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
