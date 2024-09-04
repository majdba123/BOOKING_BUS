import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http; // Assuming you're using the http package for API calls
import 'package:mobile_app/Api_Services/Company/Bus_trip.dart';
import 'package:mobile_app/Api_Services/Company/Trip.dart';
import 'package:mobile_app/Data_Models/SeatModel.dart';
import 'package:mobile_app/Data_Models/show_buss_spsecifc_trip.dart';

class BussofSpsccifTripProvider with ChangeNotifier {
  List<BusResponse> _busResponses = [];
  List<SeatModel> _SeatsOfBus = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<BusResponse> get busResponses => _busResponses;
  List<SeatModel> get seats => _SeatsOfBus;

  late int _tripid;
  late String _companyName;
  late String _fromtime;
  late String _totime;
  late String _from;
  late String _to;
  late int _Distance;
  late int _busTripid;
  late String _Duration;
  late int _busId;
  int get tripid => _tripid;
  int get busId => _busId;

  int get BusTripid => _busTripid;
  String get companyName => _companyName;
  String get fromTime => _fromtime;
  String get toTime => _totime;
  String get from => _from;
  int get Ditacnce => _Distance;
  String get Duration => _Duration;
  String get to => _to;
  void setTripid(tripid) {
    _tripid = tripid;
    notifyListeners();
  }

  void setBusid(busid) {
    _busId = busid;
    notifyListeners();
  }

  void setBusTripid(Bustripid) {
    _busTripid = Bustripid;
    notifyListeners();
  }

  void setcompanyName(companyName) {
    _companyName = companyName;
    notifyListeners();
  }

  void setFromTime(fromtime) {
    _fromtime = fromtime;
    notifyListeners();
  }

  void setToTime(totime) {
    _totime = totime;
    notifyListeners();
  }

  void setFrom(from) {
    _from = from;
    notifyListeners();
  }

  void setTo(to) {
    _to = to;
    notifyListeners();
  }

  void setDistance(Distance) {
    _Distance = Distance;
    notifyListeners();
  }

  void setDuration(Duration) {
    _Duration = Duration;
    notifyListeners();
  }

  Future<void> getBussofSpecicTrip(int tripId, String accessToken) async {
    _isLoading = true;
    notifyListeners();
    try {
      // Replace with your API call logic
      print('try!!!!');
      _busResponses =
          await TripBusApi().fetch_buss_of_spsecifc_trip(accessToken, tripId);
      print(_busResponses);
      print('the bus response $_busResponses');
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getSeatOfBusTrip(int busId, String accessToken) async {
    _isLoading = true;
    notifyListeners();
    try {
      // Replace with your API call logic
      print('try!!!!');
      _SeatsOfBus = await TripStatus().fetchSeatOfBus(accessToken, busId);
      notifyListeners();
      print(_SeatsOfBus);
      print('the _SeatsOfBus response $_busResponses');
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
