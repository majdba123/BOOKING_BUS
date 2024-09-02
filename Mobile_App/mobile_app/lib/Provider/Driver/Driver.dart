import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/Driver/DriverSerivce.dart';
import 'package:mobile_app/Data_Models/Driver/MyBusModel.dart';
import 'package:mobile_app/Data_Models/Driver/RatingDriverAndSpeed.dart';
import 'package:mobile_app/Data_Models/Driver/TripForDriver.dart';

class DriverProvider extends ChangeNotifier {
  TripForDriverModel? _TripDriver;
  List<TripForDriverModel>? _MyTrip;
  List<TripForDriverModel>? _hsitoryTrip;
  RateDriverModel? _RateDriver;
  MyBusModel? _MyBus;
  bool _isLoading = false;
  String? _errorMessage;
  String _typePage = 'alltrip';
  String get typePage => _typePage;

  TripForDriverModel? get TripDriver => _TripDriver;

  List<TripForDriverModel>? get MyTrip => _MyTrip;
  List<TripForDriverModel>? get hsitoryTrip => _hsitoryTrip;
  RateDriverModel? get RateDriver => _RateDriver;
  MyBusModel? get MyBus => _MyBus;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setypePage(type) {
    _typePage = type;
    notifyListeners();
  }

  Future<void> fetchFirstTrip(String accessToken) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _TripDriver = await DriverService().fetchFirstTrip(accessToken);
      print(_TripDriver);
      print('after handling !!');
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMyTrip(String accessToken) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _MyTrip = await DriverService().fetchMyTrip(accessToken);
      print(_MyTrip);
      print('after handling !!');
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> history(String accessToken) async {
    _isLoading = true;
    _errorMessage = null;
    _MyTrip = null;
    notifyListeners();

    try {
      _MyTrip = await DriverService().History(accessToken);
      print(_hsitoryTrip);
      print('after handling !!');
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRateDriver(String accessToken) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _RateDriver = await DriverService().fetchRteDriver(accessToken);
      print(_RateDriver);
      print('after handling !!');
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMyBus(String accessToken) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _MyBus = await DriverService().fetchMyBus(accessToken);
      print(_MyBus);
      print('after handling !!');
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
