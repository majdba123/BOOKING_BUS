import 'package:flutter/material.dart';

class StoreBusPage extends StatefulWidget {
  @override
  _StoreBusPageState createState() => _StoreBusPageState();
}

class _StoreBusPageState extends State<StoreBusPage> {
  final _formKey = GlobalKey<FormState>();
  final _busNumberController = TextEditingController();
  final _passengerNumberController = TextEditingController();

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
        title: Text('Store Bus Info'),
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
                        'Add Bus Information',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                      // SizedBox(height: 16),
                      // Image.asset(
                      //   'assets/bus_image.png',
                      //   height: 150,
                      // ),
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
                              SnackBar(content: Text('Bus Info Stored')),
                            );
                            Navigator.pop(context, {
                              'busNumber': _busNumberController.text,
                              'passengerNumber': _passengerNumberController.text,
                            });
                          }
                        },
                        child: Text('Store Info'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue[900],
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
