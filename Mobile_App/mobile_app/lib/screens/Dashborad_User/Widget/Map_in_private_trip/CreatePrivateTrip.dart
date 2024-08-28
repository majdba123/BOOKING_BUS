import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Map_in_private_trip/location_inputWidget.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Map_in_private_trip/mapWidget.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Map_in_private_trip/search_button.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Map_in_private_trip/services/location_service.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Map_in_private_trip/services/map_service.dart';

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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    LocationService.checkLocationPermissions(context, _setCurrentLocation);
  }

  // Set the user's current location
  void _setCurrentLocation(LatLng location) {
    setState(() {
      _origin = location;
      _originController.text = 'Current Location';
      _markers.add(Marker(
        markerId: MarkerId('current_location'),
        position: _origin!,
        infoWindow: InfoWindow(title: 'Current Location'),
        draggable: true, // Allow marker to be draggable
        onDragEnd: (newPosition) {
          _origin = newPosition;
          _mapController?.animateCamera(CameraUpdate.newLatLng(newPosition));
        },
      ));
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(_origin!, 14.0));
    });
  }

  // Set the destination based on user input
  void _setDestination(LatLng location) {
    setState(() {
      _destination = location;
      _markers.add(Marker(
        markerId: MarkerId('destination_location'),
        position: _destination!,
        infoWindow: InfoWindow(title: 'Destination'),
        draggable: true, // Allow marker to be draggable
        onDragEnd: (newPosition) {
          _destination = newPosition;
          _mapController?.animateCamera(CameraUpdate.newLatLng(newPosition));
        },
      ));
      _mapController
          ?.animateCamera(CameraUpdate.newLatLngZoom(_destination!, 14.0));
    });
  }

  // Search and zoom to a location based on address
  void _searchAndZoom(String query, {required bool isOrigin}) async {
    if (query.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        final mapService = MapService(
            apiKey: 'AIzaSyAeLUpyozCjrCIxNBNmwVfCERYrHZh3MbU'); // Replace with your API key
        final placeId = await mapService.getPlaceIdFromAddress(query);

        if (placeId != null) {
          await mapService.fetchPlaceDetailsAndSetMarker(
            placeId,
            isOrigin,
            (marker) => setState(() {
              if (isOrigin) {
                _origin = marker.position;
              } else {
                _destination = marker.position;
              }
              _markers.add(marker);
              _mapController?.animateCamera(
                CameraUpdate.newLatLngZoom(marker.position, 14.0),
              );
            }),
          );
        }
      } catch (e) {
        // Handle error (e.g., network issues)
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onSearch() async {
    if (_origin != null && _destinationController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
        _polylines.clear(); // Clear existing polylines before drawing a new one
      });

      try {
        final mapService = MapService(
            apiKey: 'YOUR_API_KEY_HERE'); // Replace with your API key
        final originPlaceId = _originController.text == 'Current Location'
            ? await mapService.getPlaceIdFromLatLng(_origin!)
            : await mapService.getPlaceIdFromAddress(_originController.text);
        final destinationPlaceId =
            await mapService.getPlaceIdFromAddress(_destinationController.text);

        if (originPlaceId != null && destinationPlaceId != null) {
          // Set origin marker
          await mapService.fetchPlaceDetailsAndSetMarker(
            originPlaceId,
            true,
            (marker) => setState(() {
              _markers.add(marker);
              _origin = marker.position; // Update origin position
            }),
          );

          // Set destination marker
          await mapService.fetchPlaceDetailsAndSetMarker(
            destinationPlaceId,
            false,
            (marker) => setState(() {
              _markers.add(marker);
              _destination = marker.position; // Update destination position
            }),
          );

          // Draw the route
          await mapService.fetchAndDrawRoute(
            _origin!,
            _destination!,
            (polyline) => setState(() {
              _polylines.add(polyline);
            }),
            _mapController,
          );
        }
      } catch (e) {
        // Handle error (e.g., network issues)
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: LocationInput(
              originController: _originController,
              destinationController: _destinationController,
              onUseCurrentLocation: () => LocationService.getCurrentLocation(
                _setCurrentLocation,
              ),
              onSearchOrigin: (query) => _searchAndZoom(query, isOrigin: true),
              onSearchDestination: (query) =>
                  _searchAndZoom(query, isOrigin: false),
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: Center(child: CircularProgressIndicator()),
            ),
          Positioned(
            right: 16,
            bottom: 150,
            child: SearchButton(
              onSearch: _onSearch,
            ),
          ),
        ],
      ),
    );
  }
}
