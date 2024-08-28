import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart'; // For accessing the current location

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  LatLng? _origin;
  LatLng? _destination;
  final String _apiKey = 'AIzaSyAeLUpyozCjrCIxNBNmwVfCERYrHZh3MbU';
  LocationData? _currentLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Get the user's current location
  void _getCurrentLocation() async {
    Location location = new Location();
    _currentLocation = await location.getLocation();
    if (_currentLocation != null) {
      setState(() {
        _origin =
            LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
        _originController.text = 'Current Location';
        _markers.add(Marker(
          markerId: MarkerId('current_location'),
          position: _origin!,
          infoWindow: InfoWindow(title: 'Current Location'),
        ));
      });
      _mapController?.animateCamera(CameraUpdate.newLatLng(_origin!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(37.7749, -122.4194),
              zoom: 10,
            ),
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _originController,
                          // readOnly: true, // Prevent user from manually editing
                          onTap:
                              _getCurrentLocation, // Use current location when tapped
                          decoration: InputDecoration(
                            labelText: 'From',
                            prefixIcon: Icon(Icons.my_location),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _destinationController,
                    decoration: InputDecoration(
                      labelText: 'To',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _searchRoute,
                    child: Text('Search'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _searchRoute() async {
    if (_originController.text.isNotEmpty &&
        _destinationController.text.isNotEmpty) {
      final originPlaceId = _originController.text == 'Current Location'
          ? await _getPlaceIdFromLatLng(_origin!)
          : await _getPlaceIdFromAddress(_originController.text);
      final destinationPlaceId =
          await _getPlaceIdFromAddress(_destinationController.text);

      if (originPlaceId != null && destinationPlaceId != null) {
        await _fetchPlaceDetailsAndSetMarker(originPlaceId, true);
        await _fetchPlaceDetailsAndSetMarker(destinationPlaceId, false);
        _fetchAndDrawRoute();
      }
    }
  }

  Future<String?> _getPlaceIdFromAddress(String address) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$address&inputtype=textquery&key=$_apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK' && data['candidates'].isNotEmpty) {
        return data['candidates'][0]['place_id'];
      }
    }
    return null;
  }

  Future<String?> _getPlaceIdFromLatLng(LatLng latLng) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$_apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        return data['results'][0]['place_id'];
      }
    }
    return null;
  }

  Future<void> _fetchPlaceDetailsAndSetMarker(
      String placeId, bool isOrigin) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final result = data['result'];
        final location = result['geometry']['location'];
        final latLng = LatLng(location['lat'], location['lng']);

        setState(() {
          if (isOrigin) {
            _origin = latLng;
            _markers.removeWhere((marker) => marker.markerId.value == 'origin');
            _markers.add(Marker(
              markerId: MarkerId('origin'),
              position: latLng,
              infoWindow: InfoWindow(title: 'From'),
            ));
          } else {
            _destination = latLng;
            _markers.removeWhere(
                (marker) => marker.markerId.value == 'destination');
            _markers.add(Marker(
              markerId: MarkerId('destination'),
              position: latLng,
              infoWindow: InfoWindow(title: 'To'),
            ));
          }
        });
      }
    }
  }

  Future<void> _fetchAndDrawRoute() async {
    if (_origin == null || _destination == null) return;

    final origin = '${_origin!.latitude},${_origin!.longitude}';
    final destination = '${_destination!.latitude},${_destination!.longitude}';

    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&mode=driving&key=$_apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final route = data['routes'][0];
        final polylinePoints = route['overview_polyline']['points'];
        final decodedPoints = _decodePolyline(polylinePoints);

        setState(() {
          _polylines.clear();
          _polylines.add(Polyline(
            polylineId: PolylineId('route'),
            points: decodedPoints,
            color: Colors.blue,
            width: 5,
          ));
        });

        // Adjust camera to show the route
        LatLngBounds bounds = LatLngBounds(
          southwest: LatLng(
            _origin!.latitude < _destination!.latitude
                ? _origin!.latitude
                : _destination!.latitude,
            _origin!.longitude < _destination!.longitude
                ? _origin!.longitude
                : _destination!.longitude,
          ),
          northeast: LatLng(
            _origin!.latitude > _destination!.latitude
                ? _origin!.latitude
                : _destination!.latitude,
            _origin!.longitude > _destination!.longitude
                ? _origin!.longitude
                : _destination!.longitude,
          ),
        );
        _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
      }
    }
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
}
