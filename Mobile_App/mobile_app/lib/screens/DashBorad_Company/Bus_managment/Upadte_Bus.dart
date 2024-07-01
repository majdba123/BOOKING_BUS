import 'package:flutter/material.dart';

import 'package:mobile_app/screens/DashBorad_Company/Bus_managment/Bus.dart';

class UpdateBusPage extends StatefulWidget {
  final Bus bus;

  UpdateBusPage({required this.bus});

  @override
  _UpdateBusPageState createState() => _UpdateBusPageState();
}

class _UpdateBusPageState extends State<UpdateBusPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _busNumberController;
  late TextEditingController _passengerNumberController;

  @override
  void initState() {
    super.initState();
    _busNumberController = TextEditingController(text: widget.bus.busNumber);
    _passengerNumberController = TextEditingController(text: widget.bus.passengerNumber);
  }

  @override
  void dispose() {
    _busNumberController.dispose();
    _passengerNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Bus'),
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
                    color: Colors.orange[50],
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
                        'Update Bus Information',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[900],
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _busNumberController,
                        decoration: InputDecoration(
                          labelText: 'Bus Number',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.directions_bus),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the bus number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _passengerNumberController,
                        decoration: InputDecoration(
                          labelText: 'Number of Passengers',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.people),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the number of passengers';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Handle form submission
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Bus Info Updated')),
                            );
                            Navigator.pop(context, {
                              'busNumber': _busNumberController.text,
                              'passengerNumber': _passengerNumberController.text,
                            });
                          }
                        },
                        child: Text('Update Info'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orange[900],
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
  }}