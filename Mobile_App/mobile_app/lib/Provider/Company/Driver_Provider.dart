import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/Company/Driver.dart';
import 'package:mobile_app/Data_Models/Driver.dart';



class DriverProvider with ChangeNotifier {
  List<Driver> _Drivers = [];
  bool _isLoading = false;
String message='';
  List<Driver> get Drivers => _Drivers;
  bool get isLoading => _isLoading;

  void fetchDrivers(String accessToken) async {
    _isLoading = true;
    notifyListeners();

    try {
      _Drivers = await DriverApiService().fetchDrivers(accessToken);
    } catch (e) {
      print('Failed to fetch Drivers: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  void fetchDriversOnActiveBus(String accessToken) async {
    _isLoading = true;
    notifyListeners();

    try {
      _Drivers = await DriverApiService().fetchDriversOnActiveBus(accessToken);
    } catch (e) {
      print('Failed to fetch Drivers: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

void fetchDriverByStatus(String accessToken,String Status) async {
    _isLoading = true;
    notifyListeners();

    try {
      _Drivers = await DriverApiService().fetchDriverByStatus(accessToken,Status);
    } catch (e) {
      print('Failed to fetch Drivers: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
Future<String> addDriver(String accessToken,String  name, String  email,String password) async {
     _isLoading = true;
    notifyListeners();
     message = await DriverApiService().AddDriver(accessToken,name, email,password);
   _isLoading = false;
    notifyListeners();
    return message;
  }

 

  // Future<void> updateDriver(String token, int id, String number_Driver, String number_passenger) async {
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
}
