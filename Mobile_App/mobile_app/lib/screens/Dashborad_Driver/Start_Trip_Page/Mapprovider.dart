import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Start_Trip_Page/KalmanFilter.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';

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
  // KalmanFilter _kalmanFilter = KalmanFilter(0.0, 0.0);
  KalmanLatLong _kalmanLatLong = KalmanLatLong(3);
  DateTime _lastUpdateTime = DateTime.now();

  StreamSubscription<Position>? _positionStream;
  List<double>? _accelerometerValues;
  List<double>? _gyroscopeValues;
  List<double>? _magnetometerValues;

  final double accelerationThreshold = 0.5; // Example threshold for motion
  final double rotationThreshold = 0.1; // Example threshold for rotation

  StreamSubscription<AccelerometerEvent>? _accelerometerStream;
  StreamSubscription<GyroscopeEvent>? _gyroscopeStream;
  StreamSubscription<MagnetometerEvent>? _magnetometerStream;
  Timer? _timer;
  Timer? _locationTimer; // Timer for periodic location updates
  bool _isMotionDetected = false;
  Timer? _motionTimer;
  void toggleTimelineVisibility() {
    showTimeline = !showTimeline;
    notifyListeners();
  }

  // Future<void> track(
  //     BuildContext context, int busTrip, String accessToken) async {
  //   print('in track function');
  //   _accelerometerStream = accelerometerEventStream().listen((event) {
  //     print('in accelerometerEventStream');
  //     _accelerometerValues = <double>[event.x, event.y, event.z];
  //     _checkMotion(context, busTrip, accessToken);
  //   });
  //   // Start listening to gyroscope data
  //   _gyroscopeStream = gyroscopeEventStream().listen((event) {
  //     print('in gyroscopeEventStream ');
  //     _gyroscopeValues = <double>[event.x, event.y, event.z];
  //     _checkMotion(context, busTrip, accessToken);
  //   });

  //   // Start listening to magnetometer data
  //   _magnetometerStream = magnetometerEventStream().listen((event) {
  //     print('in magnetometerEventStream');
  //     _magnetometerValues = <double>[event.x, event.y, event.z];
  //     _checkMotion(context, busTrip, accessToken);
  //   });
  // }

  Future<void> startLocationTracking(
    BuildContext context,
    int busTrip,
    String accessToken,
  ) async {
    if (_positionStream != null) {
      await _positionStream!.cancel();
      _positionStream = null;
    }
    bool gpsEnabled = await Geolocator.isLocationServiceEnabled();
    if (!gpsEnabled) {
      _showPermissionDeniedDialog(context);
      gpsEnabled = await Geolocator
          .isLocationServiceEnabled(); // Re-check GPS status after dialog
      // if (!gpsEnabled) return false;
      // return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showPermissionDeniedDialog(context);
        // return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      await _showPermissionDeniedForeverDialog(context);
      return;
    }
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
      locationSettings: AndroidSettings(
        // forceLocationManager: true,
        intervalDuration: const Duration(seconds: 30),
        timeLimit: const Duration(seconds: 5),
        // timeLimit: Duration(minutes: 1),
        accuracy: LocationAccuracy.bestForNavigation,

        // distanceFilter: 5, // change!! this for number metaer !!!!
      ),
    ).listen(
      (Position position) {
        // if (position.accuracy <= 100) {
        LatLng newLocation = LatLng(position.latitude, position.longitude);
        print(position.accuracy);
        print(
            'Cuurent location: ${newLocation.latitude}, ${newLocation.longitude}');
        DateTime now = DateTime.now();
        double deltaTime = now.difference(_lastUpdateTime).inSeconds.toDouble();
        _lastUpdateTime = now;
        _kalmanLatLong.process(
          position.latitude,
          position.longitude,
          position.accuracy,
          now.millisecondsSinceEpoch.toDouble(),
        );

        LatLng smoothedLocation = LatLng(
          double.parse(_kalmanLatLong.getLat().toStringAsFixed(5)),
          double.parse(_kalmanLatLong.getLng().toStringAsFixed(5)),
        );
        print('the domthoed location after apply kalman  $smoothedLocation');
        print(' the cuuent location in new location :: $newLocation');

        if (_previousLocation == null ||
            // _previousLocation != newLocation ||
            _hasSignificantChange(_previousLocation!, newLocation)) {
          print(' in if contiondtion  body !! ');
          _currentLocation = smoothedLocation;
          _previousLocation = smoothedLocation;

          _mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: smoothedLocation,
                zoom: 14.0,
              ),
            ),
          );
          _updateMarker();
          print(busTrip);
          _sendLocationToServer(smoothedLocation, busTrip, accessToken);

          notifyListeners();
        }
      },
      onError: (error) {
        print('Error: $error');
        // Restart stream on error
        startLocationTracking(context, busTrip, accessToken);
      },
      onDone: () {
        print('Stream has ended.');
        // Restart stream on completion
        startLocationTracking(context, busTrip, accessToken);
      },
    );
  }

  void stopLocationTracking() {
    _positionStream?.cancel();
    _locationTimer
        ?.cancel(); // Cancel the timer when stopping location tracking
  }

  // void _checkMotion(
  //   BuildContext context,
  //   int busTrip,
  //   String accessToken,
  // ) {
  //   print('in check motion function');
  //   if (_isMotionDetected) return;

  //   if (_accelerometerValues != null && _gyroscopeValues != null) {
  //     double accelMagnitude = sqrt(
  //       pow(_accelerometerValues![0], 2) +
  //           pow(_accelerometerValues![1], 2) +
  //           pow(_accelerometerValues![2], 2),
  //     );

  //     double rotationRate = sqrt(
  //       pow(_gyroscopeValues![0], 2) +
  //           pow(_gyroscopeValues![1], 2) +
  //           pow(_gyroscopeValues![2], 2),
  //     );

  //     // Check if the device is moving or rotating significantly
  //     if (accelMagnitude > accelerationThreshold ||
  //         rotationRate > rotationThreshold) {
  //       _isMotionDetected = true;

  //       print('Device is moving. Checking GPS...');
  //       startLocationTracking(context, busTrip, accessToken);
  //       _motionTimer = Timer(Duration(seconds: 40), () {
  //         _isMotionDetected = false;
  //       });
  //     } else {
  //       print('Device is stationary. Skipping GPS update.');
  //     }
  //   }
  // }

  bool _hasSignificantChange(LatLng oldLocation, LatLng newLocation) {
    double distance = Geolocator.distanceBetween(
      oldLocation.latitude,
      oldLocation.longitude,
      newLocation.latitude,
      newLocation.longitude,
    );
    print('the disnatce is :: $distance');
    // // return true;
    // if (distance > 10) {
    //   // Example: Discard location jumps over 1km
    //   print('Location jump too large, discarding update.');
    //   return false;
    // }

    return distance > 10; // Threshold for significant change
  }

  void _updateMarker() {
    // markers.removeWhere((marker) => marker.markerId.value == 'currentLocation');
    // print(markers);
    // Add new marker for the current location
    markers.add(Marker(
      markerId:
          MarkerId('currentLocation_${DateTime.now().millisecondsSinceEpoch}'),
      position: _currentLocation,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ));

    trackCoordinates.add(_currentLocation);
    print(trackCoordinates);
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
    print('set!!');
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

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
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
        content: const Text('Location permission is required to use this app.'),
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
