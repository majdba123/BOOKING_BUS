import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/Company/Bus_trip.dart';
import 'package:mobile_app/Api_Services/Company/Trip.dart';
import 'package:mobile_app/Data_Models/Breack_place.dart';
import 'package:mobile_app/Data_Models/SeatModel.dart';
import 'package:mobile_app/Data_Models/show_buss_spsecifc_trip.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/payment/TicketDetailObject.dart';

class BussofSpsccifTripProvider with ChangeNotifier {
  List<BusResponse> _busResponses = [];
  List<SeatModel> _SeatsOfBus = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<BusResponse> get busResponses => _busResponses;
  List<SeatModel> get seats => _SeatsOfBus;

  late int _tripid;

  late int _busTripid;
  // late String _Duration;
  // late String _busId;
  int get tripid => _tripid;
  // String get busId => _busId;

  int get BusTripid => _busTripid;

  // String get Duration => _Duration;

  int _selectedTypeTripIndex = 0;
  late int _selectIndexOfBustrip;
  int get selectedTypeTripIndex => _selectedTypeTripIndex;
  int get selectIndexOfSpsecifcBustrip => _selectIndexOfBustrip;
  late List<String> selectedSeat;
  List<TicketDetail> _selectedTicketDetails = [];
  late int select_place_bording_break_id;

  // Getter for the selected ticket details
  List<TicketDetail> get selectedTicketDetails => _selectedTicketDetails;
  int totoal_price = 0;
  BreakPlace? _selectedBoardingPoint;

  BreakPlace? get selectedBoardingPoint => _selectedBoardingPoint;

  void selectBoardingPoint(BreakPlace point) {
    _selectedBoardingPoint = point;
    notifyListeners();
  }

  void selectBordingBreakPlcaeId(int idBreakPlace) {
    select_place_bording_break_id = idBreakPlace;
    print('the break id select bording  : $select_place_bording_break_id');
    notifyListeners();
  }

  void selectIndexOfBustrip(int selectIndexOfBustrip) {
    _selectIndexOfBustrip = selectIndexOfBustrip;
    notifyListeners();
  }

  void addTicketDetail(TicketDetail detail) {
    _selectedTicketDetails.add(detail);
    notifyListeners();
  }

  void calculatePrice(int length, int price) {
    print('the lenght is $length');
    print('the price is $price');
    totoal_price = length * price;
    print('the price is $totoal_price');
    notifyListeners();
  }

  void selectSeat(List<String> seat) {
    selectedSeat = seat;
    notifyListeners();
  }

  void setTypeTripIndex(int index) {
    _selectedTypeTripIndex = index;
    notifyListeners();
  }

  void setTripid(tripid) {
    _tripid = tripid;
    notifyListeners();
  }

  // void setBusid(busid) {
  //   _busId = busid;
  //   notifyListeners();
  // }

  void setBusTripid(Bustripid) {
    _busTripid = Bustripid;
    notifyListeners();
  }

  Future<void> getBussofSpecicTrip(int tripId, String accessToken) async {
    _isLoading = true;
    notifyListeners();
    try {
      print('try!!!!');
      _busResponses =
          await TripBusApi().fetch_buss_of_spsecifc_trip(accessToken, tripId);
      print(_busResponses);
      print('the bus response $_busResponses');
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getSeatOfBusTrip(int busTripId, String accessToken) async {
    _isLoading = true;
    // notifyListeners();
    try {
      // Replace with your API call logic
      print('try!!!!');
      _SeatsOfBus = await TripStatus().fetchSeatOfBus(accessToken, busTripId);
      notifyListeners();
      // print('-----------------------');
      // print(_SeatsOfBus);
      // print('the _SeatsOfBus response $_busResponses');
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
