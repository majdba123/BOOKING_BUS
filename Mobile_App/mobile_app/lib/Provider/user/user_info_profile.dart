import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mobile_app/Data_Models/user_info.dart';
import 'package:mobile_app/constants.dart';

class UserInfoProvider with ChangeNotifier {
  UserInfomodel? _userInfo;
  bool _isLoading = false;
  String? _errorMessage;

  UserInfomodel? get userInfo => _userInfo;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUserInfo(String accessToken) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final url = Uri.parse(name_domain_server + 'user/my_info');
    final headers = {
      'Authorization': 'Bearer $accessToken',
    };

    try {
      final response = await http.get(url, headers: headers);
      print('in user info ');
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _userInfo = UserInfomodel.fromJson(data);
      } else {
        _errorMessage = json.decode(response.body)['message'];
      }
    } catch (error) {
      _errorMessage = error.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
