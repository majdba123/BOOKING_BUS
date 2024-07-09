import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/Trip.dart';
import 'package:mobile_app/Data_Models/path.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/constants.dart';
import 'package:http/http.dart' as http;
class TripBusApi {

Future<String> addTrip(String accessToken,Trip trip) async {

    final url = '$name_domain_server+company/store_trip'; 
    final Map<String, dynamic> data = {
      'path_id': trip.pathId,
      'price': trip.price,
      'breaks_ids': trip.breaksIds,
      'bus_ids': trip.busIds.map((bus) => {
        'bus_id': bus.busId,
        'type': bus.type,
        'start_time': bus.startTime,
        'end_time': bus.endTime,
      }).toList(),
    };

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
         'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> parsedJson = json.decode(response.body);
      String message = parsedJson['message'];
      return message;
    } else {
      Map<String, dynamic> parsedJson = json.decode(response.body);
      String error = parsedJson['error'];
      return error;
    }
  }


}
