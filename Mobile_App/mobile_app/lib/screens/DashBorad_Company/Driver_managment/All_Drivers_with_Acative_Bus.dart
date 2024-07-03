import 'package:flutter/material.dart';



class ActiveDriversPage extends StatefulWidget {
  @override
  _ActiveDriversPageState createState() => _ActiveDriversPageState();
}

class _ActiveDriversPageState extends State<ActiveDriversPage> {
  final List<Driver> drivers = [
    Driver(name: 'John Doe', email: 'john.doe@example.com', busId: '101', isActive: true),
    Driver(name: 'Jane Smith', email: 'jane.smith@example.com', busId: '102', isActive: false),
    Driver(name: 'Michael Johnson', email: 'michael.johnson@example.com', busId: '103', isActive: true),
  ];

  List<Driver> filteredDrivers = [];

  @override
  void initState() {
    super.initState();
    _filterActiveDrivers('');
  }

  void _filterActiveDrivers(String query) {
    setState(() {
      filteredDrivers = drivers
          .where((driver) =>
              driver.isActive &&
              (driver.name.toLowerCase().contains(query.toLowerCase()) ||
              driver.busId.contains(query)))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Drivers with Active Buses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search by Driver Name or Bus ID',
                border: OutlineInputBorder(),
              ),
              onChanged: _filterActiveDrivers,
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredDrivers.length,
                itemBuilder: (context, index) {
                  final driver = filteredDrivers[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://via.placeholder.com/150', // Placeholder image URL
                        ),
                        radius: 30,
                      ),
                      title: Text(driver.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email: ${driver.email}'),
                          Text('Bus ID: ${driver.busId}'),
                        ],
                      ),
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

class Driver {
  final String name;
  final String email;
  final String busId;
  final bool isActive;

  Driver({required this.name, required this.email, required this.busId, required this.isActive});
}
