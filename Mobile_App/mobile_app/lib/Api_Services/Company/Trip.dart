import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/Data_Models/Trip_Model/Trip.dart';


class TripApiService {
  final String apiUrl = 'https://yourdomain.com/company/all_path';

  Future<List<Trip>> fetchTrips(String accessToken) async {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Trip.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load trips');
    }
  }

  Future<void> updateTrip(String accessToken, Trip trip) async {
    final response = await http.put(
      Uri.parse('$apiUrl/${trip.id}'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
       
      },
      body: jsonEncode(trip.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update trip');
    }
  }

  Future<void> deleteTrip(String accessToken, int tripId) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/$tripId'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete trip');
    }
  }
}
