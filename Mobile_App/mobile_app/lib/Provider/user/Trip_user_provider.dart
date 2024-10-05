import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/Api_Services/User/User_profile.dart';
import 'package:mobile_app/Data_Models/AlltripsModelUser.dart';
import 'package:mobile_app/Data_Models/Cancel_Rule.dart';
import 'package:mobile_app/Data_Models/Cancel_Rule.dart';
import 'package:mobile_app/Data_Models/LocationOfReservationModel.dart';
import 'package:mobile_app/Data_Models/My_Reservation.dart';
import 'package:mobile_app/Data_Models/Reservation_Success_model.dart';
import 'dart:convert';
import 'package:mobile_app/Data_Models/company.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/payment/TicketDetailObject.dart'; // To decode JSON responses

class TripuserProvider with ChangeNotifier {
  List<AllTrips> _trips = [];

  List<AllTrips> get trips => _trips;
  List<AllTrips> _alltrips = [];

  List<AllTrips> get AllTripsItems => _alltrips;
  List<Company> _compaines = [];

  List<Company> get compaines => _compaines;
  List<MYReservation> _Myreservations = [];
  List<LocationOFRservation> _LocationOfRservation = [];
  List<MYReservation> get Myreservations => _Myreservations;
  List<CancelRule> _cancelRules = [];
  List<CancelRule> get cancelRules => _cancelRules;
  List<LocationOFRservation> get LocationOfRservation => _LocationOfRservation;
  List<TicketDetail> _selectedTicketDetails = [];

  Reservation? _reservation;
  Reservation? get reservation => _reservation;
  String _status = 'active';
  String get status => _status;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isLoadingRule = false;
  bool get isLoadingRule => _isLoadingRule;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  late int _specificIndexReservation;
  int get specificIndexReservation => _specificIndexReservation;
  void saveSpecficRservationIndex(int index) {
    _specificIndexReservation = index;
    notifyListeners();
  }

  void addTicketDetail(TicketDetail detail) {
    _selectedTicketDetails.add(detail);
    notifyListeners();
  }

  void clearTicketDetails() {
    _selectedTicketDetails.clear();
    notifyListeners();
  }

  double get totalAmount {
    return _selectedTicketDetails.fold(
        0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  Future<void> getTripsByPath(
      String accessToken, String from, String to, var companyName) async {
    _isLoading = true;
    notifyListeners();
    final response;
    if (companyName == null) {
      response = await http.get(headers: {
        'Authorization': 'Bearer $accessToken',
      }, Uri.parse(name_domain_server + 'user/trip_by_path?from=$from&to=$to'));
    } else {
      response = await http.get(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
          Uri.parse(name_domain_server +
              'user/trip_by_path?from=$from&to=$to&company_name=$companyName'));
    }

    print(name_domain_server +
        'user/trip_by_path?from=$from&to=$to&company_name=$companyName');
    print(response.statusCode);
    print('here in serach trip by path');
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> tripList = json.decode(response.body);
      _trips = tripList.map((json) => AllTrips.fromJson(json)).toList();
      print(_trips);
      _isLoading = false;
      notifyListeners();
    } else {
      throw Exception('Failed to load trips');
    }
  }

  Future<void> getAllcompanies(
    String accessToken,
  ) async {
    final response = await http.get(headers: {
      'Authorization': 'Bearer $accessToken',
    }, Uri.parse(name_domain_server + 'user/get_all_company'));

    if (response.statusCode == 200) {
      final List<dynamic> tripList = json.decode(response.body);
      _compaines = tripList.map((json) => Company.fromJson(json)).toList();
      print(_compaines);
      notifyListeners();
    } else {
      throw Exception('Failed to load trips');
    }
  }

  Future<void> getallTrips(String accessToken) async {
    final response = await http.get(headers: {
      'Authorization': 'Bearer $accessToken',
    }, Uri.parse(name_domain_server + 'user/trips'));
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> tripList = json.decode(response.body);
      _alltrips = tripList.map((json) => AllTrips.fromJson(json)).toList();
      print(_alltrips);
      notifyListeners();
    } else {
      throw Exception('Failed to load trips');
    }
  }

  Future<void> make_reservation(String accessToken, int type, List<String> seat,
      int breakId, int bus_trip_id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse(
          name_domain_server + 'user/store_reservation/${bus_trip_id}');
      final headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({
        "type": type,
        "seat": seat,
        "break_id": breakId,
      });
      print(body);
      final response = await http.post(url, headers: headers, body: body);
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        Map<String, dynamic> parsedJson = json.decode(response.body);
        String message = parsedJson['message'];

        if (message == 'Reservation created successfully') {
          _reservation = Reservation.fromJson(parsedJson);
          notifyListeners();
        } else {
          throw Exception(message);
        }
      } else {
        Map<String, dynamic> parsedJson = json.decode(response.body);
        String error = parsedJson['error'];
        throw Exception(error);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchReservations(String status, String accessToken) async {
    _isLoading = true;
    _errorMessage = null;
    _status = status;
    notifyListeners();

    try {
      _Myreservations =
          await UserProfile().fetchReservations(status, accessToken);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchLocationOfReservation(String accessToken, String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      _LocationOfRservation =
          await UserProfile().fetchLocationOfRservation(accessToken, id);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> CancelReservation(String accessToken, String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await UserProfile().CancelRservation(accessToken, id);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCanceltionRule(String accessToken, String name) async {
    _isLoadingRule = true;
    notifyListeners();

    try {
      _cancelRules = await UserProfile().canceltionRule(accessToken, name);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoadingRule = false;
      notifyListeners();
    }
  }
}
