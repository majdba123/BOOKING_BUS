import 'package:http/http.dart' as http;
import 'package:mobile_app/Data_Models/Private_Trip.dart';
import 'package:mobile_app/Data_Models/Private_Trip_accepted_By_Comapny_.dart';
import 'dart:convert';

import 'package:mobile_app/constants.dart';

class PrivateTrip {
  Future<String> storePrivateTrip(
      String from,
      String to,
      String date,
      String startTime,
      String accessToken,
      String Distance,
      double lat_from,
      double long_from,
      double lat_to,
      double long_to) async {
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
      'Distance': Distance,
      'lat_from': lat_from,
      'long_from': long_from,
      'lat_to': lat_to,
      'long_to': long_to,
    });
    print(body);

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

  Future<List<PrivateTripAccpetedBycompanyModel>>
      getPrivateTripsRequsetAcceptedByCompany(
          int privateTripId, String accessToken) async {
    print('in get acceperte comapny ');
    final response = await http.get(
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        Uri.parse(name_domain_server +
            'user/OrderPrivateTripController/$privateTripId'));
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((trip) => PrivateTripAccpetedBycompanyModel.fromJson(trip))
          .toList();
    } else {
      throw Exception('Failed to load trips');
    }
  }

  Future<void> acceptPrivateOrder(
      String accessToken, String ordertripId) async {
    final response = await http.post(
      Uri.parse(
          name_domain_server + 'user/accept_company_for_private/$ordertripId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      // body: json.encode({'price': price}),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to accept private order +${jsonDecode(response.body)} ');
    }
  }
}
