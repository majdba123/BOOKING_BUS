import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mobile_app/Data_Models/Address_model.dart';
import 'package:mobile_app/Data_Models/Cancel_Rule.dart';
import 'package:mobile_app/Data_Models/LocationOfReservationModel.dart';
import 'package:mobile_app/Data_Models/My_Reservation.dart';
import 'package:mobile_app/Data_Models/Notifaction.dart';
import 'package:mobile_app/Data_Models/charge_balance.dart';
import 'package:mobile_app/constants.dart';

class UserProfile {
  Future<void> chargeBalance(String accessToken, File image, int points) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(name_domain_server + 'user/charge_blance'),
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
      Uri.parse(name_domain_server + 'user/all_my_address'),
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
      Uri.parse(name_domain_server + 'user/store_address'),
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
      Uri.parse(name_domain_server + 'user/update_address/$id'),
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

  Future<List<ChargeBalance>> fetchChargeBalances(
      String status, String accessToken) async {
    final response = await http.get(
      Uri.parse(name_domain_server +
          'user/all_my_charge_balance_by_status?status=$status'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      // body: json.encode({'status': status}),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => ChargeBalance.fromJson(json)).toList();
    } else {
      throw Exception(json.decode(response.body)['error']);
    }
  }

  Future<List<MYReservation>> fetchReservations(
      String status, String accessToken) async {
    final response = await http.get(
      Uri.parse(name_domain_server +
          'user/all_my_reservation_by_status?status=$status'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => MYReservation.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load reservations: ${response.body}');
    }
  }

  Future<List<LocationOFRservation>> fetchLocationOfRservation(
      String accessToken, String id) async {
    print(id);
    print('in fetchLocationOfRservation function');

    final response = await http.get(
      Uri.parse(name_domain_server + 'user/getLocationOfRservation/$id'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      List data = json.decode(response.body);

      return data.map((item) => LocationOFRservation.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load locations: ${response.body}');
    }
  }

  Future<void> CancelRservation(String accessToken, String id) async {
    print(id);
    print('in CancelRservation function');

    final response = await http.post(
      Uri.parse(name_domain_server + 'user/cancel_Reservation/$id'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    print(response.body);
    // if (response.statusCode == 200) {
    //   var message = json.decode(response.body);
    //   if (message == "Reservation canceled successfully") return true;
    // } else {
    //   throw Exception('Failed to load locations: ${response.body}');
    // }
    // return false;
  }

  Future<List<CancelRule>> canceltionRule(
      String accessToken, String nameCompany) async {
    print('in canceltionRule function');
    print('the name of the company is : $nameCompany');

    final response = await http.get(
      Uri.parse(
          name_domain_server + 'user/GetCanceltionRuleforCompany/$nameCompany'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      List data = json.decode(response.body);

      return data.map((item) => CancelRule.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load CancelRule: ${response.body}');
    }
  }

  Future<List<Notifaction>> MyNotifcation(String accessToken) async {
    final response = await http.get(
      Uri.parse(name_domain_server + 'my_notification'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      print(data);
      return data.map((item) => Notifaction.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load notifaction: ${response.body}');
    }
  }
}
