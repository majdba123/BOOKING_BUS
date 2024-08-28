import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SuggestionsProvider extends ChangeNotifier {
  List<String> _suggestions = [];

  List<String> get suggestions => _suggestions;

  void clearSuggestions() {
    _suggestions = [];
    notifyListeners();
  }

  Future<void> fetchSuggestions(String input, String apiKey) async {
    if (input.isEmpty) {
      clearSuggestions();
      return;
    }

    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final predictions = data['predictions'] as List;

        _suggestions = predictions.map((p) => p['description'] as String).toList();
      } else {
        _suggestions = [];
      }
      notifyListeners();
    } else {
      _suggestions = [];
      notifyListeners();
    }
  }
}
