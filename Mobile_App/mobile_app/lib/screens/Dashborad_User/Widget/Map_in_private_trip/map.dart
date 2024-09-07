import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/user/private_Trip_provider.dart';
import 'package:mobile_app/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

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
  final _formKey = GlobalKey<FormState>();
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
        'AIzaSyDd9RLeRSNjmt1AIx22VeWqwbxYh3myC44'; // Replace with your Google Maps API key

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
            return KeyboardVisibilityBuilder(
                builder: (context, isKeyboardVisible) {
              return AnimatedPadding(
                duration: Duration(milliseconds: isKeyboardVisible ? 1 : 1),
                curve: isKeyboardVisible ? Curves.easeOut : Curves.easeIn,
                padding: EdgeInsets.only(
                    bottom: isKeyboardVisible
                        ? MediaQuery.of(context).viewInsets.bottom
                        : 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors
                        .white70, // The color for the bottom sheet content
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20.0)),
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
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    150.0, 20.0, 150.0, 20.0),
                                child: InkWell(
                                  child: Container(
                                    height: 8.0,
                                    width: 80.0,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.all(
                                            const Radius.circular(8.0))),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              _textField(
                                  label: 'Start',
                                  hint: 'Choose starting point',
                                  prefixIcon: Icon(Icons.looks_one),
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
                                          if (markers.isNotEmpty)
                                            markers.clear();
                                          if (polylines.isNotEmpty)
                                            polylines.clear();
                                          if (polylineCoordinates.isNotEmpty)
                                            polylineCoordinates.clear();
                                          _placeDistance = null;
                                        });

                                        _calculateDistance()
                                            .then((isCalculated) {
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
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
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
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                  onPressed: () async {
                                    print('sned order message');

                                    final from = startAddressController.text;
                                    final to =
                                        destinationAddressController.text;
                                    final date = _dateController.text;
                                    final startTime = _startTimeController.text;
                                    final accessToken =
                                        Provider.of<AuthProvider>(context,
                                                listen: false)
                                            .accessToken;

                                    try {
                                      await Provider.of<
                                                  PrivateTripuserProvider>(
                                              context,
                                              listen: false)
                                          .storePrivateTrip(
                                        from,
                                        to,
                                        date,
                                        startTime,
                                        accessToken,
                                        _placeDistance!,
                                        fromlocation.latitude,
                                        fromlocation.longitude,
                                        tolocation.latitude,
                                        tolocation.longitude,
                                      );
                                      var message =
                                          Provider.of<PrivateTripuserProvider>(
                                                  context,
                                                  listen: false)
                                              .message;

                                      if (message != null &&
                                          message!.isNotEmpty) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          print('ddd');
                                          AwesomeDialog(
                                            context: context,
                                            animType: AnimType.leftSlide,
                                            headerAnimationLoop: false,
                                            dialogType: DialogType.success,
                                            showCloseIcon: true,
                                            title: 'Succes',
                                            desc:
                                                'Private Trip add it Succesufly ',
                                            btnOkOnPress: () {
                                              Navigator.of(context)
                                                  .pushNamedAndRemoveUntil(
                                                      '/ProfilePage',
                                                      (Route<dynamic> route) =>
                                                          false);
                                              debugPrint('OnClcik');
                                            },
                                            btnOkIcon: Icons.check_circle,
                                            onDismissCallback: (type) {
                                              debugPrint(
                                                  'Dialog Dissmiss from callback $type');
                                            },
                                          ).show();
                                          message = null;
                                        });
                                      }
                                    } catch (error) {
                                      print(error);
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        print('ddd');
                                        Container();
                                        AwesomeDialog(
                                          context: context,
                                          animType: AnimType.rightSlide,
                                          headerAnimationLoop: false,
                                          dialogType: DialogType.error,
                                          showCloseIcon: true,
                                          title: 'Error Dialog',
                                          desc:
                                              'Error During Create Priavte Trip Try later ....',
                                          btnOkOnPress: () {
                                            Navigator.of(context)
                                                .pushNamedAndRemoveUntil(
                                                    '/ProfilePage',
                                                    (Route<dynamic> route) =>
                                                        false);
                                          },
                                          btnOkIcon: Icons.check_circle,
                                          btnOkColor: Colors.red,
                                          onDismissCallback: (type) {
                                            debugPrint(
                                                'Dialog Dissmiss from callback $type');
                                          },
                                        ).show();
                                      });
                                    }
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
                ),
              );
            });
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

  late PointLatLng fromlocation;
  late PointLatLng tolocation;
  _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: "AIzaSyDd9RLeRSNjmt1AIx22VeWqwbxYh3myC44",
      request: PolylineRequest(
        origin: PointLatLng(startLatitude, startLongitude),
        destination: PointLatLng(destinationLatitude, destinationLongitude),
        mode: TravelMode.driving,
      ),
    );
    fromlocation = PointLatLng(startLatitude, startLongitude);
    tolocation = PointLatLng(destinationLatitude, destinationLongitude);

    print(fromlocation);
    print(tolocation);
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
                          child: Icon(Icons.arrow_upward_rounded),
                        ),
                        onTap: () {
                          _showBottomSheet(context);
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
