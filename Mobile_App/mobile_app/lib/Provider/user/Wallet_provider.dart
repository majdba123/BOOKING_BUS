import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/User/User_profile.dart';
import 'package:mobile_app/Data_Models/charge_balance.dart';

class WalletUserProvider with ChangeNotifier {
  final UserProfile _apiService = UserProfile();
  bool _isLoading = false;
  bool get isSLoading => _isLoading;
  List<ChargeBalance> _chargeBalances = [];
  String? get errorMessage => _errorMessage;
  List<ChargeBalance> get chargeBalances => _chargeBalances;
  String? _errorMessage;

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

  Future<void> fetchChargeBalances(String status, String accessToken) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _chargeBalances =
          await _apiService.fetchChargeBalances(status, accessToken);
    } catch (error) {
      _errorMessage = error.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
