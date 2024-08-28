import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  static void checkLocationPermissions(
    BuildContext context,
    Function(LatLng) setCurrentLocation,
  ) async {
    Location location = Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    getCurrentLocation(setCurrentLocation);
  }

  static void getCurrentLocation(Function(LatLng) setCurrentLocation) async {
    Location location = Location();
    try {
      LocationData currentLocation = await location.getLocation();
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setCurrentLocation(
          LatLng(currentLocation.latitude!, currentLocation.longitude!),
        );
      }
    } catch (e) {
      // Handle errors (e.g., location services are disabled)
    }
  }
}
