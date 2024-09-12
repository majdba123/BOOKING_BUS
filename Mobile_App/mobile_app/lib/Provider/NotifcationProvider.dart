import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/User/User_profile.dart';
import 'package:mobile_app/Data_Models/Notifaction.dart';

class NotificationProvider extends ChangeNotifier {
  List<Notifaction> _notifications = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _isLoading;
  List<Notifaction> get notifications => _notifications;

  Future<void> fetchNotifications(String accessToken) async {
    _isLoading = true;
    notifyListeners();
    try {
      _notifications = await UserProfile().MyNotifcation(accessToken);
      print(_notifications);
    } catch (error) {
      _errorMessage = 'Failed to fetch notifications. Please try again later.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
