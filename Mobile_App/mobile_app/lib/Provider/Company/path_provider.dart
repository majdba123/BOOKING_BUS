import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/Company/path.dart';

import 'package:mobile_app/Data_Models/path.dart';


class PathProvider with ChangeNotifier {
  List<Path> _paths = [];
  bool _isLoading = false;

  List<Path> get paths => _paths;
  bool get isLoading => _isLoading;

  void fetchpaths(String accessToken) async {
    _isLoading = true;
    notifyListeners();

    try {
      _paths = await PathApiService().fetchpaths(accessToken);
    } catch (e) {
      print('Failed to fetch paths: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

Future<String> addpath(String accessToken,String from, String to) async {
    String message = await PathApiService().Addpath(accessToken,from, to);
    notifyListeners();
    return message;
  }

  Future<void> updatepath(String token, int id, String from, String to) async {
    try {
      final updatedTrip = await PathApiService().updatepath(token, id, from, to);
      final index = _paths.indexWhere((trip) => trip.id == id);
      if (index != -1) {
        _paths[index] = updatedTrip;
        notifyListeners();
      }
    } catch (error) {
      print(error);
    }
  }
  Future<void> deletepath(String token, int id) async {
    try {
      await PathApiService().deletepath(token, id);
      _paths.removeWhere((trip) => trip.id == id);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
