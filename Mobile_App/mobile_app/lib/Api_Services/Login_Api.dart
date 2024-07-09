import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/Auth.dart';
import 'package:mobile_app/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginApi{

  Future<AuthResponse> lognIn(var email, var password) async {
    String url = name_domain_server +"login";
    print(email);
    print(password);
    var res = await http.post(
      Uri.parse('$url'),
      body: {'email': email, 'password': password},
    );
    print(res.statusCode);
    if (res.statusCode == 200) {
      Map<String, dynamic> parsedJson = json.decode(res.body);
      return AuthResponse.fromJson(parsedJson);
    } else {
      Map<String, dynamic> parsedJson = json.decode(res.body);
      String message = parsedJson['message'];
      throw Exception(message);
    }
}}