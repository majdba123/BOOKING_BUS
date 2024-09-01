import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/Driver/GetTrip.dart';
import 'package:mobile_app/Data_Models/Driver/TripForDriver.dart';

class TripDriverProvider extends ChangeNotifier {
  TripForDriverModel? _TripDriver;
  bool _isLoading = false;
  String? _errorMessage;

  TripForDriverModel? get TripDriver => _TripDriver;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchFirstTrip(String accessToken) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notify that loading has started

    try {
      _TripDriver = await DriverTripService().fetchFirstTrip(accessToken);
      print(_TripDriver);
      print('after handling !!');
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify after loading ends, whether successful or not
    }
  }
}
