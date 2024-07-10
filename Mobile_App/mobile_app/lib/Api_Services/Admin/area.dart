import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/Data_Models/area.dart';
import 'package:mobile_app/constants.dart';


class areaApiService {

Future<String> Addarea(String accessToken,var name ) async {
    String url = name_domain_server+"admin/store_government";
 
    var res = await http.post(
      Uri.parse('$url'),
      body: {'name': name,  },
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

  Future<List<area>> fetchareas(String accessToken) async {
    String url = name_domain_server+"admin/all_government";
    final response = await http.get(
      Uri.parse('$url'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
  print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => area.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load areas');
    }
  }
  Future<List<area>> fetchareascompany(String accessToken) async {
    String url = name_domain_server+"company/all_government";
    final response = await http.get(
      Uri.parse('$url'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
  print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => area.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load areas');
    }
  }
   Future<List<area>> fetchSpecficArea(String accessToken,var id) async {
    String url = name_domain_server+"show_goverment/$id";
    final response = await http.post(
      Uri.parse('$url'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => area.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load areas');
    }
  }
  
  Future<area> updatearea(String accessToken, int id, String name) async {
    print('${name_domain_server}admin/update_government/$id?name=$name');
    final response = await http.put(
      Uri.parse('${name_domain_server}admin/update_government/$id?name=$name'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        
      },
      // body: json.encode({'name': name,}),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return area.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update area');
    }
  }

 Future<void> deletearea(String accessToken, int id) async {
    final response = await http.delete(
      Uri.parse('${name_domain_server}admin/delete_government/$id'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete area');
    }
  }


}