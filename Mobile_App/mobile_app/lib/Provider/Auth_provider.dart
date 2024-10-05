import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/Login_Api.dart';
import 'package:mobile_app/Data_Models/Auth.dart';
import 'package:mobile_app/constants.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  String _accessToken = '';
  String _userType = '';
  int _statuscode = 0;
  AuthResponse? res;
  late String _message;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String get accessToken => _accessToken;
  String get userType => _userType;
  int get statuscode => _statuscode;
  String get message => _message;
  Future<void> setAuthData(String email, String password) async {
    try {
      res = await LoginApi().lognIn(email, password);
      _accessToken = res!.accessToken;
      _userType = res!.typeUser;
      _statuscode = 200;
    } catch (e) {
      print('Failed to log in: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> register(String email, String name, String password) async {
    try {
      _message = await LoginApi().Register(email, name, password);
      _statuscode = 200;
    } catch (e) {
      print('Failed to log in: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final result = await LoginApi().logout(_accessToken);
    if (result['success']) {
      _accessToken = '';
      notifyListeners();
    }
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> submitProfile(
      BuildContext context, String phone, File? image) async {
    if (image != null && phone.isNotEmpty) {
      setLoading(true);
      try {
        var accessToken = this.accessToken;

        Uri uri;
        if (this.userType == "user") {
          uri = Uri.parse(name_domain_server + 'user/store_profile_info');
        } else if (this.userType == "driver") {
          uri = Uri.parse(name_domain_server + 'driver/store_profile_info');
        } else {
          throw Exception("Invalid user type");
        }

        var request = http.MultipartRequest('POST', uri)
          ..headers['Authorization'] = 'Bearer $accessToken'
          ..fields['phone'] = phone
          ..files.add(await http.MultipartFile.fromPath('image', image.path));

        var response = await request.send();
        var responseBody = await response.stream.bytesToString();

        print('Status Code: ${response.statusCode}');
        print('Response Body: $responseBody');

        if (response.statusCode == 200 || response.statusCode == 201) {
          if (this.userType == "user") {
            // iscomplete = true;

            Navigator.of(context).pushNamedAndRemoveUntil(
                '/mainPageUser', (Route<dynamic> route) => false);
          } else if (this.userType == "driver") {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/driverPageUser', (Route<dynamic> route) => false);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile: $responseBody')),
          );
        }
      } catch (e) {
        print('An error occurred: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'An unexpected error occurred. Please try again later.')),
        );
      } finally {
        setLoading(false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete the form and select an image')),
      );
    }
  }
}
