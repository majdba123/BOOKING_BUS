import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/Provider/Driver/Driver.dart';
import 'package:provider/provider.dart';

class LatLngHelper {
  static List<LatLng> getBreaksLatLng(BuildContext context) {
    var driverProvider = Provider.of<DriverProvider>(context, listen: false);
    var breaksData = driverProvider.TripDriverDetail?.breaks_data ?? [];

    return breaksData
        .map((breakData) => LatLng(
              breakData.latitude,
              breakData.longitude,
            ))
        .toList();
  }

  static Set<Marker> getBreaksMarkers(BuildContext context) {
    var driverProvider = Provider.of<DriverProvider>(context, listen: false);
    var breaksData = driverProvider.TripDriverDetail?.breaks_data ?? [];

    // Convert the List<LatLng> into a Set<Marker>
    return breaksData
        .map((breakData) => Marker(
              markerId: MarkerId(breakData.break_id
                  .toString()), // Assuming there's an ID or use another unique identifier
              position: LatLng(breakData.latitude, breakData.longitude),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueOrange),
            ))
        .toSet();
  }
}
