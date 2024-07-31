import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

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
}
