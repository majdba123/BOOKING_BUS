import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mobile_app/Data_Models/Address_model.dart';

class UserProfile {
  static const String baseUrl = 'http://127.0.0.1:8000/api/user';

  Future<void> chargeBalance(String accessToken, File image, int points) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/charge_blance'),
    );
    request.headers['Authorization'] = 'Bearer $accessToken';
    request.fields['point'] = points.toString();
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    var response = await request.send();
    print(response.statusCode);
    // print(response.body);
    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseBody);
      print(jsonResponse);
      return jsonResponse;
    } else {
      throw Exception('Failed to charge balance');
    }
  }

  Future<List<Address>> getAllAddresses(String accessToken) async {
    final response = await http.get(
      Uri.parse('$baseUrl/all_my_address'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((address) => Address.fromJson(address)).toList();
    } else {
      throw Exception('Failed to load addresses');
    }
  }

  Future<void> storeAddress(
      String city, String area, String accessToken) async {
    final response = await http.post(
      Uri.parse('$baseUrl/store_address'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({'city': city, 'area': area}),
    );
    print(response.statusCode);
    // print(response.body);
    if (response.statusCode != 200) {
      throw Exception('Failed to store address');
    }
  }

  Future<void> updateAddress(
      String id, String city, String? area, String accessToken) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update_address/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({'city': city, 'area': area}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update address');
    }
  }
}
