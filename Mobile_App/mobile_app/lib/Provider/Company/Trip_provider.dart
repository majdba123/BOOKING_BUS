import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/Company/Trip.dart';
import 'package:mobile_app/Data_Models/Trip_Model/Trip.dart';


class TripProvider with ChangeNotifier {
  List<Trip> _trips = [];
  bool _isLoading = false;

  List<Trip> get trips => _trips;
  bool get isLoading => _isLoading;

  void fetchTrips(String accessToken) async {
    _isLoading = true;
    notifyListeners();

    try {
      _trips = await TripApiService().fetchTrips(accessToken);
    } catch (e) {
      print('Failed to fetch trips: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTrip(String accessToken, Trip trip) async {
    await TripApiService().updateTrip(accessToken, trip);
    int index = _trips.indexWhere((t) => t.id == trip.id);
    if (index != -1) {
      _trips[index] = trip;
      notifyListeners();
    }
  }

  Future<void> deleteTrip(String accessToken, int tripId) async {
    await TripApiService().deleteTrip(accessToken, tripId);
    _trips.removeWhere((trip) => trip.id == tripId);
    notifyListeners();
  }
}
