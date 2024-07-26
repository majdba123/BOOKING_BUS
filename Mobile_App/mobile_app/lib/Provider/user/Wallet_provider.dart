import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/User/User_profile.dart';

class WalletProvider with ChangeNotifier {
  final UserProfile _apiService = UserProfile();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> chargeBalance(String accessToken, File image, int points) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _apiService.chargeBalance(accessToken, image, points);
    } catch (e) {
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
