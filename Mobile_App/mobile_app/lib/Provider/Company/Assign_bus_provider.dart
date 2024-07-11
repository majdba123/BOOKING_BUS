import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/Company/Bus.dart';
import 'package:mobile_app/Api_Services/Company/Driver.dart';
import 'package:mobile_app/Data_Models/Bus.dart';
import 'package:mobile_app/Data_Models/Driver.dart';



class AssingBusProvider with ChangeNotifier {
 List<Driver> _Drivers = [];
  bool _isLoading = false;
String message='';
  List<Driver> get Drivers => _Drivers;
  bool get isLoading => _isLoading;

  List<Bus> _Buss = [];


  List<Bus> get Buss => _Buss;


  Future<void> fetchBusByStatus(String accessToken, String status) async {
    _isLoading = true;
    notifyListeners();
    // print(status);
    try {
      _Buss = await BusApiService().fetchBusByStatus(accessToken, status);
      // print(_Buss);
    } catch (e) {
      print('Failed to fetch Buss: $e');
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
  Future<String> AssignDriverToBus(String accessToken,var  busId, var  driverId,) async {
     message = await DriverApiService().AssignDriverToBus(accessToken,busId,driverId);
    notifyListeners();
    return message;
  }


   Future<String> CancelAssignDriver(String accessToken,var  driverId) async {
     message = await DriverApiService().CancelAssignDriver(accessToken,driverId);
    notifyListeners();
    return message;
  }
}