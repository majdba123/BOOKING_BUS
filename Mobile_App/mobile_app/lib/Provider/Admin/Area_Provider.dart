import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/Admin/area.dart';
import 'package:mobile_app/Data_Models/area.dart';

class areaProvider with ChangeNotifier {
  List<area> _areas = [];
  bool _isLoading = false;

  List<area> get areas => _areas;

  bool get isLoading => _isLoading;

  Future<void> fetchareas(String accessToken) async {
    _isLoading = true;
    notifyListeners();

    try {
      _areas = await areaApiService().fetchareas(accessToken);
    } catch (e) {
      print('Failed to fetch areas: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void fetchSpecficArea(String accessToken, var id) async {
    _isLoading = true;
    notifyListeners();

    try {
      _areas = await areaApiService().fetchSpecficArea(accessToken, id);
    } catch (e) {
      print('Failed to fetch areas: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> addarea(
    String accessToken,
    String name,
  ) async {
    String message = await areaApiService().Addarea(accessToken, name);
    notifyListeners();
    return message;
  }

  Future<void> updatearea(String token, String id, String name) async {
    try {
      final updatedarea = await areaApiService().updatearea(token, id, name);
      final index = _areas.indexWhere((area) => area.id == id);
      if (index != -1) {
        _areas[index] = updatedarea;
        notifyListeners();
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> deletearea(String token, String id) async {
    try {
      await areaApiService().deletearea(token, id);
      _areas.removeWhere((area) => area.id == id);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
