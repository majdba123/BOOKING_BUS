import 'package:http/http.dart' as http;
import 'package:mobile_app/Data_Models/company.dart';
import 'dart:convert';

import 'package:mobile_app/constants.dart';

class CompanyService {
  Future<Company> fetchCompanyInfo(int companyId, String accessToken) async {
    final response = await http.post(
      Uri.parse(name_domain_server + 'user/show_info_about_company/$companyId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      return Company.fromJson(json.decode(response.body));
    } else {
      throw Exception(json.decode(response.body)['message']);
    }
  }
}
