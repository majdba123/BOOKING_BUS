import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/Company/Bus_sataus.dart';
import 'package:mobile_app/Provider/Login_Provider.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Provider/Company/bus_provider.dart';

class BusStatusPage extends StatefulWidget {
  @override
  _BusStatusPageState createState() => _BusStatusPageState();
}

class _BusStatusPageState extends State<BusStatusPage> {
  String _selectedStatus = 'pending';

  @override
  void initState() {
    super.initState();
    _fetchBusesByStatus(_selectedStatus);
  }

  Future<void> _fetchBusesByStatus(String status) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final busStatusProvider = Provider.of<BusStatusProvider>(context, listen: false);
      await busStatusProvider.fetchBusByStatus(authProvider.accessToken, status);
    } catch (error) {
      print('Error fetching buses: $error');
    }
  }

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
                _fetchBusesByStatus(_selectedStatus);
              },
              items: <String>['pending', 'available', 'completed']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Consumer<BusStatusProvider>(
                builder: (context, busProvider, _) {
                  if (busProvider.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (busProvider.Buss.isEmpty) {
                    return Center(
                      child: Text('No buses found for selected status'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: busProvider.Buss.length,
                      itemBuilder: (context, index) {
                        final bus = busProvider.Buss[index];
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
                                  'Bus Number: ${bus.number_bus}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Number of Passengers: ${bus.number_passenger}',
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
                      },
                    );
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
