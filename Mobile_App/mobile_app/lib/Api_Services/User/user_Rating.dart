// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/Data_Models/Driver.dart';
import 'package:mobile_app/Data_Models/Driver_Status.dart';
import 'package:mobile_app/Data_Models/UserFavCompany.dart';
import 'package:mobile_app/Data_Models/company.dart';
import 'package:mobile_app/constants.dart';

class RatingApiServices {
  final String accessToken;

  RatingApiServices(this.accessToken);

  Future<List<Company>> fetchCompanies() async {
    print('fetch compaines');
    final response = await http.get(
      Uri.parse(name_domain_server + 'user/get_all_company'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    // print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((company) => Company.fromJson(company)).toList();
    } else {
      throw Exception('Failed to load companies');
    }
  }

  Future<List<Driver>> fetchDrivers() async {
    print('fetch drivers ');
    final response = await http.get(
      Uri.parse(name_domain_server + 'user/get_all_driver'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((driver) => Driver.fromJson(driver)).toList();
    } else {
      throw Exception('Failed to load drivers');
    }
  }

  Future<String> addCompanyToFavorite(int companyId) async {
    print('addd it to Fav function !! api ');
    final response = await http.post(
      Uri.parse(name_domain_server + 'user/add_company_to_favourite'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({'company_id': companyId}),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return "Company added to favorites successfully";
    } else {
      return "Failed to add company to favorites";
    }
  }

  Future<String> removeCompanyFromFavorite(int companyId) async {
    print('cancel remove to add fav api!!!');
    final response = await http.delete(
      Uri.parse(name_domain_server + 'user/remove_company_from_favourite'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({'company_id': companyId}),
    );
    if (response.statusCode == 200) {
      return "Company removed from favorites successfully";
    } else {
      return "Failed to remove company from favorites";
    }
  }

  Future<String> rateDriver(int driverId, int rating) async {
    final response = await http.post(
      Uri.parse(name_domain_server + 'user/rate_driver/$driverId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({'num': rating}),
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData["message"];
    } else {
      return "Failed to rate driver";
    }
  }
}
