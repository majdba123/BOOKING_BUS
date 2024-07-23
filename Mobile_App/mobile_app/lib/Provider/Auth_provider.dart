import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/Login_Api.dart';
import 'package:mobile_app/Data_Models/Auth.dart';

class AuthProvider with ChangeNotifier {
  String _accessToken = '';
  String _userType = '';

  AuthResponse? res;

  String get accessToken => _accessToken;
  String get userType => _userType;

  Future<void> setAuthData(String email, String password) async {
    try {
      res = await LoginApi().lognIn(email, password);
      _accessToken = res!.accessToken;
      _userType = res!.typeUser;
    } catch (e) {
      print('Failed to log in: $e');
    } finally {
      notifyListeners();
    }
  }

  void logout() {
    _accessToken = '';
    _userType = '';
    // Clear other user data if necessary
    notifyListeners();
  }
}
