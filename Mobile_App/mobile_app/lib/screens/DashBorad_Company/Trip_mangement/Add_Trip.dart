import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_app/constants.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/screens/login/login_ui.dart';
class AddTripPage extends StatefulWidget {
  @override
  _AddTripPageState createState() => _AddTripPageState();
}

class _AddTripPageState extends State<AddTripPage> {
  final _formKey = GlobalKey<FormState>();
  final _sourceController = TextEditingController();
  final _destinationController = TextEditingController();

  @override
  void dispose() {
    _sourceController.dispose();
    _destinationController.dispose();
    super.dispose();
  }
  String access_token="2|F6Qt2hWRZ98NGd0UAhcY7PMRoIhuaaVHTDPoYTTEeaa05b04";
Future<String> Addtrip(var From, var To, ) async {
    String url = name_domain_server+"company/path_store";
    print(From);
    print(To);
   
    var res = await http.post(
      Uri.parse('$url'),
      body: {'from': From, 'to': To, },
       headers: <String, String>{
      'Authorization': 'Bearer $access_token',
    },
    );
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
        title: Text('Add Trip'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Add a New Trip',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _sourceController,
                        decoration: InputDecoration(
                          labelText: 'Source',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.place),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the source';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _destinationController,
                        decoration: InputDecoration(
                          labelText: 'Destination',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.place),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the destination';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async{
                          if (_formKey.currentState!.validate()) {
                           
                            showDialog(
                            context: context,
                            builder: (context) => Center(
                                  child: CircularProgressIndicator(),
                                ));
                        var message = await Addtrip(_sourceController.text,_destinationController.text);
                        print('the res is $message');
                        if (message == "driver Created ") {
                        

                          showAlertDialog(context, message as String);
                          Navigator.of(context).pop();
                        } else {
                          showAlertDialog(context, message as String);
                          Navigator.of(context).pop();
                          // Navigator.of(context).pop();
                        }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Trip Added')),
                            );
                            Navigator.pop(context, {
                              'source': _sourceController.text,
                              'destination': _destinationController.text,
                            });
                          }
                        },
                        child: Text('Add Trip'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[900],
                          padding: EdgeInsets.symmetric(vertical: 16),
                          textStyle: TextStyle(fontSize: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
