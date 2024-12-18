import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/User/Private_trip.dart';
import 'package:mobile_app/Data_Models/Private_Trip.dart';
import 'package:mobile_app/Data_Models/Private_Trip_accepted_By_Comapny_.dart';

class PrivateTripuserProvider with ChangeNotifier {
  int? _tripId;
  String? _message;
  List<PrivateTripModel> _privatetrips = [];
  List<PrivateTripModel> get privatetrips => _privatetrips;
  List<PrivateTripAccpetedBycompanyModel> _privatetripsRequset = [];
  List<PrivateTripAccpetedBycompanyModel> get privatetripsRequest =>
      _privatetripsRequset;
  int? get tripId => _tripId;
  String? get message => _message;
  String _status = 'padding';
  String get status => _status;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setStatus(String status) {
    _status = status;
    notifyListeners();
  }

  void settripid(int tripid) {
    _tripId = tripid;
    notifyListeners();
  }

  Future<void> storePrivateTrip(
      String from,
      String to,
      String date,
      String startTime,
      String accessToken,
      String Distance,
      double lat_from,
      double long_from,
      double lat_to,
      double long_to) async {
    try {
      _isLoading = true;

      _message = await PrivateTrip().storePrivateTrip(from, to, date, startTime,
          accessToken, Distance, lat_from, long_from, lat_to, long_to);

      notifyListeners();
    } catch (error) {
      _isLoading = false;

      notifyListeners();
      throw error;
    }
  }

  Future<void> fetchTripsByStatus(String accessToken) async {
    _isLoading = true;
    notifyListeners();
    _privatetrips =
        await PrivateTrip().getPrivateTripsByStatus(_status, accessToken);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchPrivateTripsAccepetedRequsetByComapny(
      int privatetripId, String accessToken) async {
    _isLoading = true;
    notifyListeners();
    _privatetripsRequset = await PrivateTrip()
        .getPrivateTripsRequsetAcceptedByCompany(privatetripId, accessToken);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> acceptPrivateTripRequsetfromuser(
      String OrderPrivateId, String accessToken) async {
    _isLoading = true;
    notifyListeners();
    await PrivateTrip().acceptPrivateOrder(accessToken, OrderPrivateId);
    _isLoading = false;
    notifyListeners();
  }
}
