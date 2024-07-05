import 'package:flutter/material.dart';
import 'package:mobile_app/screens/DashBorad_Company/Bus_managment/Bus.dart';
import 'package:mobile_app/screens/DashBorad_Company/Bus_managment/Upadte_Bus.dart';


class BusListPage extends StatefulWidget {
  @override
  _BusListPageState createState() => _BusListPageState();
}

class _BusListPageState extends State<BusListPage> {
  List<Bus> buses = [
    Bus("1234", "45","pending"),
    Bus("5678", "50","pending"),
    // Add more bus entries here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Buses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: buses.length,
          itemBuilder: (context, index) {
            final bus = buses[index];
            return Card(
              margin: EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Bus Number: ${bus.busNumber}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Number of Passengers: ${bus.passengerNumber}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            _navigateToUpdateBus(context, bus);
                          },
                          child: Text(
                            'Update',
                            style: TextStyle(color: Colors.orange[900]),
                          ),
                        ),
                        SizedBox(width: 16),
                        TextButton(
                          onPressed: () {
                            _confirmDeleteBus(context, bus);
                          },
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.red[900]),
                          ),
                        ),
                        SizedBox(width: 16),
                        TextButton(
                          onPressed: () {
                            _confirmDeleteBus(context, bus);
                          },
                          child: Text(
                            'All setas',
                            style: TextStyle(color: Colors.red[900]),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _navigateToUpdateBus(BuildContext context, Bus bus) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateBusPage(bus: bus)),
    );
  }

  void _confirmDeleteBus(BuildContext context, Bus bus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this bus?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  buses.remove(bus);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Bus Deleted')),
                );
                Navigator.pop(context);
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red[900]),
              ),
            ),
          ],
        );
      },
    );
  }}