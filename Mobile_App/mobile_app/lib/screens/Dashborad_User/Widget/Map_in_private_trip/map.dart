import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:mobile_app/colors.dart';
import 'package:intl/intl.dart';

class MapUI extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapUI> {
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  late GoogleMapController mapController;

  late Position _currentPosition;
  String _currentAddress = '';
  bool _isLoading = false;
  bool _showAcceptButton = false;
  bool _showDateTimeFields = false;
  bool _isPlacesVisible = true;

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();
  final _dateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final startAddressFocusNode = FocusNode();
  final desrinationAddressFocusNode = FocusNode();

  String _startAddress = '';
  String _destinationAddress = '';
  String? _placeDistance;
  String? _timeduration;
  Set<Marker> markers = {};

  late PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _textField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required double width,
    required Icon prefixIcon,
    Widget? suffixIcon,
    required Function(String) locationCallback,
  }) {
    return Container(
      width: width * 0.8,
      child: TextField(
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }

  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
      await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        startAddressController.text = _currentAddress;
        _startAddress = _currentAddress;
      });
      print(_currentAddress);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _calculateDistance() async {
    setState(() {
      _isLoading = true;
    });
    final apiKey =
        'AIzaSyAeLUpyozCjrCIxNBNmwVfCERYrHZh3MbU'; // Replace with your Google Maps API key

    try {
      if (_startAddress.isEmpty || _destinationAddress.isEmpty) {
        throw Exception('Start or destination address cannot be empty');
      }

      // Retrieve coordinates from Google Maps Geocoding API
      final startResponse = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(_startAddress)}&key=$apiKey'));
      final destinationResponse = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(_destinationAddress)}&key=$apiKey'));

      final startData = jsonDecode(startResponse.body);
      final destinationData = jsonDecode(destinationResponse.body);

      if (startData['status'] != 'OK' || destinationData['status'] != 'OK') {
        throw Exception('Could not resolve one or both addresses');
      }

      final startLocation = startData['results'][0]['geometry']['location'];
      final destinationLocation =
          destinationData['results'][0]['geometry']['location'];

      final double startLatitude = startLocation['lat'];
      final double startLongitude = startLocation['lng'];
      final double destinationLatitude = destinationLocation['lat'];
      final double destinationLongitude = destinationLocation['lng'];

      // Define start and destination markers
      final Marker startMarker = Marker(
        markerId: MarkerId('start'),
        position: LatLng(startLatitude, startLongitude),
        infoWindow: InfoWindow(
          title: 'Start ($startLatitude, $startLongitude)',
          snippet: _startAddress,
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      final Marker destinationMarker = Marker(
        markerId: MarkerId('destination'),
        position: LatLng(destinationLatitude, destinationLongitude),
        infoWindow: InfoWindow(
          title: 'Destination ($destinationLatitude, $destinationLongitude)',
          snippet: _destinationAddress,
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      // Adding markers to the list
      markers.clear();
      markers.add(startMarker);
      markers.add(destinationMarker);

      // Adjust camera bounds to include both markers
      final LatLngBounds bounds = LatLngBounds(
        northeast: LatLng(
          max(startLatitude, destinationLatitude),
          max(startLongitude, destinationLongitude),
        ),
        southwest: LatLng(
          min(startLatitude, destinationLatitude),
          min(startLongitude, destinationLongitude),
        ),
      );

      mapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 100.0),
      );

      // Create and add the polyline to the map
      // Retrieve distance using Google Maps Distance Matrix API
      final distanceResponse = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/distancematrix/json?origins=${Uri.encodeComponent(_startAddress)}&destinations=${Uri.encodeComponent(_destinationAddress)}&key=$apiKey'));

      final distanceData = jsonDecode(distanceResponse.body);

      if (distanceData['status'] != 'OK') {
        throw Exception('Error fetching distance data');
      }

      final rows = distanceData['rows'] as List;
      if (rows.isNotEmpty) {
        final elements = rows[0]['elements'] as List;

        if (elements.isNotEmpty) {
          final distance =
              elements[0]['distance']['value']; // Distance in meters
          final duration = elements[0]['duration']['text'];
          final distanceInKm = distance / 1000;
          setState(() {
            _placeDistance = distanceInKm.toStringAsFixed(2);
            _timeduration = duration;
          });
        }
      }

      await _createPolylines(startLatitude, startLongitude, destinationLatitude,
          destinationLongitude);

      // Calculate distance between the two locations

      setState(() {
// Convert to kilometers
        print('DISTANCE: $_placeDistance km');
      });
      setState(() {
        _isLoading = false;
      });
      return true;
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
    return false;
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        // ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            var width = MediaQuery.of(context).size.width;

            return Container(
              decoration: BoxDecoration(
                color: Colors.white70, // The color for the bottom sheet content
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
              ),
              child: SafeArea(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: _isPlacesVisible ? null : 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    width: width * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ClipOval(
                            child: Material(
                              color: Colors.blue.shade100,
                              child: InkWell(
                                splashColor: Colors.blue,
                                child: SizedBox(
                                  child: Icon(Icons.arrow_downward_rounded),
                                  width: 50,
                                  height: 50,
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ),
                          Text(
                            'Places',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          SizedBox(height: 10),
                          _textField(
                              label: 'Start',
                              hint: 'Choose starting point',
                              prefixIcon: Icon(Icons.looks_one),
                              // suffixIcon: IconButton(
                              //   icon: Icon(Icons.my_location),
                              //   onPressed: () {
                              //     // startAddressController.text = _currentAddress;
                              //     _startAddress = _currentAddress;
                              //     // print(startAddressController.text);
                              //     // print(_startAddress);
                              //     print(_currentPosition.latitude);
                              //     print(_currentPosition.longitude);
                              //   },
                              // ),
                              controller: startAddressController,
                              focusNode: startAddressFocusNode,
                              width: width,
                              locationCallback: (String value) {
                                setState(() {
                                  _startAddress = value;
                                });
                              }),
                          SizedBox(height: 10),
                          _textField(
                              label: 'Destination',
                              hint: 'Choose destination',
                              prefixIcon: Icon(Icons.looks_two),
                              controller: destinationAddressController,
                              focusNode: desrinationAddressFocusNode,
                              width: width,
                              locationCallback: (String value) {
                                setState(() {
                                  _destinationAddress = value;
                                });
                              }),
                          SizedBox(height: 10),
                          Visibility(
                            visible: _placeDistance == null ? false : true,
                            child: Text(
                              'DISTANCE: $_placeDistance km',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Visibility(
                            visible: _placeDistance == null ? false : true,
                            child: Text(
                              'Time: $_timeduration ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          ElevatedButton(
                            onPressed: (_startAddress != '' &&
                                    _destinationAddress != '')
                                ? () async {
                                    startAddressFocusNode.unfocus();
                                    desrinationAddressFocusNode.unfocus();
                                    setState(() {
                                      _isLoading = true;
                                      if (markers.isNotEmpty) markers.clear();
                                      if (polylines.isNotEmpty)
                                        polylines.clear();
                                      if (polylineCoordinates.isNotEmpty)
                                        polylineCoordinates.clear();
                                      _placeDistance = null;
                                    });

                                    _calculateDistance().then((isCalculated) {
                                      setState(() {
                                        _isLoading = false;
                                        _showDateTimeFields = false;
                                      });
                                      if (isCalculated) {
                                        _showAcceptButton = true;

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Distance Calculated Successfully'),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Error Calculating Distance'),
                                          ),
                                        );
                                      }
                                    });
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                // alignment: Alignment.center,
                                children: [
                                  if (!_isLoading) // Show the text only if _isLoading is false
                                    Text(
                                      'Serach'.toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  if (_isLoading) // Show the loading spinner if _isLoading is true
                                    CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          AppColors.primaryColor),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          if (_showAcceptButton) ...[
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _showDateTimeFields = true;
                                  _showAcceptButton = false;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Accept'.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                          ],
                          SizedBox(height: 20),
                          if (_showDateTimeFields) ...[
                            Container(
                              width: width * 0.8,
                              child: GestureDetector(
                                onTap: () {
                                  _pickDate(context);
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: _dateController,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.calendar_today_outlined,
                                        color: AppColors.primaryColor,
                                      ),
                                      fillColor: Colors.white,
                                      filled: true,
                                      contentPadding: EdgeInsets.all(15),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade400,
                                            width: 2),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        borderSide: BorderSide(
                                            color: Colors.blue.shade300,
                                            width: 2),
                                      ),
                                      labelText: 'Date (dd/MM/yyyy)',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a date';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              width: width * 0.8,
                              child: GestureDetector(
                                onTap: () {
                                  _pickStartTime(context);
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: _startTimeController,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.access_time_rounded,
                                        color: AppColors.primaryColor,
                                      ),
                                      fillColor: Colors.white,
                                      filled: true,
                                      contentPadding: EdgeInsets.all(15),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade400,
                                            width: 2),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        borderSide: BorderSide(
                                            color: Colors.blue.shade300,
                                            width: 2),
                                      ),
                                      labelText: 'Start Time (HH:mm)',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a start time';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              onPressed: () {
                                print('sned order message');

                                print(from);
                                print(to);
                              },
                              child: Text(
                                'Send Order'.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  double _calculateDistanceInMeters(
    double startLat,
    double startLng,
    double destLat,
    double destLng,
  ) {
    const double earthRadius = 6371000; // Earth's radius in meters

    final double dLat = _toRadians(destLat - startLat);
    final double dLng = _toRadians(destLng - startLng);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(startLat)) *
            cos(_toRadians(destLat)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  var from;
  var to;
  _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey:
          "AIzaSyAeLUpyozCjrCIxNBNmwVfCERYrHZh3MbU", // Replace with your Google Maps API key
      request: PolylineRequest(
        origin: PointLatLng(startLatitude, startLongitude),
        destination: PointLatLng(destinationLatitude, destinationLongitude),
        mode: TravelMode.driving,
      ),
    );
    from = PointLatLng(startLatitude, startLongitude);
    to = PointLatLng(destinationLatitude, destinationLongitude);
    polylineCoordinates.clear(); // Clear previous polyline coordinates

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
  void initState() {
    super.initState();

    // _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      child: Scaffold(
        // bottomNavigationBar: BottomNavigationBar(
        //   items: [
        //     BottomNavigationBarItem(
        //       icon: Icon(
        //           _isPlacesVisible ? Icons.list_outlined : Icons.arrow_upward),
        //       label: '',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(
        //           _isPlacesVisible ? Icons.list_outlined : Icons.arrow_upward),
        //       label: '',
        //     ),
        //   ],
        //   onTap: (index) {
        //     _showBottomSheet(context);
        //   },
        // ),
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            // Map View
            GoogleMap(
              markers: Set<Marker>.from(markers),
              initialCameraPosition: _initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              polylines: Set<Polyline>.of(polylines.values),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),

            // Show zoom buttons
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, bottom: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.blue.shade100,
                        child: InkWell(
                          splashColor: Colors.blue,
                          child: SizedBox(
                            child: Icon(_isPlacesVisible
                                ? Icons.list_outlined
                                : Icons.arrow_upward),
                            width: 50,
                            height: 50,
                          ),
                          onTap: () {
                            _showBottomSheet(context);
                            setState(() {
                              // _isPlacesVisible = !_isPlacesVisible;
                            });
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
            // Show the place input fields & button for showing the route

            // SafeArea(
            //   child: Align(
            //     alignment: Alignment.topCenter,
            //     child:
            //   ),
            // ),
            // Show current location button
            SafeArea(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                  child: ClipOval(
                    child: Material(
                      color: Colors.orange.shade100, // button color
                      child: InkWell(
                        splashColor: Colors.orange, // inkwell color
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: Icon(Icons.my_location),
                        ),
                        onTap: () {
                          mapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                  _currentPosition.latitude,
                                  _currentPosition.longitude,
                                ),
                                zoom: 18.0,
                              ),
                            ),
                          );

                          print(_currentPosition.latitude);
                          print(_currentPosition.longitude);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickDate(BuildContext context) {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      onConfirm: (date) {
        setState(() {
          _dateController.text = DateFormat('dd/MM/yyyy').format(date);
        });
      },
      currentTime: DateTime.now(),
      locale: LocaleType.en,
    );
  }

  void _pickStartTime(BuildContext context) {
    DatePicker.showTimePicker(
      context,
      showTitleActions: true,
      onConfirm: (time) {
        setState(() {
          _startTimeController.text = DateFormat('HH:mm').format(time);
        });
      },
      currentTime: DateTime.now(),
      locale: LocaleType.en,
    );
  }
}
