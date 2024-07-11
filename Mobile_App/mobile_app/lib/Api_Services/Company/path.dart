import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/Data_Models/path.dart';
import 'package:mobile_app/constants.dart';


class PathApiService {
  // final String apiUrl = ;
Future<String> Addpath(String accessToken,var From, var To, ) async {
    String url = name_domain_server+"company/path_store";
    print(From);
    print(To);
   
    var res = await http.post(
      Uri.parse('$url'),
      body: {'from': From, 'to': To, },
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

  Future<List<Path>> fetchpaths(String accessToken) async {
    String url = name_domain_server+"company/all_path";
    final response = await http.get(
      Uri.parse('$url'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Path.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load paths');
    }
  }
  
  Future<Path> updatepath(String accessToken, int id, String from, String to) async {
    print(id);
    print(from);
    print(to);
    // print('${name_domain_server}company/path_update/$id?from=$from&to=$to');
    final response = await http.put(
      Uri.parse('${name_domain_server}company/path_update/$id?from=$from&to=$to'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        // 'Content-Type': 'application/json',
      },
      body: json.encode({'from': from, 'to': to}),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      return Path.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update path');
    }
  }

 Future<void> deletepath(String accessToken, int id) async {
  print('${name_domain_server}company/path_delete/$id');
    final response = await http.delete(
      Uri.parse('${name_domain_server}company/path_delete/$id'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
  print(response.body);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete path');
    }
  }


}