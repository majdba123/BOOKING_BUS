import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Assuming you're using the http package for API calls
import 'dart:convert';
import 'package:mobile_app/Data_Models/Trip_by_Path.dart';
import 'package:mobile_app/constants.dart'; // To decode JSON responses
class TripuserProvider with ChangeNotifier {
  List<TripByPath> _trips = [];

  List<TripByPath> get trips => _trips;

  Future<void> getTripsByPath(String accessToken,String from, String to) async {
    final response = await http.get( 
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
      Uri.parse(name_domain_server+'user/trip_by_path?from=$from&to=$to'));


    if (response.statusCode == 200) {
      final List<dynamic> tripList = json.decode(response.body);
      _trips = tripList.map((json) => TripByPath.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load trips');
    }
  }

    Future<void> getallTrips(String accessToken) async {
    final response = await http.get( 
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
      Uri.parse(name_domain_server+'user/trips'));


    if (response.statusCode == 200) {
      final List<dynamic> tripList = json.decode(response.body);
      _trips = tripList.map((json) => TripByPath.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load trips');
    }
  }
}