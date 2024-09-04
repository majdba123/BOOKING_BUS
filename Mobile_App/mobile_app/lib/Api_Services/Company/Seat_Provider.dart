import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/Company/Seat.dart';
import 'package:mobile_app/Data_Models/Seat.dart';



class SeatProvider with ChangeNotifier {
  List<Seat> _Seats = [];
  bool _isLoading = false;

  List<Seat> get Seats => _Seats;
  bool get isLoading => _isLoading;

  Future<void> fetchSeatByBusId(String accessToken,var busId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _Seats = await SeatApiService().fetchSeatByBusId(accessToken,busId);
    } catch (e) {
       _Seats = [];
      print('Failed to fetch Seats: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}
