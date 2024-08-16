// trip_provider.dart

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mobile_app/Api_Services/Company/Bus_trip.dart';
import 'package:mobile_app/Data_Models/Specfic_Trip.dart';
import 'package:mobile_app/Data_Models/Trips_Status.dart';
 // Adjust path as per your project
import 'package:mobile_app/constants.dart';
// Adjust path as per your project

class TripBusStatusProvider with ChangeNotifier {

  List<SpecificTrip> _trips = [];
    List<TripByStatus> _tripsByStatus = [];
  bool _isLoading = false;

  List<SpecificTrip> get trips => _trips;
  
  List<TripByStatus> get tripsByStatus => _tripsByStatus;
  bool get isLoading => _isLoading;

Future<void> fetchTripsByStatus(String accessToken, String status) async {
    _isLoading = true;
    notifyListeners();

    try {
      _tripsByStatus = await TripStatus().fetchTripsByStatus(accessToken, status);
    } catch (e) {
      print('Error fetching trips: $e');
      _trips = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> fetchSpecficTrip(String accessToken, int tripid) async {
    _isLoading = true;
    notifyListeners();

    try {
      _trips = await TripStatus().fetchSpecifcTrip(accessToken, tripid);
    } catch (e) {
      print('Error fetching trips: $e');
      _trips = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
