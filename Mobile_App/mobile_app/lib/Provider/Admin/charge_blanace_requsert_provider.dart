// providers/charge_request_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/Data_Models/charge_blacnce_requset.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/constants.dart';

import 'package:provider/provider.dart';

class ChargeRequestProvider with ChangeNotifier {
  List<ChargeRequest> _requests = [];
  bool _isLoading = false;
  ChargeRequest? _selectedRequest;
  List<ChargeRequest> get requests => _requests;
  bool get isLoading => _isLoading;
  ChargeRequest? get selectedRequest => _selectedRequest;
  final String baseUrl = name_domain_server;

  Future<void> fetchChargeRequests(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final accessToken =
          Provider.of<AuthProvider>(context, listen: false).accessToken;
      final response = await http.get(
        Uri.parse(baseUrl + 'admin/charge_balance_padding'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        _requests = data.map((json) => ChargeRequest.fromJson(json)).toList();
      }
    } catch (error) {
      print('Error fetching charge requests: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> acceptChargeRequest(
      BuildContext context, String requestId) async {
    try {
      final accessToken =
          Provider.of<AuthProvider>(context, listen: false).accessToken;
      final response = await http.post(
        Uri.parse(baseUrl + 'admin/accepted_order_balance/$requestId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        fetchChargeRequests(context); // Refresh the list
      }
    } catch (error) {
      print('Error accepting charge request: $error');
    }
  }

  Future<void> fetchChargeRequestDetails(
      BuildContext context, String requestId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final accessToken =
          Provider.of<AuthProvider>(context, listen: false).accessToken;
      final response = await http.post(
        Uri.parse(baseUrl + 'admin/show_order_balance/$requestId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      print(response.statusCode);
      // print(response.body);
      if (response.statusCode == 200) {
        _selectedRequest = ChargeRequest.fromJson(json.decode(response.body));
      }
    } catch (error) {
      print('Error fetching charge request details: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchChargeRequestsByStatus(
      BuildContext context, String status) async {
    _isLoading = true;
    notifyListeners();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final accessToken =
        authProvider.accessToken; // Get the access token from AuthProvider

    try {
      final response = await http.get(
        Uri.parse(baseUrl + 'admin/charge_balance_by_status?status=$status'),
        headers: {
          'Authorization':
              'Bearer $accessToken', // Include the access token in the Authorization header
        },
      );
      print(response.statusCode);
      // print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        _requests = data.map((json) => ChargeRequest.fromJson(json)).toList();
      } else {
        print('Failed to load data: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error fetching charge requests by status: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
