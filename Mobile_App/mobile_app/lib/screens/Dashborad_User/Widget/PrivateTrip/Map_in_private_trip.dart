import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapPrivateTrip extends StatefulWidget {
  final double startLat;
  final double startLng;
  final double destinationLat;
  final double destinationLng;

  MapPrivateTrip({
    required this.startLat,
    required this.startLng,
    required this.destinationLat,
    required this.destinationLng,
  });

  @override
  _MapPrivateTripState createState() => _MapPrivateTripState();
}

class _MapPrivateTripState extends State<MapPrivateTrip> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  late PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  @override
  void initState() {
    super.initState();

    // Initialize markers and polylines when the map is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _createMarkersAndPolylines();
    });
  }

  // Create markers and polylines for the route
  void _createMarkersAndPolylines() async {
    markers.add(
      Marker(
          markerId: MarkerId('start'),
          position: LatLng(widget.startLat, widget.startLng),
          infoWindow: InfoWindow(title: 'Start Location'),
          onTap: () {
            _showLatLngDialog(
                'Start Location', widget.startLat, widget.startLng);
          }),
    );

    markers.add(
      Marker(
          markerId: MarkerId('destination'),
          position: LatLng(widget.destinationLat, widget.destinationLng),
          infoWindow: InfoWindow(title: 'Destination Location'),
          onTap: () {
            _showLatLngDialog('Destination Location', widget.destinationLat,
                widget.destinationLng);
          }),
    );

    await _createPolylines(widget.startLat, widget.startLng,
        widget.destinationLat, widget.destinationLng);

    // Move the camera to show the entire route
    LatLngBounds bounds = _boundsFromLatLngList(polylineCoordinates);
    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    late double x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (latLng.latitude > x1) x1 = latLng.latitude;
      if (latLng.latitude < x0) x0 = latLng.latitude;
      if (latLng.longitude > y1) y1 = latLng.longitude;
      if (latLng.longitude < y0) y0 = latLng.longitude;
    }
    return LatLngBounds(
      southwest: LatLng(x0, y0),
      northeast: LatLng(x1, y1),
    );
  }

  void _showLatLngDialog(String title, double lat, double lng) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text('Latitude: $lat\nLongitude: $lng'),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Create a polyline between the start and destination locations
  _createPolylines(double startLatitude, double startLongitude,
      double destinationLatitude, double destinationLongitude) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: "AIzaSyDhQD0CiLwIDWv0AR7noQSjX1w0SU6pHGo",
      request: PolylineRequest(
        origin: PointLatLng(startLatitude, startLongitude),
        destination: PointLatLng(destinationLatitude, destinationLongitude),
        mode: TravelMode.driving,
      ),
    );
    polylineCoordinates.clear();

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );

    setState(() {
      polylines[id] = polyline;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Google Map View
          GoogleMap(
            markers: Set<Marker>.from(markers),
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.startLat, widget.startLng),
              zoom: 10.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            polylines: Set<Polyline>.of(polylines.values),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              _createMarkersAndPolylines();
            },
          ),
          // Zoom Buttons
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, bottom: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  ClipOval(
                    child: Material(
                      color: Colors.blue.shade100, // button color
                      child: InkWell(
                        splashColor: Colors.blue, // inkwell color
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Icon(Icons.add),
                        ),
                        onTap: () {
                          mapController.animateCamera(
                            CameraUpdate.zoomIn(),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ClipOval(
                    child: Material(
                      color: Colors.blue.shade100, // button color
                      child: InkWell(
                        splashColor: Colors.blue, // inkwell color
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Icon(Icons.remove),
                        ),
                        onTap: () {
                          mapController.animateCamera(
                            CameraUpdate.zoomOut(),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
