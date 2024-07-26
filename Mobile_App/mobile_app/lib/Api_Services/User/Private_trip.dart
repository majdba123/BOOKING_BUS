import 'package:http/http.dart' as http;
import 'package:mobile_app/Data_Models/Private_Trip.dart';
import 'dart:convert';

import 'package:mobile_app/constants.dart';

class PrivateTrip {
  Future<String> storePrivateTrip(String from, String to, String date,
      String startTime, String accessToken) async {
    final url = Uri.parse(name_domain_server + 'user/store_private_trip');
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'from': from,
      'to': to,
      'date': date,
      'start_time': startTime,
    });

    final response = await http.post(url, headers: headers, body: body);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return responseData['message'];
    } else {
      throw Exception('Failed to create private trip');
    }
  }

  Future<List<PrivateTripModel>> getPrivateTripsByStatus(
      String status, String accessToken) async {
    final response = await http.get(
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        Uri.parse(name_domain_server +
            'user/get_my_private_order_by_status?status=$status'));
    // print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((trip) => PrivateTripModel.fromJson(trip))
          .toList();
    } else {
      throw Exception('Failed to load trips');
    }
  }
}
