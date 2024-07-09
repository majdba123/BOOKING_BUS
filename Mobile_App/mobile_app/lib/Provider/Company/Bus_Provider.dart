import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/Company/Bus.dart';
import 'package:mobile_app/Data_Models/Bus.dart';



class BusProvider with ChangeNotifier {
  List<Bus> _Buss = [];
  bool _isLoading = false;

  List<Bus> get Buss => _Buss;
  bool get isLoading => _isLoading;

  void fetchBuss(String accessToken) async {
    _isLoading = true;
    notifyListeners();

    try {
      _Buss = await BusApiService().fetchBus(accessToken);
    } catch (e) {
      print('Failed to fetch Buss: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

Future<String> addBus(String accessToken,String  number_bus, String  number_passenger) async {
    String message = await BusApiService().AddBus(accessToken,number_bus, number_passenger);
    notifyListeners();
    return message;
  }

  Future<void> updateBus(String token, int id, String number_bus, String number_passenger) async {
    try {
      final updatedBus = await BusApiService().updateBus(token, number_bus, id, number_passenger);
      final index = _Buss.indexWhere((Bus) => Bus.id == id);
      if (index != -1) {
        _Buss[index] = updatedBus;
        notifyListeners();
      }
    } catch (error) {
      print(error);
    }
  }
  Future<void> deleteBus(String token, int id) async {
    try {
      await BusApiService().deleteBus(token, id);
      _Buss.removeWhere((Bus) => Bus.id == id);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
