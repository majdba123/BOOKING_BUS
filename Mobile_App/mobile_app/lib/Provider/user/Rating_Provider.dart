// providers/user_provider.dart
import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/User/user_Rating.dart';
import 'package:mobile_app/Data_Models/Driver.dart';
import 'package:mobile_app/Data_Models/Driver_Status.dart';
import 'package:mobile_app/Data_Models/UserFavCompany.dart';
import 'package:mobile_app/Data_Models/company.dart';

class RatingUserProvider with ChangeNotifier {
  List<Company> _companies = [];
  List<Driver> _drivers = [];
  List<UserFavorite> _favorites = [];
  RatingApiServices? _apiService;

  List<Company> get companies => _companies;
  List<Driver> get drivers => _drivers;
  List<UserFavorite> get favorites => _favorites;

  void setAccessToken(String token) {
    _apiService = RatingApiServices(token);
  }

  Future<void> fetchCompanies() async {
    if (_apiService == null) return;
    try {
      _companies = await _apiService!.fetchCompanies();
      notifyListeners();
    } catch (e) {
      print('Failed to fetch companies: $e');
    }
  }

  Future<void> fetchDrivers() async {
    if (_apiService == null) return;
    try {
      _drivers = await _apiService!.fetchDrivers();
      notifyListeners();
    } catch (e) {
      print('Failed to fetch drivers: $e');
    }
  }

  Future<String> addCompanyToFavorite(int companyId) async {
    print('api provider rating');
    if (_apiService == null) return "API service not initialized";
    String message = await _apiService!.addCompanyToFavorite(companyId);
    if (message == "Company added to favorites successfully") {
      _favorites.add(UserFavorite(companyId: companyId));
      notifyListeners();
    }
    return message;
  }

  Future<String> removeCompanyFromFavorite(int companyId) async {
    print('canel add to Fav');
    if (_apiService == null) return "API service not initialized";
    String message = await _apiService!.removeCompanyFromFavorite(companyId);
    if (message == "Company removed from favorites successfully") {
      _favorites.removeWhere((fav) => fav.companyId == companyId);
      notifyListeners();
    }
    return message;
  }

  Future<String> rateDriver(int driverId, int rating) async {
    if (_apiService == null) return "API service not initialized";
    return await _apiService!.rateDriver(driverId, rating);
  }
}
