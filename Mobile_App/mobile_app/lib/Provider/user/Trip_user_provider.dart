import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http; // Assuming you're using the http package for API calls
import 'package:mobile_app/Api_Services/User/User_profile.dart';
import 'package:mobile_app/Data_Models/AlltripsModelUser.dart';
import 'package:mobile_app/Data_Models/My_Reservation.dart';
import 'package:mobile_app/Data_Models/Reservation_Success_model.dart';
import 'dart:convert';
import 'package:mobile_app/Data_Models/Trip_by_Path.dart';
import 'package:mobile_app/Data_Models/company.dart';
import 'package:mobile_app/Data_Models/show_buss_spsecifc_trip.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/payment/TicketDetailObject.dart'; // To decode JSON responses

class TripuserProvider with ChangeNotifier {
  List<TripByPath> _trips = [];

  List<TripByPath> get trips => _trips;
  List<AllTrips> _alltrips = [];

  List<AllTrips> get AllTripsItems => _alltrips;
  List<Company> _compaines = [];

  List<Company> get compaines => _compaines;
  List<MYReservation> _Myreservations = [];

  List<MYReservation> get Myreservations => _Myreservations;
  List<TicketDetail> _selectedTicketDetails = [];

  // Getter for the selected ticket details
  List<TicketDetail> get selectedTicketDetails => _selectedTicketDetails;
  BusTrip? selectedBus;
  BusResponse? selectedBusTrip;
  late List<int> selectedSeat;
  late BreakPlace breakPlaces;
  String? from;
  String? to;
  late int trip_type;
  late int select_place_debording_break_id;
  late int select_place_bording_break_id;
  BreakPlace? _selectedBoardingPoint;
  BreakPlace? _selectedDeboardingPoint;
  int price_tiket = 0;
  int price_trip = 0;
  int totoal_price = 0;
  BreakPlace? get selectedBoardingPoint => _selectedBoardingPoint;
  BreakPlace? get selectedDeboardingPoint => _selectedDeboardingPoint;
  Reservation? _reservation;
  Reservation? get reservation => _reservation;
  String _status = 'active';
  String get status => _status;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void addTicketDetail(TicketDetail detail) {
    _selectedTicketDetails.add(detail);
    notifyListeners();
  }

  // Function to clear the ticket details (e.g., when starting a new reservation)
  void clearTicketDetails() {
    _selectedTicketDetails.clear();
    notifyListeners();
  }

  String getSeatType(int seatId) {
    // Implement your logic to determine the seat type based on seatId
    // For example:
    if (seatId % 2 == 0) {
      return "normal";
    } else {
      return "Vip";
    }
  }

  // Total amount calculation based on ticket details
  double get totalAmount {
    return _selectedTicketDetails.fold(
        0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  void selectBoardingPoint(BreakPlace point) {
    _selectedBoardingPoint = point;
    notifyListeners();
  }

  void select_price_tikect(int price) {
    price_tiket = price;
    notifyListeners();
  }

  void save_price_from_Trip(int price) {
    price_trip = price;
    notifyListeners();
  }

  void selectDeboardingPoint(BreakPlace point) {
    _selectedDeboardingPoint = point;
    notifyListeners();
  }

  void select_from_name(String from_name) {
    from = from_name;
    notifyListeners();
  }

  void select_to_name(String to_name) {
    to = to_name;
    notifyListeners();
  }

  void calculatePrice(int length, int price) {
    print('the lenght is $length');
    print('the price is $price');
    totoal_price = length * price;
    print('the price is $totoal_price');
    notifyListeners();
  }

  void selectBordingBreakPlcaeId(int idBreakPlace) {
    select_place_bording_break_id = idBreakPlace;
    print('the break id select bording  : $select_place_bording_break_id');
    notifyListeners();
  }

  void selectdeBordingBreakPlcaeId(int idBreakPlace) {
    select_place_bording_break_id = idBreakPlace;
    print('the break id select deborading $select_place_bording_break_id');
    notifyListeners();
  }

  void selectBus(BusTrip bus) {
    selectedBus = bus;
    notifyListeners();
  }

  void selectBusTrip(BusResponse bus) {
    selectedBusTrip = bus;
    notifyListeners();
  }

  void selectTripType(int tripType) {
    trip_type = tripType;
    notifyListeners();
  }

  void selectSeat(List<int> seat) {
    selectedSeat = seat;
    notifyListeners();
  }

  void setBreakPlaces(BreakPlace places) {
    breakPlaces = places;
    notifyListeners();
  }

  Future<void> getTripsByPath(
      String accessToken, String from, String to, var companyName) async {
    final response = await http.get(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        Uri.parse(name_domain_server +
            'user/trip_by_path?from=$from&to=$to&company_name=$companyName'));

    if (response.statusCode == 200) {
      final List<dynamic> tripList = json.decode(response.body);
      _trips = tripList.map((json) => TripByPath.fromJson(json)).toList();
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

    if (response.statusCode == 200) {
      final List<dynamic> tripList = json.decode(response.body);
      _alltrips = tripList.map((json) => AllTrips.fromJson(json)).toList();
      print(_alltrips);
      notifyListeners();
    } else {
      throw Exception('Failed to load trips');
    }
  }

  Future<void> make_reservation(String accessToken, int type, List<int> seat,
      int breakId, int bus_trip_id) async {
    final url =
        Uri.parse(name_domain_server + 'user/store_reservation/${bus_trip_id}');
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
}
