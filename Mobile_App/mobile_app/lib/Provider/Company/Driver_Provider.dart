import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/Company/Driver.dart';
import 'package:mobile_app/Data_Models/Driver.dart';
import 'package:mobile_app/Data_Models/DriverBusActive.dart';
import 'package:mobile_app/Data_Models/Driver_Status.dart';

class DriverProvider with ChangeNotifier {
  String _message = '';
  List<Driver> _Drivers = [];
  List<DriverStauts> _DriversStauts = [];
  List<DriverBusActive> _DriversBusActive = [];
  bool _isLoading = false;
  List<DriverStauts> get DriversStauts => _DriversStauts;
  String get message => _message;
  List<Driver> get Drivers => _Drivers;
  List<DriverBusActive> get DriversBusActive => _DriversBusActive;
  bool get isLoading => _isLoading;

  void fetchDrivers(String accessToken) async {
    _isLoading = true;
    notifyListeners();

    try {
      _DriversStauts = await DriverApiService().fetchDrivers(accessToken);
    } catch (e) {
      print('Failed to fetch Drivers: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDriversOnActiveBus(String accessToken) async {
    _isLoading = true;
    notifyListeners();

    try {
      _DriversBusActive =
          await DriverApiService().fetchDriversOnActiveBus(accessToken);
    } catch (e) {
      print('Failed to fetch Drivers: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void fetchDriverByStatus(String accessToken, String Status) async {
    _isLoading = true;
    notifyListeners();

    try {
      _DriversStauts =
          await DriverApiService().fetchDriverByStatus(accessToken, Status);
    } catch (e) {
      print('Failed to fetch Drivers: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addDriver(
      String token, String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _message =
          await DriverApiService().addDriver(token, name, email, password);
    } catch (error) {
      _message = error.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Future<void> updateDriver(String token, int id, String name, String email) async {
  //   try {
  //     final updatedDriver = await DriverApiService().updateDriver(token, number_Driver, id, number_passenger);
  //     final index = _Drivers.indexWhere((Driver) => Driver.id == id);
  //     if (index != -1) {
  //       _Drivers[index] = updatedDriver;
  //       notifyListeners();
  //     }
  //   } catch (error) {
  //     print(error);
  //   }
  // }
  Future<void> deleteDriver(String token, int id) async {
    try {
      await DriverApiService().deleteDriver(token, id);
      _Drivers.removeWhere((Driver) => Driver.id == id);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  void clearBreakAreas() {
    _Drivers = [];
    notifyListeners();
  }
}
