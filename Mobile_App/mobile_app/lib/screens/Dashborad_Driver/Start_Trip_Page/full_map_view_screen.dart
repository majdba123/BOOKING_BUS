import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Journey_Detailes_Page/CompleteJourneyPage/JourneyCompletedScreen.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Start_Trip_Page/journey_buttons_widget.dart';
import 'package:mobile_app/screens/WidgetApp/BackToTripbutton.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Provider/Driver/Driver.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Start_Trip_Page/Mapprovider.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Start_Trip_Page/timeline_tile_widget.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Start_Trip_Page/BreakGeolocation.dart';

class FullMapViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var driverProvider = Provider.of<DriverProvider>(context, listen: false);
    var mapProvider = Provider.of<MapProvider>(context, listen: false);
    var accesstoken =
        Provider.of<AuthProvider>(context, listen: false).accessToken;

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    late GoogleMapController mapController;
    // const double _minZoom = 1.0;
    // const double _maxZoom = 5.0;
    final initialPosition = LatLng(
      driverProvider.TripDriverDetail!.from_lat,
      driverProvider.TripDriverDetail!.from_long,
    );

    final destinationPosition = LatLng(
      driverProvider.TripDriverDetail!.to_lat,
      driverProvider.TripDriverDetail!.to_long,
    );
    print(initialPosition);
    print(destinationPosition);
    // Fetch the route when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mapProvider.fetchRoute(initialPosition, destinationPosition);

      // if (driverProvider.isStartTrip) {
      //   mapProvider.startLocationTracking(
      //       context,
      //       driverProvider.TripDriverDetail!.bus_trip_id,
      //       accesstoken,
      //       mapController);
      // }
    });

    return Scaffold(
      body: Stack(
        children: [
          Consumer<MapProvider>(
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
                        southwest: LatLng(
                          driverProvider.TripDriverDetail!.from_lat,
                          driverProvider.TripDriverDetail!.from_long,
                        ),
                        northeast: LatLng(
                          driverProvider.TripDriverDetail!.to_lat,
                          driverProvider.TripDriverDetail!.to_long,
                        ),
                      ),
                      50,
                    ),
                  );
                },
                // onCameraMove: (CameraPosition position) {
                //   if (position.zoom < _minZoom) {
                //     mapController.moveCamera(CameraUpdate.zoomTo(_minZoom));
                //   } else if (position.zoom > _maxZoom) {
                //     mapController.moveCamera(CameraUpdate.zoomTo(_maxZoom));
                //   }
                // },
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
                  ...LatLngHelper.getBreaksMarkers(context),
                },
                polylines: {
                  Polyline(
                    polylineId: PolylineId('route'),
                    points: mapProvider.routeCoordinates,
                    color: Colors.red,
                    width: 5,
                  ),
                },
                myLocationButtonEnabled: false,
                scrollGesturesEnabled: true,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
              );
            },
          ),
          // Overlay container at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Consumer<MapProvider>(
                builder: (context, mapProvider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: mapProvider.toggleTimelineVisibility,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (driverProvider.isStartTrip) ...[
                              Text(
                                'NextStop : ${driverProvider.TripDriverDetail?.breaks_data[driverProvider.currentStopIndex].break_name}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ] else if (!driverProvider.isStartTrip) ...[
                              Text(
                                'Stop Plcaes In Your Trip',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                            Icon(
                              mapProvider.showTimeline
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              size: 24.0,
                            ),
                          ],
                        ),
                      ),
                      if (mapProvider.showTimeline)
                        Column(
                          children: [
                            SizedBox(height: 16.0),
                            TimelineTileWidget(),
                          ],
                        ),
                      SizedBox(height: 16.0),
                      if (driverProvider.isStartTrip) ...[
                        JourneyButtons(
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                          // isJourneyComplete: false,
                        ),
                      ] else if (!driverProvider.isStartTrip) ...[
                        Container(
                            width: 500,
                            child: CustomeButton(
                              context,
                              'Back to Trip',
                              () => Navigator.pop(context),
                            )),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
