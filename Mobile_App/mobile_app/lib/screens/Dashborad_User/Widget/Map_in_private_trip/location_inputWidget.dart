import 'package:flutter/material.dart';

class LocationInput extends StatefulWidget {
  final TextEditingController originController;
  final TextEditingController destinationController;
  final VoidCallback onUseCurrentLocation;
  final ValueChanged<String> onSearchOrigin;
  final ValueChanged<String> onSearchDestination;

  const LocationInput({
    required this.originController,
    required this.destinationController,
    required this.onUseCurrentLocation,
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

                  widget.onUseCurrentLocation();

                  // Simulate a delay for loading (e.g., waiting for location)
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
            onSubmitted: (query) => widget
                .onSearchOrigin(query), // Search and zoom on origin search
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
            onSubmitted: (query) => widget.onSearchDestination(
                query), // Search and zoom on destination search
            decoration: InputDecoration(
              labelText: 'To',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
