import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_app/Data_Models/Driver/TripForDriver.dart';

import 'package:mobile_app/constants.dart';

class DriverTripService {
  Future<TripForDriverModel> fetchFirstTrip(String accessToken) async {
    final response = await http.get(
      Uri.parse(name_domain_server + 'driver/first-trip'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonTrip = json.decode(response.body);
      print(jsonTrip);
      print('in json');
      return TripForDriverModel.fromJson(jsonTrip);
    } else {
      throw Exception('Failed to load trips');
    }
  }
}
