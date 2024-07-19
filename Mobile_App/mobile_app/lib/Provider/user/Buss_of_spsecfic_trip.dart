import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http; // Assuming you're using the http package for API calls
import 'package:mobile_app/Api_Services/Company/Trip.dart';
import 'dart:convert';
import 'package:mobile_app/Data_Models/Trip_by_Path.dart';
import 'package:mobile_app/Data_Models/show_buss_spsecifc_trip.dart';
import 'package:mobile_app/constants.dart'; // To decode JSON responses

class BussofSpsccifTripProvider with ChangeNotifier {
  List<BusResponse> _busResponses = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<BusResponse> get busResponses => _busResponses;

  Future<void> getBussofSpecicTrip(int tripId, String accessToken) async {
    _isLoading = true;
    notifyListeners();
    try {
      // Replace with your API call logic
      print('try!!!!');
      _busResponses =
          await TripBusApi().fetch_buss_of_spsecifc_trip(accessToken, tripId);

      print('the bus response $_busResponses');
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
