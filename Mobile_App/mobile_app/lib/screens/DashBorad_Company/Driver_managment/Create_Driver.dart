import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_app/constants.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/screens/login/login_ui.dart';
class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
 String access_token="2|F6Qt2hWRZ98NGd0UAhcY7PMRoIhuaaVHTDPoYTTEeaa05b04";
Future<String> RegisterDriver(var email, var name, var password) async {
    String url = name_domain_server+"company/register/driver";
    print(email);
    print(password);
    print(name);
    var res = await http.post(
      headers: <String, String>{
      // 'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $access_token',
    },
      Uri.parse('$url'),
      body: {'email': email, 'name': name, 'password': password},
    );
     print(res.body);
    print(res.statusCode);
    if (res.statusCode == 200) {
      Map<String, dynamic> parsedJson = json.decode(res.body);
      String message = parsedJson['message'];
      return message;
    } else {
      Map<String, dynamic> parsedJson = json.decode(res.body);
      String error = parsedJson['error'];
      return error;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Register as Driver',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your email';
                }
                // Add more email validation logic if needed
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a password';
                }
                // Add more password validation logic if needed
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async{
                if (_validateInputs()) {
                  // Perform registration logic here
               

                  // For demonstration, print values to console
                  // print('Name: $name, Email: $email, Password: $password');

                showDialog(
                            context: context,
                            builder: (context) => Center(
                                  child: CircularProgressIndicator(),
                                ));
                        var message = await RegisterDriver(_emailController.text,
                            _nameController.text, _passwordController.text);
                        print('the res is $message');
                        if (message == "driver Created ") {
                        

                          showAlertDialog(context, message as String);
                          Navigator.of(context).pop();
                        } else {
                          showAlertDialog(context, message as String);
                          Navigator.of(context).pop();
                          // Navigator.of(context).pop();
                        }
                }
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateInputs() {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return false;
    }
    return true;
  }
}

