import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/BUS_Trip.dart';
import 'package:mobile_app/Data_Models/Specfic_Trip.dart';
import 'package:mobile_app/Data_Models/Trip.dart';
import 'package:mobile_app/Data_Models/path.dart';
import 'package:mobile_app/Data_Models/show_buss_spsecifc_trip.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/constants.dart';
import 'package:http/http.dart' as http;

class TripBusApi {
  Future<String> addTrip(String accessToken, Trip trip) async {
    print(accessToken);

    String url = name_domain_server + "company/store_trip";
    final Map<String, dynamic> data = {
      'path_id': trip.pathId,
      'price': trip.price,
      'breaks_ids': trip.breaksIds,
      'bus_ids': trip.busIds
          .map((bus) => {
                'bus_id': bus.busId,
                'type': bus.type,
                'start_time': bus.startTime,
                'end_time': bus.endTime,
                'date': bus.date,
              })
          .toList(),
    };
    print(jsonEncode(data));
    final response = await http.post(
      Uri.parse('$url'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(data),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      // Map<String, dynamic> parsedJson = json.decode(response.body);
      String message = "trip created";
      return message;
    } else {
      Map<String, dynamic> parsedJson = json.decode(response.body);
      String error = parsedJson['error'];
      return error;
    }
  }

  Future<List<BusTrip>> fetchTrips(String accessToken) async {
    print(accessToken);
    String url = name_domain_server + "company/all_trips";
    final response = await http.get(
      Uri.parse('$url'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
    );
    print(response.statusCode);
    // print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => BusTrip.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load bus trip details');
    }
  }

  Future<List<BusResponse>> fetch_buss_of_spsecifc_trip(
      String accessToken, int trip_id) async {
    print(accessToken);
    String url = name_domain_server + "user/get_bus_trip/$trip_id";
    final response = await http.post(
      Uri.parse('$url'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    print('this status code ${response.statusCode}');
    // print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);

      return jsonList.map((json) => BusResponse.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load bus trip details');
    }
  }

  Future<void> deleteTrip(String accessToken, int tripId) async {
    final url = Uri.parse(name_domain_server +
        "company/delete_trip/$tripId"); // Adjust endpoint as per your API
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete trip: ${response.statusCode}');
    }
  }

  //  Future<List<BusTripStatus>> fetchTripsByStatus(String accessToken, String status) async {
  //   final url = Uri.parse(name_domain_server+"company/all_trips_by_status?status=$status");
  //   final response = await http.post(
  //     url,
  //     headers: {
  //       'Authorization': 'Bearer $accessToken',
  //       'Content-Type': 'application/json',
  //     },
  //     body: json.encode({'status': status}),
  //   );

  //   if (response.statusCode == 200) {
  //     List<dynamic> jsonList = json.decode(response.body);
  //     return jsonList.map((json) => BusTripStatus.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load trips: ${response.statusCode}');
  //   }
  // }
}
