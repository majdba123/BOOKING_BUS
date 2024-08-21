import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:mobile_app/constants.dart';

class updateProfileProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> updateProfile(File? image, String phone, String name,
      String email, String accessToken) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final url = Uri.parse(name_domain_server + 'user/update_profile_info');
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
    final request = http.MultipartRequest('POST', url)
      ..headers.addAll(headers)
      ..fields['phone'] = phone
      ..fields['name'] = name
      ..fields['email'] = email;

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    try {
      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);
      print(response.statusCode);
      if (response.statusCode == 200) {
        // Handle successful profile update
        _errorMessage = null;
      } else {
        _errorMessage = json.decode(responseBody.body)['message'];
      }
    } catch (error) {
      _errorMessage = error.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
