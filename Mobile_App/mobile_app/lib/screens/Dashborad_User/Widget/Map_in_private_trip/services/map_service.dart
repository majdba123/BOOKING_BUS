import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapService {
  final String apiKey;

  MapService({required this.apiKey});

  Future<String?> getPlaceIdFromAddress(String address) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$address&inputtype=textquery&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK' && data['candidates'].isNotEmpty) {
        return data['candidates'][0]['place_id'];
      }
    }
    return null;
  }

  Future<String?> getPlaceIdFromLatLng(LatLng latLng) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        return data['results'][0]['place_id'];
      }
    }
    return null;
  }

  Future<void> fetchPlaceDetailsAndSetMarker(
    String placeId,
    bool isOrigin,
    Function(Marker) addMarker,
  ) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK' && data['result'] != null) {
        final location = data['result']['geometry']['location'];
        final latLng = LatLng(location['lat'], location['lng']);
        final marker = Marker(
          markerId: MarkerId(isOrigin ? 'origin' : 'destination'),
          position: latLng,
          infoWindow: InfoWindow(title: data['result']['name']),
        );
        addMarker(marker);

        if (isOrigin) {
          // Set origin marker position
        } else {
          // Set destination marker position
        }
      }
    }
  }

  Future<void> fetchAndDrawRoute(
    LatLng origin,
    LatLng destination,
    Function(Polyline) addPolyline,
    GoogleMapController? mapController,
  ) async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
        final points =
            decodePolyline(data['routes'][0]['overview_polyline']['points']);
        final polyline = Polyline(
          polylineId: PolylineId('route'),
          points: points,
          color: Colors.blue,
          width: 5,
        );
        addPolyline(polyline);

        // Zoom map to route bounds
        final bounds = LatLngBounds(
          southwest: LatLng(
            data['routes'][0]['bounds']['southwest']['lat'],
            data['routes'][0]['bounds']['southwest']['lng'],
          ),
          northeast: LatLng(
            data['routes'][0]['bounds']['northeast']['lat'],
            data['routes'][0]['bounds']['northeast']['lng'],
          ),
        );
        mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
      }
    }
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }
}
