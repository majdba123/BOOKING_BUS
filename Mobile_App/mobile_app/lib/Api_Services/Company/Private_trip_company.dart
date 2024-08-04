// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/Data_Models/PrivateTripCompany.dart';
import 'package:mobile_app/constants.dart';

class PrivateTripComp {
  Future<List<PrivateTripCompany>> getAllPrivateTrips(
      String accessToken) async {
    final response = await http.get(
      Uri.parse(name_domain_server + 'company/private_trips'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => PrivateTripCompany.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load private trips');
    }
  }
}
