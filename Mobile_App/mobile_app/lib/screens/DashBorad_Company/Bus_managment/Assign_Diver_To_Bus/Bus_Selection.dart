import 'package:flutter/material.dart';
import 'package:mobile_app/screens/DashBorad_Company/Bus_managment/Assign_Diver_To_Bus/Driver_Selection_Page.dart';
class BusSelectionPage extends StatefulWidget {
  @override
  _BusSelectionPageState createState() => _BusSelectionPageState();
}

class _BusSelectionPageState extends State<BusSelectionPage> {
  List<String> buses = [
    'Bus 101',
    'Bus 102',
    'Bus 103',
    // Add more bus entries here
  ];
  List<String> filteredBuses = [];

  @override
  void initState() {
    super.initState();
    filteredBuses = buses;
  }

  void _filterBuses(String query) {
    setState(() {
      filteredBuses = buses
          .where((bus) => bus.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Bus'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search Bus by ID',
                border: OutlineInputBorder(),
              ),
              onChanged: _filterBuses,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredBuses.length,
                itemBuilder: (context, index) {
                  final bus = filteredBuses[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(bus),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DriverSelectionPage(busId: bus),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
