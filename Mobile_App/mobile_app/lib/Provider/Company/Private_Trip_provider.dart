// providers/private_trip_provider.dart
import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/Company/Private_trip_company.dart';
import 'package:mobile_app/Data_Models/PrivateTripCompany.dart';

class PrivateTripProvider with ChangeNotifier {
  List<PrivateTripCompany> _privateTrips = [];
  bool _isLoading = false;

  List<PrivateTripCompany> get privateTrips => _privateTrips;
  bool get isLoading => _isLoading;

  Future<void> fetchPrivateTrips(String accessToken) async {
    _isLoading = true;
    notifyListeners();

    try {
      _privateTrips = await PrivateTripComp().getAllPrivateTrips(accessToken);
    } catch (error) {
      print('Failed to fetch private trips: $error');
    }

    _isLoading = false;
    notifyListeners();
  }
}
