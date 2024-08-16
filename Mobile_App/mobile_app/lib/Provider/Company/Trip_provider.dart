// trip_provider.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/Api_Services/Admin/Break_Area.dart';
import 'package:mobile_app/Api_Services/Admin/area.dart';
import 'package:mobile_app/Api_Services/Company/Bus.dart';
import 'package:mobile_app/Api_Services/Company/Trip.dart';
import 'package:mobile_app/Api_Services/Company/path.dart';
import 'package:mobile_app/Data_Models/BUS_Trip.dart';

import 'package:mobile_app/Data_Models/Break_area.dart';
import 'package:mobile_app/Data_Models/Bus.dart';
import 'package:mobile_app/Data_Models/Specfic_Trip.dart';
import 'package:mobile_app/Data_Models/area.dart';
import 'dart:convert';
import 'package:mobile_app/Data_Models/path.dart';
import 'package:mobile_app/Data_Models/Trip.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:provider/provider.dart';


class TripBusProvider with ChangeNotifier {

  List<Path> _paths = [];
  bool _isLoading = false;

  List<Path> get paths => _paths;
  bool get isLoading => _isLoading;
 

  void fetchpaths(String accessToken) async {
   
    _isLoading = true;
    notifyListeners();

    try {
      _paths = await PathApiService().fetchpaths(accessToken);
    } catch (e) {
      print('Failed to fetch paths: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

List<area> _areas = [];


  List<area> get areas => _areas;


 Future <void> fetchareas(String accessToken) async {
    _isLoading = true;
    notifyListeners();

    try {
      _areas = await areaApiService().fetchareas(accessToken);
      
    } catch (e) {
      print('Failed to fetch areas: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

 Future <void> fetchareasbycomapny(String accessToken) async {
    _isLoading = true;
    notifyListeners();

    try {
      _areas = await areaApiService().fetchareascompany(accessToken);
      
    } catch (e) {
      print('Failed to fetch areas: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<BreakArea> _BreakAreas = [];
  

  List<BreakArea> get BreakAreas => _BreakAreas;
  

  void fetchBreakAreas(String accessToken,var breakId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _BreakAreas = await BreakAreaApiService().fetchBreakAreaascompany(accessToken,breakId);
    } catch (e) {
      print('Failed to fetch BreakAreas: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

   List<Bus> _Buss = [];


  List<Bus> get Buss => _Buss;
 

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
 Future<String> addTrip(String accessToken,Trip trip) async {
    String message = await TripBusApi().addTrip(accessToken,trip);
    notifyListeners();
    return message;
  }
   List<BusTrip> _busTripDetails=[];
    List<BusTrip> get busTripDetails => _busTripDetails;

  Future<void> fetchBusTrip(String accessToken) async {
    
    notifyListeners();

    try {
      _busTripDetails = await TripBusApi().fetchTrips(accessToken) ;
    }  finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> deleteTrip(String accessToken, int tripId) async {
    try {
      await TripBusApi().deleteTrip(accessToken, tripId);
      _busTripDetails.removeWhere((trip) => trip.id == tripId);
      notifyListeners();
    } catch (e) {
      print('Error deleting trip: $e');
      throw Exception('Failed to delete trip');
    }
  }



  // List<BusTripStatus> _tripsStatus = [];


  // List<BusTripStatus> get tripsStatus => _tripsStatus;


  // Future<void> fetchTripsByStatus(String accessToken, String status) async {
  //   _isLoading = true;
  //   notifyListeners();

  //   try {
  //     _tripsStatus = await TripBusApi().fetchTripsByStatus(accessToken, status);
  //   } catch (e) {
  //     print('Error fetching trips: $e');
  //     _tripsStatus = [];
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }
  
}
