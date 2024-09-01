import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/Data_Models/inquiry_model.dart';
import 'package:mobile_app/constants.dart';

class InquiryProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  String? successMessage;
  List<Inquiry> inquiries = [];

  Future<void> sendInquiry(
      String email, String question, String accessToken) async {
    final url =
        name_domain_server + 'user/store_quastion'; // Replace with your API URL

    setLoading(true);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'quastion': question,
        }),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        successMessage = 'Inquiry sent successfully!';
        errorMessage = null;
      } else {
        errorMessage = responseData['error'];
        successMessage = null;
      }
    } catch (error) {
      errorMessage = 'Something went wrong. Please try again later.';
      successMessage = null;
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  Future<void> fetchInquiries(String status, String accessToken) async {
    final url = name_domain_server +
        'user/inquires_by_status?status=$status'; // Replace with your API URL

    setLoading(true);

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        inquiries = (responseData as List)
            .map((inquiry) => Inquiry.fromJson(inquiry))
            .toList();
        errorMessage = null;
        successMessage = null;
      } else {
        errorMessage = responseData['error'];
        successMessage = null;
      }
    } catch (error) {
      errorMessage = 'Something went wrong. Please try again later.';
      successMessage = null;
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  Future<void> deleteInquiry(String inquiryId, String accessToken) async {
    final url = name_domain_server +
        'user/delete_inquires/$inquiryId'; // Replace with your API URL

    setLoading(true);

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        inquiries.removeWhere((inquiry) => inquiry.id == inquiryId);
        successMessage = 'Inquiry deleted successfully!';
        errorMessage = null;
      } else {
        final responseData = json.decode(response.body);
        errorMessage = responseData['error'];
        successMessage = null;
      }
    } catch (error) {
      errorMessage = 'Something went wrong. Please try again later.';
      successMessage = null;
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  void clearMessages() {
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }

  void clearInquiries() {
    inquiries = [];
    notifyListeners();
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
