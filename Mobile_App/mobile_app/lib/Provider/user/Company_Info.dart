import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/User/Company_Info.dart';
import 'package:mobile_app/Data_Models/company.dart';

class CompanyInfoProvider extends ChangeNotifier {
  Company? _company;
  bool _isLoading = false;
  String? _errorMessage;

  Company? get company => _company;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchCompanyInfo(String companyId, String accessToken) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _company =
          await CompanyService().fetchCompanyInfo(companyId, accessToken);
    } catch (error) {
      _errorMessage = error.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
