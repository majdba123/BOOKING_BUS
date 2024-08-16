import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/Company/Bus.dart';
import 'package:mobile_app/Data_Models/Bus.dart';

class BusStatusProvider with ChangeNotifier {
  List<Bus> _Buss = [];
  bool _isLoading = false;

  List<Bus> get Buss => _Buss;
  bool get isLoading => _isLoading;

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
}
