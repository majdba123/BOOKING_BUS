import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/Data_Models/Specfic_Trip.dart';
import 'package:mobile_app/Data_Models/Trips_Status.dart';
import 'package:mobile_app/constants.dart';
class TripStatus{

Future<List<TripByStatus>> fetchTripsByStatus(String accessToken, String status) async {
    print(accessToken);
    print(name_domain_server+"company/all_trips_by_status?status=$status");
    final url = Uri.parse(name_domain_server+"company/all_trips_by_status?status=$status");
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      // body: json.encode({'status': status}),
    );
  print(response.body);
  print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => TripByStatus.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load trips: ${response.statusCode}');
    }
  }


  Future<List<SpecificTrip>> fetchSpecifcTrip(String accessToken, int tripid) async {
    print(accessToken);
    print(name_domain_server+"company/show_trip/$tripid");
    final url = Uri.parse(name_domain_server+"company/show_trip/$tripid");
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      // body: json.encode({'status': status}),
    );
  print(response.body);
  print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => SpecificTrip.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load trips: ${response.statusCode}');
    }
  }
  }