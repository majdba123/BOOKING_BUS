import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/Data_Models/Driver.dart';
import 'package:mobile_app/Data_Models/DriverBusActive.dart';
import 'package:mobile_app/Data_Models/Driver_Status.dart';
import 'package:mobile_app/constants.dart';


class DriverApiService {
  // final String apiUrl = ;
Future<String> addDriver(String accessToken, String name, String email, String password) async {
  final url = Uri.parse(name_domain_server + "company/register/driver");
  final headers = {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
  };
  final body = jsonEncode({
    'email': email,
    'name': name,
    'password': password,
  });

  // Logging the request details
  print('Request URL: $url');
  print('Request headers: $headers');
  print('Request body: $body');

  try {
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    // Logging the response details
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      return responseBody['message'];
    } else if (response.statusCode == 422) {
      var responseBody = json.decode(response.body);
      if (responseBody['error'] != null) {
        if (responseBody['error'] is Map) {
          return responseBody['error'].values.expand((e) => e).join('\n');
        } else {
          return responseBody['error'];
        }
      } else {
        return 'Validation error';
      }
    } else {
      return 'Failed to register driver';
    }
  } catch (e) {
    print('Exception: $e');
    return 'Network error: Failed to connect to the server';
  }
}
Future<String> AssignDriverToBus(String accessToken,var bus_id ,var driver_id ) async {
    String url = name_domain_server+"company/select_driver_to_bus/$bus_id";
  print(bus_id);
  print(driver_id);
   print(url);
    var res = await http.post(
      Uri.parse('$url'),
      body: {'driver_id': driver_id.toString()  },
       headers: <String, String>{
      'Authorization': 'Bearer $accessToken',
     
    },
    );
    print(res.statusCode);
    if (res.statusCode == 200) {
      Map<String, dynamic> parsedJson = json.decode(res.body);
      String message = parsedJson['message'];
      return message;
    } else {
      Map<String, dynamic> parsedJson = json.decode(res.body);
      String error = parsedJson['error'];
      return error;
    }
  }

Future<String> CancelAssignDriver(String accessToken,var driver_id ) async {
    String url = name_domain_server+"company/cancelled_driver/$driver_id";

   
    var res = await http.post(
      Uri.parse('$url'),
      // body: {'driver_id ': driver_id  },
       headers: <String, String>{
      'Authorization': 'Bearer $accessToken',
    },
    );
    print(res.statusCode);
    if (res.statusCode == 200) {
      Map<String, dynamic> parsedJson = json.decode(res.body);
      String message = parsedJson['message'];
      return message;
    } else {
      Map<String, dynamic> parsedJson = json.decode(res.body);
      String error = parsedJson['error'];
      return error;
    }
  }


  Future<List<Driver>> fetchDrivers(String accessToken) async {
    String url = name_domain_server+"company/all_driver";
    print(url);
    final response = await http.get(
      Uri.parse('$url'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
  // print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Driver.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Driver');
    }
  }
  Future<List<DriverBusActive>> fetchDriversOnActiveBus(String accessToken) async {
    String url = name_domain_server+"company/all_driver_with_bus";
    final response = await http.get(
      Uri.parse('$url'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
print(url);
print(response.statusCode);
print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      
      return jsonList.map((json) => DriverBusActive.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Driver');
    }
  }
   Future<List<DriverStauts>> fetchDriverByStatus(String accessToken,String Status) async {
    String url = name_domain_server+"company/get_driver_by_status?status=$Status";
    print(url);
    final response = await http.get(
      Uri.parse('$url'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
  print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => DriverStauts.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Driver');
    }
  }

  // Future<Driver> updateDriver(String accessToken,var number_Driver ,int id, var number_passenger ) async {
  //   print('${name_domain_server}company/update_Driver/$id');
  //   final response = await http.put(
  //     Uri.parse('${name_domain_server}company/update_Driver/$id'),
  //     headers: {
  //       'Authorization': 'Bearer $accessToken',
        
  //     },
  //     body: json.encode({'number_Driver': number_Driver, 'number_passenger': number_passenger}),
  //   );
  //   print(response.statusCode);
  //   if (response.statusCode == 200) {
  //     return Driver.fromJson(json.decode(response.body));
  //   } else {
  //     throw Exception('Failed to update Driver');
  //   }
  // }

 Future<void> deleteDriver(String accessToken, int id) async {
    final response = await http.delete(
      Uri.parse('${name_domain_server}company/delete_driver/$id'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete Driver');
    }
  }


}