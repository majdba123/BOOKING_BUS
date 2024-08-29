// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:mobile_app/screens/Dashborad_User/Widget/Map_in_private_trip/location_inputWidget.dart';
// import 'package:mobile_app/screens/Dashborad_User/Widget/Map_in_private_trip/mapWidget.dart';
// import 'package:mobile_app/screens/Dashborad_User/Widget/Map_in_private_trip/search_button.dart';
// import 'package:mobile_app/screens/Dashborad_User/Widget/Map_in_private_trip/services/location_service.dart';
// import 'package:mobile_app/screens/Dashborad_User/Widget/Map_in_private_trip/services/map_service.dart';

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final _originController = TextEditingController();
//   final _destinationController = TextEditingController();
//   GoogleMapController? _mapController;
//   Set<Marker> _markers = {};
//   Set<Polyline> _polylines = {};
//   LatLng? _origin;
//   LatLng? _destination;
//   bool _isOriginSelected = false;

//   final CameraPosition _initialCameraPosition = CameraPosition(
//     target:
//         LatLng(37.7749, -122.4194), // Default position (e.g., San Francisco)
//     zoom: 10.0, // Default zoom level
//   );

//   void _setMarker(LatLng position, bool isOrigin) {
//     setState(() {
//       if (isOrigin) {
//         _origin = position;
//         _markers.add(Marker(
//           markerId: MarkerId('origin'),
//           position: _origin!,
//           infoWindow: InfoWindow(title: 'Source'),
//         ));
//       } else {
//         _destination = position;
//         _markers.add(Marker(
//           markerId: MarkerId('destination'),
//           position: _destination!,
//           infoWindow: InfoWindow(title: 'Destination'),
//         ));
//       }

//       _mapController?.animateCamera(CameraUpdate.newLatLng(position));

//       if (_origin != null && _destination != null) {
//         _drawRoute();
//       }
//     });
//   }

//   void _drawRoute() async {
//     setState(() {
//       _polylines.clear();
//     });

//     final mapService = MapService(apiKey: 'AIzaSyCeL6NXSWQJcyl0SjF3CZ0-3vN3q90aGc8');
//     final originPlaceId = await mapService.getPlaceIdFromLatLng(_origin!);
//     final destinationPlaceId =
//         await mapService.getPlaceIdFromLatLng(_destination!);

//     if (originPlaceId != null && destinationPlaceId != null) {
//       await mapService.fetchAndDrawRoute(
//         _origin!,
//         _destination!,
//         (polyline) => setState(() {
//           _polylines.add(polyline);
//         }),
//         _mapController,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           MapWidget(
//             markers: _markers,
//             polylines: _polylines,
//             onMapCreated: (controller) {
//               _mapController = controller;
//             },
//             onTap: (position) {
//               if (!_isOriginSelected) {
//                 _setMarker(position, true);
//                 _isOriginSelected = true;
//               } else {
//                 _setMarker(position, false);
//               }
//             },
//             initialCameraPosition: _initialCameraPosition,
//           ),
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: LocationInput(
//               originController: _originController,
//               destinationController: _destinationController,
//               onSearchOrigin: (position) {
//                 _setMarker(position, true);
//                 _isOriginSelected = true;
//               },
//               onSearchDestination: (position) {
//                 _setMarker(position, false);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
