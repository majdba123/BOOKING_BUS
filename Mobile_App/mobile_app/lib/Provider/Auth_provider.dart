import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/Login_Api.dart';
import 'package:mobile_app/Data_Models/Auth.dart';

class AuthProvider with ChangeNotifier {
  String _accessToken = '';
  String _userType = '';
  int _statuscode = 0;
  AuthResponse? res;
  late String _message;

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
}
