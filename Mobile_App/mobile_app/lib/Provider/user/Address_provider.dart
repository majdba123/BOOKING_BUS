import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/User/User_profile.dart';
import 'package:mobile_app/Data_Models/Address_model.dart';

class AddressProvider with ChangeNotifier {
  List<Address> _addresses = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final UserProfile _addressService = UserProfile();

  List<Address> get addresses => _addresses;

  Future<void> fetchAddresses(String accessToken) async {
    _isLoading = true;
    notifyListeners();
    try {
      _addresses = await _addressService.getAllAddresses(accessToken);
    } catch (error) {
      // Handle error
      print(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAddress(String city, String area, String accessToken) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _addressService.storeAddress(city, area, accessToken);
      await fetchAddresses(accessToken); // Refresh the list after adding
    } catch (error) {
      // Handle error
      print(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAddress(
      String id, String city, String? area, String accessToken) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _addressService.updateAddress(id, city, area, accessToken);
      await fetchAddresses(accessToken); // Refresh the list after updating
    } catch (error) {
      // Handle error
      print(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
