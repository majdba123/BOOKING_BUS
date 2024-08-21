import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/Data_Models/Seat.dart';
import 'package:mobile_app/constants.dart';


class SeatApiService {


  Future<List<Seat>> fetchSeatByBusId(String accessToken,var busId) async {
    String url = name_domain_server+"company/all_seat_of_bus/$busId";
    final response = await http.post(
      Uri.parse('$url'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Seat.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Seat');
    }
  }



}