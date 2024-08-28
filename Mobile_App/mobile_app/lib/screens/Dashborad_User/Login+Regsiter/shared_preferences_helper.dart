import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const _keyUserIdList = 'user_id_list';

  // Save list of user IDs to SharedPreferences
  Future<void> saveUserIdList(List<String> userIdList) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(userIdList);
    await prefs.setString(_keyUserIdList, jsonString);
  }

  // Retrieve list of user IDs from SharedPreferences
  Future<List<String>> getUserIdList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyUserIdList);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((e) => e as String).toList();
    }
    return [];
  }

// Example function to add a user ID to the list
  Future<void> addUserId(String userId) async {
    final prefsHelper = SharedPreferencesHelper();
    List<String> userIdList = await prefsHelper.getUserIdList();

    if (!userIdList.contains(userId)) {
      userIdList.add(userId);
      await prefsHelper.saveUserIdList(userIdList);
    }
  }

// Example function to check if a user ID is in the list
  Future<bool> isUserIdInList(String userId) async {
    final prefsHelper = SharedPreferencesHelper();
    List<String> userIdList = await prefsHelper.getUserIdList();
    return userIdList.contains(userId);
  }
}
