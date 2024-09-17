import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Start_Trip_Page/BreakGeolocation.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Start_Trip_Page/Mapprovider.dart';
import 'package:provider/provider.dart';

class TrackBusSection extends StatefulWidget {
  @override
  State<TrackBusSection> createState() => _TrackBusSectionState();
}

class _TrackBusSectionState extends State<TrackBusSection> {
  @override
  Widget build(BuildContext context) {
    var provider = context.read<TripuserProvider>();
    final initialPosition = LatLng(
      provider.LocationOfRservation[0].latitude,
      provider.LocationOfRservation[0].longitude,
    );
    var mapProvider = Provider.of<MapProvider>(context, listen: false);

    late GoogleMapController mapController;

    final destinationPosition = LatLng(
      provider.LocationOfRservation[provider.LocationOfRservation.length - 1]
          .latitude,
      provider.LocationOfRservation[provider.LocationOfRservation.length - 1]
          .longitude,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mapProvider.fetchRoute(initialPosition, destinationPosition);
    });
    return Consumer<MapProvider>(
      builder: (context, mapProvider, child) {
        
        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: initialPosition,
            zoom: 14.0,
          ),
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
            controller.animateCamera(
              CameraUpdate.newLatLngBounds(
                LatLngBounds(
                  southwest: initialPosition,
                  northeast: destinationPosition,
                ),
                50,
              ),
            );
          },
          markers: {
            Marker(
              markerId: MarkerId('start'),
              position: initialPosition,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
            ),
            Marker(
              markerId: MarkerId('end'),
              position: destinationPosition,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
            ),
            ...LatLngHelper.getBreaksMarkersOfRservation(context),
          },
          polylines: {
            Polyline(
              polylineId: PolylineId('route'),
              points: mapProvider.routeCoordinates,
              color: Colors.red,
              width: 5,
            ),
          },
          myLocationButtonEnabled: true,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: false,
        );
      },
    );
  }
}
