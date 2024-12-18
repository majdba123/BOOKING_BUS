import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationInput extends StatefulWidget {
  final TextEditingController originController;
  final TextEditingController destinationController;
  final Function(LatLng) onSearchOrigin;
  final Function(LatLng) onSearchDestination;

  const LocationInput({
    required this.originController,
    required this.destinationController,
    required this.onSearchOrigin,
    required this.onSearchDestination,
  });

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  bool _isCurrentLocation = true;
  bool _isLoading = false; // State to manage loading

  void _showLocationChoiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose Location"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<bool>(
                title: Text("Current Location"),
                value: true,
                groupValue: _isCurrentLocation,
                onChanged: (bool? value) {
                  setState(() {
                    _isCurrentLocation = value!;
                    _isLoading = true; // Start loading
                  });

                  // Notify the parent to get the current location
                  widget.onSearchOrigin(LatLng(0,
                      0)); // This should be updated with actual location fetching
                  // Simulate a delay for loading
                  Future.delayed(Duration(seconds: 2), () {
                    setState(() {
                      _isLoading = false; // Stop loading
                      widget.originController.text = 'Current Location';
                    });
                    Navigator.pop(context);
                  });
                },
              ),
              RadioListTile<bool>(
                title: Text("Choose Another Location"),
                value: false,
                groupValue: _isCurrentLocation,
                onChanged: (bool? value) {
                  setState(() {
                    _isCurrentLocation = value!;
                    widget.originController.clear();
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: widget.originController,
            readOnly: _isCurrentLocation,
            onTap: _showLocationChoiceDialog,
            decoration: InputDecoration(
              labelText: 'From',
              prefixIcon: _isLoading
                  ? CircularProgressIndicator() // Show loading indicator
                  : Icon(Icons.my_location),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: widget.destinationController,
            decoration: InputDecoration(
              labelText: 'To',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            onSubmitted: (value) {
              // Trigger search for the destination location
              widget.onSearchDestination(
                  LatLng(0, 0)); // Update with actual location fetching
            },
          ),
        ],
      ),
    );
  }
}
