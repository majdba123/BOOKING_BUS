import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mobile_app/constants.dart';

class PasswordProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> updatePassword(String currentPassword, String newPassword,
      String newPasswordConfirmation, String accessToken) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final url = Uri.parse(name_domain_server + 'user/update_password');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    final body = json.encode({
      'current_password': currentPassword,
      'new_password': newPassword,
      'new_password_confirmation': newPasswordConfirmation,
    });

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Handle successful password update
        _errorMessage = null;
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
