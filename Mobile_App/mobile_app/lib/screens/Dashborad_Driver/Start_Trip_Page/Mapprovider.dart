import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/config/app_config.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Start_Trip_Page/KalmanFilter.dart';

class MapProvider with ChangeNotifier {
  static const Duration _locationUpdateInterval = Duration(seconds: 30);
  static const Duration _locationRequestTimeLimit = Duration(seconds: 5);
  static const Duration _networkTimeout = Duration(seconds: 15);
  static const double _significantDistanceMeters = 10;

  final List<LatLng> routeCoordinates = [];
  final List<LatLng> trackCoordinates = [];
  final Set<Marker> markers = {};
  final Set<Polyline> polylines = {};

  bool showTimeline = true;

  LatLng _currentLocation = const LatLng(0.0, 0.0);
  LatLng? _previousLocation;
  GoogleMapController? _mapController;
  final KalmanLatLong _kalmanLatLong = KalmanLatLong(3);
  StreamSubscription<Position>? _positionStream;
  bool _restartingLocationStream = false;

  GoogleMapController get mapController {
    final controller = _mapController;
    if (controller == null) {
      throw StateError('GoogleMapController has not been initialized yet.');
    }
    return controller;
  }

  void toggleTimelineVisibility() {
    showTimeline = !showTimeline;
    notifyListeners();
  }

  Future<void> startLocationTracking(
    BuildContext context,
    int busTrip,
    String accessToken,
  ) async {
    await _positionStream?.cancel();
    _positionStream = null;

    final gpsEnabled = await Geolocator.isLocationServiceEnabled();
    if (!gpsEnabled) {
      await _showPermissionDeniedDialog(
        context,
        title: 'Location Services Disabled',
        message: 'Enable location services before starting trip tracking.',
      );
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      await _showPermissionDeniedDialog(
        context,
        title: 'Permission Denied',
        message: 'Location permission is required to track the active trip.',
      );
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      await _showPermissionDeniedForeverDialog(context);
      return;
    }

    _positionStream = Geolocator.getPositionStream(
      locationSettings: AndroidSettings(
        intervalDuration: _locationUpdateInterval,
        timeLimit: _locationRequestTimeLimit,
        accuracy: LocationAccuracy.bestForNavigation,
      ),
    ).listen(
      (position) => _handlePosition(position, busTrip, accessToken),
      onError: (_) => _restartLocationTracking(context, busTrip, accessToken),
      onDone: () => _restartLocationTracking(context, busTrip, accessToken),
      cancelOnError: false,
    );
  }

  Future<void> _handlePosition(
    Position position,
    int busTrip,
    String accessToken,
  ) async {
    final rawLocation = LatLng(position.latitude, position.longitude);
    final now = DateTime.now();

    _kalmanLatLong.process(
      position.latitude,
      position.longitude,
      position.accuracy,
      now.millisecondsSinceEpoch.toDouble(),
    );

    final smoothedLocation = LatLng(
      double.parse(_kalmanLatLong.getLat().toStringAsFixed(5)),
      double.parse(_kalmanLatLong.getLng().toStringAsFixed(5)),
    );

    if (_previousLocation != null &&
        !_hasSignificantChange(_previousLocation!, rawLocation)) {
      return;
    }

    _currentLocation = smoothedLocation;
    _previousLocation = smoothedLocation;

    await _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: smoothedLocation, zoom: 14.0),
      ),
    );

    _updateMarker();

    try {
      await _sendLocationToServer(smoothedLocation, busTrip, accessToken);
    } catch (_) {
      // Tracking should continue if a single network update fails. The caller can
      // surface connectivity state separately without logging sensitive payloads.
    }

    notifyListeners();
  }

  Future<void> _restartLocationTracking(
    BuildContext context,
    int busTrip,
    String accessToken,
  ) async {
    if (_restartingLocationStream) {
      return;
    }

    _restartingLocationStream = true;
    try {
      await Future<void>.delayed(const Duration(seconds: 2));
      if (context.mounted) {
        await startLocationTracking(context, busTrip, accessToken);
      }
    } finally {
      _restartingLocationStream = false;
    }
  }

  Future<void> stopLocationTracking() async {
    await _positionStream?.cancel();
    _positionStream = null;
  }

  bool _hasSignificantChange(LatLng oldLocation, LatLng newLocation) {
    final distance = Geolocator.distanceBetween(
      oldLocation.latitude,
      oldLocation.longitude,
      newLocation.latitude,
      newLocation.longitude,
    );

    return distance > _significantDistanceMeters;
  }

  void _updateMarker() {
    markers.add(
      Marker(
        markerId: MarkerId(
          'currentLocation_${DateTime.now().millisecondsSinceEpoch}',
        ),
        position: _currentLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      ),
    );

    trackCoordinates.add(_currentLocation);
    notifyListeners();
  }

  void updateRoutePolyline() {
    polylines
      ..clear()
      ..add(
        Polyline(
          polylineId: const PolylineId('route'),
          visible: true,
          points: routeCoordinates,
          color: Colors.blue,
          width: 4,
        ),
      );
    notifyListeners();
  }

  Future<void> _sendLocationToServer(
    LatLng position,
    int busTrip,
    String accessToken,
  ) async {
    if (accessToken.isEmpty) {
      throw ArgumentError('A valid access token is required for trip tracking.');
    }

    final url = Uri.parse('${name_domain_server}driver/geolocation/$busTrip');
    final response = await http
        .post(
          url,
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            'lat': position.latitude.toString(),
            'lang': position.longitude.toString(),
          }),
        )
        .timeout(_networkTimeout);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError(
        'Location update failed with HTTP ${response.statusCode}.',
      );
    }
  }

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> fetchRoute(LatLng origin, LatLng destination) async {
    final apiKey = AppConfig.requireGoogleMapsApiKey();
    final url = Uri.https(
      'maps.googleapis.com',
      '/maps/api/directions/json',
      {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'mode': 'driving',
        'key': apiKey,
      },
    );

    final response = await http.get(url).timeout(_networkTimeout);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError(
        'Directions request failed with HTTP ${response.statusCode}.',
      );
    }

    final data = json.decode(response.body) as Map<String, dynamic>;
    final routes = data['routes'];
    if (data['status'] != 'OK' || routes is! List || routes.isEmpty) {
      throw StateError('Google Directions API returned no usable route.');
    }

    final firstRoute = routes.first as Map<String, dynamic>;
    final overviewPolyline =
        firstRoute['overview_polyline'] as Map<String, dynamic>?;
    final encoded = overviewPolyline?['points'];
    if (encoded is! String || encoded.isEmpty) {
      throw StateError('Google Directions API returned an invalid polyline.');
    }

    routeCoordinates
      ..clear()
      ..addAll(_decodePolyline(encoded));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _mapController?.dispose();
    super.dispose();
  }
}

List<LatLng> _decodePolyline(String encoded) {
  final points = <LatLng>[];
  int index = 0;
  int lat = 0;
  int lng = 0;

  while (index < encoded.length) {
    int shift = 0;
    int result = 0;
    int b;

    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);

    lat += (result & 1) != 0 ? ~(result >> 1) : result >> 1;

    shift = 0;
    result = 0;

    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);

    lng += (result & 1) != 0 ? ~(result >> 1) : result >> 1;
    points.add(LatLng(lat / 1E5, lng / 1E5));
  }

  return points;
}

Future<void> _showPermissionDeniedDialog(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

Future<void> _showPermissionDeniedForeverDialog(BuildContext context) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text('Permission Denied Forever'),
      content: const Text(
        'Location permission is permanently denied. Enable it from system settings.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
