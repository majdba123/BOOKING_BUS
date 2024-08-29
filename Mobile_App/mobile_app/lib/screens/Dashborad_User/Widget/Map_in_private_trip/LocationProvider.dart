import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider extends ChangeNotifier {
  LatLng? _origin;
  LatLng? _destination;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  LatLng? get origin => _origin;
  LatLng? get destination => _destination;
  Set<Marker> get markers => _markers;
  Set<Polyline> get polylines => _polylines;

  void setOrigin(LatLng position) {
    _origin = position;
    _markers.add(Marker(markerId: MarkerId('origin'), position: position));
    notifyListeners();
  }

  void setDestination(LatLng position) {
    _destination = position;
    _markers.add(Marker(markerId: MarkerId('destination'), position: position));
    _drawPolyline();
    notifyListeners();
  }

  void _drawPolyline() {
    if (_origin != null && _destination != null) {
      _polylines.add(Polyline(
        polylineId: PolylineId('route'),
        points: [_origin!, _destination!],
        color: Colors.blue,
        width: 5,
      ));
    }
  }
}
