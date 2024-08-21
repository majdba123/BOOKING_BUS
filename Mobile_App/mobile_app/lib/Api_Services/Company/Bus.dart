import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/Data_Models/Bus.dart';
import 'package:mobile_app/constants.dart';

class BusApiService {
  // final String apiUrl = ;
  Future<String> AddBus(
      String accessToken, var number_bus, var number_passenger) async {
    final url = Uri.parse(name_domain_server + "company/store_bus");
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'number_bus': number_bus,
      'number_passenger': number_passenger,
    });

    // Logging the request details
    print('Request URL: $url');
    print('Request headers: $headers');
    print('Request body: $body');

    final res = await http.post(
      url,
      headers: headers,
      body: body,
    );

    // Logging the response details
    print('Response status: ${res.statusCode}');
    // print('Response body: ${res.body}');

    print(accessToken);
    print(number_bus);
    print(number_passenger);

    if (res.statusCode == 200) {
      Map<String, dynamic> parsedJson = json.decode(res.body);
      String message = parsedJson['message'];
      return message;
    } else {
      Map<String, dynamic> parsedJson = json.decode(res.body);
      String error = parsedJson['error'];
      print(error);
      return error;
    }
  }

  Future<List<Bus>> fetchBus(String accessToken) async {
    String url = name_domain_server + "company/all_bus";
    final response = await http.get(
      Uri.parse('$url'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Bus.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Bus');
    }
  }

  Future<List<Bus>> fetchBusByStatus(String accessToken, String Status) async {
    String url = name_domain_server + "company/get_bus_status?status=$Status";
    // print(url);
    final response = await http.get(
      Uri.parse('$url'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
    // print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      // print(jsonList);
      return jsonList.map((json) => Bus.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Bus');
    }
  }

  Future<Bus> updateBus(
      String accessToken, var number_bus, int id, var number_passenger) async {
    print(number_bus);
    print(number_passenger);
    print(
        '${name_domain_server}company/update_bus/$id?number_bus=$number_bus&&number_passenger=$number_passenger');
    final response = await http.put(
      Uri.parse(
          '${name_domain_server}company/update_bus/$id?number_bus=$number_bus&&number_passenger=$number_passenger'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode(
          {'number_bus': number_bus, 'number_passenger': number_passenger}),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      return Bus.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update Bus');
    }
  }

  Future<void> deleteBus(String accessToken, int id) async {
    final response = await http.delete(
      Uri.parse('${name_domain_server}company/delete_bus/$id'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete Bus');
    }
  }
}
