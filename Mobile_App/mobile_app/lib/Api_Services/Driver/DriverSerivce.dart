import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_app/Data_Models/Driver/MyBusModel.dart';
import 'package:mobile_app/Data_Models/Driver/RatingDriverAndSpeed.dart';
import 'package:mobile_app/Data_Models/Driver/TripForDriver.dart';

import 'package:mobile_app/constants.dart';

class DriverService {
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

  Future<RateDriverModel> fetchRteDriver(String accessToken) async {
    final response = await http.get(
      Uri.parse(name_domain_server + 'driver/all_my_rate'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonRate = json.decode(response.body);
      print(jsonRate);
      print('in json');
      return RateDriverModel.fromJson(jsonRate);
    } else {
      throw Exception('Failed to load trips');
    }
  }

  Future<MyBusModel> fetchMyBus(String accessToken) async {
    final response = await http.get(
      Uri.parse(name_domain_server + 'driver/my_bus'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonRate = json.decode(response.body);
      print(jsonRate);
      print('in json');
      return MyBusModel.fromJson(jsonRate);
    } else {
      throw Exception('Failed to load trips');
    }
  }
}