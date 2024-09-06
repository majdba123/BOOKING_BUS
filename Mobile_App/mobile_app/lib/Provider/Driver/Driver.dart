import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/Driver/DriverSerivce.dart';
import 'package:mobile_app/Data_Models/Driver/MyBusModel.dart';
import 'package:mobile_app/Data_Models/Driver/RatingDriverAndSpeed.dart';
import 'package:mobile_app/Data_Models/Driver/TripDeatilesModel.dart';
import 'package:mobile_app/Data_Models/Driver/TripForDriver.dart';

class DriverProvider extends ChangeNotifier {
  TripForDriverModel? _TripDriver;
  List<TripForDriverModel>? _MyTrip;
  List<TripForDriverModel>? _hsitoryTrip;
  TripDeatilesModel? _TripDriverDetail;
  List<String>? _PassengerListAtPivoit;
  List<String>? get PassengerListAtPivoit => _PassengerListAtPivoit;
  RateDriverModel? _RateDriver;
  MyBusModel? _MyBus;
  bool _isLoading = false;
  bool _isStartTrip = false;
  bool _isCheckedReservation = false;
  String? _errorMessage;
  String _typePage = 'alltrip';
  String get typePage => _typePage;
  late int _indextrip;
  late int _indexStop;
  int get indextrip => _indextrip;
  int get indexStop => _indexStop;
  int _currentStopIndex = 0;
  int get currentStopIndex => _currentStopIndex;

  TripForDriverModel? get TripDriver => _TripDriver;
  TripDeatilesModel? get TripDriverDetail => _TripDriverDetail;
  List<TripForDriverModel>? get MyTrip => _MyTrip;
  List<TripForDriverModel>? get hsitoryTrip => _hsitoryTrip;
  RateDriverModel? get RateDriver => _RateDriver;
  MyBusModel? get MyBus => _MyBus;
  bool get isLoading => _isLoading;
  bool get isStartTrip => _isStartTrip;
  bool get isCheckedReservation => _isCheckedReservation;
  String? get errorMessage => _errorMessage;

  void setypePage(type) {
    _typePage = type;
    notifyListeners();
  }

  // void setStartTrip(status) {
  //   _isStartTrip = status;
  //   notifyListeners();
  // }

  void setIndexTrip(index) {
    _indextrip = index;
    notifyListeners();
  }

  void setIndexStop(index) {
    _indexStop = index;
    notifyListeners();
  }

  void setCurrentStopIndex(index) {
    _currentStopIndex = index;
    notifyListeners();
  }

  Future<void> fetchFirstTrip(String accessToken) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _TripDriver = await DriverService().fetchFirstTrip(accessToken);
      print(_TripDriver);
      print('after handling !!');
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMyTrip(String accessToken) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _MyTrip = await DriverService().fetchMyTrip(accessToken);
      print(_MyTrip);
      print('after handling !!');
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> history(String accessToken) async {
    _isLoading = true;
    _errorMessage = null;
    _MyTrip = null;
    notifyListeners();

    try {
      _MyTrip = await DriverService().History(accessToken);
      print(_hsitoryTrip);
      print('after handling !!');
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRateDriver(String accessToken) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _RateDriver = await DriverService().fetchRteDriver(accessToken);
      print(_RateDriver);
      print('after handling !!');
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMyBus(String accessToken) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _MyBus = await DriverService().fetchMyBus(accessToken);
      print(_MyBus);
      print('after handling !!');
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTripsDetails(String accessToken, int busTripId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _TripDriverDetail =
          await DriverService().fetchTripDetailes(accessToken, busTripId);
      print(_MyBus);
      print('after handling !!');
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPassengerAtPivoit(
      String accessToken, int busTripId, int pivot_id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _PassengerListAtPivoit = await DriverService()
          .fetchPassengerAtPivoit(accessToken, busTripId, pivot_id);
      print(_PassengerListAtPivoit);
      print('after handling !!');
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkReservation(
    String accessToken,
    String ReservationId,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _isCheckedReservation =
          await DriverService().checkReservation(accessToken, ReservationId);
      print(_isCheckedReservation);
      print('after handling !!');
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> startTrip(
    String accessToken,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _isStartTrip = await DriverService().startTrip(accessToken);
      print(_isStartTrip);
      print('after start trips!!');
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> accessBreak(
    BuildContext context,
    String accessToken,
    int PivoitId,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await DriverService().accessBreak(context, accessToken, PivoitId);

      print('after acecess Breack !!');
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> finishBreack(
      BuildContext context, String accessToken, int pivoitId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await DriverService().finsishBreack(context, accessToken, pivoitId);
      print(_isCheckedReservation);
      print('after finsinsh breack !!');
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
