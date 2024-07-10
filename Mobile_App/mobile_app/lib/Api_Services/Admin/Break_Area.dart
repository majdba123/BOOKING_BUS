import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/Data_Models/Break_area.dart';

import 'package:mobile_app/constants.dart';


class BreakAreaApiService {

Future<String> AddBreakArea(String accessToken,var areaId,var name ) async {
    String url = name_domain_server+"admin/store_breaks/$areaId";
 
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

  Future<List<BreakArea>> fetchBreakArea(String accessToken,var areaId ) async {
    String url = name_domain_server+"company/all_breaks/$areaId";
    final response = await http.get(
      Uri.parse('$url'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
  print(response.statusCode);
  // print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => BreakArea.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load BreakAreas');
    }
  }
  
  
  Future<BreakArea> updateBreakArea(String accessToken, int breakId,var name) async {
    // print('${name_domain_server}admin/update_government');
    print('${name_domain_server}admin/update_breaks/$breakId');
    final response = await http.put(
      Uri.parse('${name_domain_server}admin/update_breaks/$breakId?name=$name'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        
      },
      
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return BreakArea.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update BreakArea');
    }
  }

 Future<void> deleteBreakArea(String accessToken, int breakId) async {
    final response = await http.delete(
      Uri.parse('${name_domain_server}admin/delete_breaks/$breakId'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete BreakArea');
    }
  }


}