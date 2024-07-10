import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/Admin/Break_Area.dart';
import 'package:mobile_app/Data_Models/Break_area.dart';


class BreakAreaProvider with ChangeNotifier {
  List<BreakArea> _BreakAreas = [];
  bool _isLoading = false;

  List<BreakArea> get BreakAreas => _BreakAreas;
  bool get isLoading => _isLoading;

  void fetchBreakAreas(String accessToken,var breakId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _BreakAreas = await BreakAreaApiService().fetchBreakArea(accessToken,breakId);
    } catch (e) {
      print('Failed to fetch BreakAreas: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  


Future<String> addBreakArea(String accessToken,var areaId,String  name,) async {
    String message = await BreakAreaApiService().AddBreakArea(accessToken,areaId,name);
    notifyListeners();
    return message;
  }

  
 

  Future<void> updateBreakArea(String token, int id, String name) async {
    try {
      final updatedBreakArea = await BreakAreaApiService().updateBreakArea(token, id, name);
      final index = _BreakAreas.indexWhere((BreakArea) => BreakArea.id == id);
      if (index != -1) {
        _BreakAreas[index] = updatedBreakArea;
        notifyListeners();
      }
    } catch (error) {
      print(error);
    }
  }
  Future<void> deleteBreakArea(String token, int id) async {
    try {
      await BreakAreaApiService().deleteBreakArea(token, id);
      _BreakAreas.removeWhere((BreakArea) => BreakArea.id == id);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

    void clearBreakAreas() {
    _BreakAreas = [];
    notifyListeners();
  }

}
