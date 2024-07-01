import 'package:flutter/material.dart';
import 'package:mobile_app/screens/DashBorad_Company/Bus_managment/Bus.dart';

class BusStatusPage extends StatefulWidget {
  @override
  _BusStatusPageState createState() => _BusStatusPageState();
}

class _BusStatusPageState extends State<BusStatusPage> {
  List<Bus> buses = [
    Bus("1234", "45", "pending"),
    Bus("5678", "50", "available"),
    Bus("9876", "30", "finished"),
    Bus("2468", "25", "pending"),
        Bus("2468", "25", "pending"),
            Bus("2468", "25", "pending"),
                Bus("2468", "25", "pending"),
    Bus("1357", "40", "available"),
    Bus("8642", "28", "finished"),
    Bus("8642", "28", "finished"),
    Bus("8642", "28", "finished"),
    Bus("8642", "28", "finished"),
    // Add more bus entries here
  ];

  String _selectedStatus = 'pending';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Status'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Select Bus Status',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: _selectedStatus,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedStatus = newValue!;
                });
              },
              items: <String>['pending', 'available', 'finished']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: buses.length,
                itemBuilder: (context, index) {
                  final bus = buses[index];
                  if (bus.status == _selectedStatus) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Bus Number: ${bus.busNumber}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Number of Passengers: ${bus.passengerNumber}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Status: ${bus.status}',
                              style: TextStyle(
                                fontSize: 16,
                                color: _getStatusColor(bus.status),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color? _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange[900];
      case 'available':
        return Colors.green[900];
      case 'finished':
        return Colors.blue[900];
      default:
        return Colors.black;
    }
  }
}