import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:mobile_app/constants.dart';

class MapProvider with ChangeNotifier {
  List<LatLng> routeCoordinates = [];
  List<LatLng> trackCoordinates = [];
  bool showTimeline = true;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  LatLng _currentLocation = LatLng(0.0, 0.0);
  LatLng? _previousLocation;
  late GoogleMapController _mapController;
  GoogleMapController get mapController => _mapController;

  StreamSubscription<Position>? _positionStream;

  Timer? _timer;
  Timer? _locationTimer; // Timer for periodic location updates

  Future<void> startLocationTracking(
    BuildContext context,
    int busTrip,
    String accessToken,
  ) async {
    bool gpsEnabled = await Geolocator.isLocationServiceEnabled();
    if (!gpsEnabled) {
      _showPermissionDeniedDialog(context);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    await Geolocator.requestPermission();

    // if (permission == LocationPermission.denied ||
    //     permission == LocationPermission.deniedForever) {
    //   permission =
    //   if (permission == LocationPermission.denied) {
    //     _showPermissionDeniedDialog(context);
    //     return;
    //   }
    // }

    print('in startLocationTracking function ');

    // Start listening to location updates
    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        // timeLimit: Duration(minutes: 1),
        accuracy: LocationAccuracy.high,
        distanceFilter: 30, // change!! this for number metaer !!!!
      ),
    ).listen((Position position) {
      LatLng newLocation = LatLng(position.latitude, position.longitude);
      print(
          'Cuurent location: ${newLocation.latitude}, ${newLocation.longitude}');

      if (_previousLocation == null || _previousLocation != newLocation
          // ||
          // _hasSignificantChange(_previousLocation!, newLocation)

          ) {
        print(' in if body !! ');

        _currentLocation = newLocation;
        // routeCoordinates.add(newLocation);
        _previousLocation = newLocation;

        _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 14.0,
            ),
          ),
        );
        _updateMarker();
        // _updatePolyline();
        print(busTrip);
        _sendLocationToServer(newLocation, busTrip, accessToken);

        // Update map camera position
        // _mapController.animateCamera(
        //   CameraUpdate.newLatLng(_currentLocation),
        // );

        // Notify listeners for UI updates
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
        // });
      }
    });
  }

  void stopLocationTracking() {
    _positionStream?.cancel();
    _locationTimer
        ?.cancel(); // Cancel the timer when stopping location tracking
  }

  bool _hasSignificantChange(LatLng oldLocation, LatLng newLocation) {
    double distance = Geolocator.distanceBetween(
      oldLocation.latitude,
      oldLocation.longitude,
      newLocation.latitude,
      newLocation.longitude,
    );
    // return true;
    return distance > 20; // Threshold for significant change
  }

  void _updateMarker() {
    // Remove only the previous marker for the current location (if it exists)
    // markers.removeWhere((marker) => marker.markerId.value == 'currentLocation');

    // Add new marker for the current location
    markers.add(Marker(
      markerId:
          MarkerId('currentLocation_${DateTime.now().millisecondsSinceEpoch}'),
      position: _currentLocation,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ));

    trackCoordinates.add(_currentLocation);

    // print(markers);
    notifyListeners();
  }

  void _updatePolyline() {
    polylines.clear();
    polylines.add(Polyline(
      polylineId: PolylineId('route'),
      visible: true,
      points: routeCoordinates,
      color: Colors.blue,
      width: 4,
    ));
  }

  Future<void> _sendLocationToServer(
      LatLng position, int busTrip, String accessToken) async {
    final url = Uri.parse(name_domain_server + 'driver/geolocation/$busTrip');
    print(
        'Sending location to server: ${position.latitude}, ${position.longitude}');

    var res = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken', // Add the Authorization header
        'Content-Type': 'application/json', // Ensure proper content type
      },
      body: jsonEncode({
        'lat': position.latitude.toString(),
        'lang': position.longitude.toString(),
      }),
    );

    print(res.statusCode);
    print(res.body);
  }

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> fetchRoute(LatLng origin, LatLng destination) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json'
      '?origin=${origin.latitude},${origin.longitude}'
      '&destination=${destination.latitude},${destination.longitude}'
      '&mode=driving'
      '&key=AIzaSyDd9RLeRSNjmt1AIx22VeWqwbxYh3myC44', // Replace with your Google API key
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'] != null && data['routes'].isNotEmpty) {
        final route = data['routes'][0]['overview_polyline']['points'];
        routeCoordinates = _decodePolyline(route);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      } else {
        throw Exception('No routes found');
      }
    } else {
      throw Exception('Failed to load route');
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

  Future<void> _showPermissionDeniedDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permission Denied'),
          content:
              const Text('Location permission is required to use this app.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showPermissionDeniedForeverDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permission Denied Forever'),
          content: const Text(
              'Location permission is permanently denied. Please enable it from settings.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void toggleTimelineVisibility() {
    showTimeline = !showTimeline;
    notifyListeners();
  }
}
