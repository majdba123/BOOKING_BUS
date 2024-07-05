import 'package:flutter/material.dart';
class CancelDriverPage extends StatefulWidget {
  @override
  _CancelDriverPageState createState() => _CancelDriverPageState();
}

class _CancelDriverPageState extends State<CancelDriverPage> {
  List<String> drivers = [
    'Driver 201',
    'Driver 202',
    'Driver 203',
    // Add more driver entries here
  ];
  List<String> filteredDrivers = [];

  @override
  void initState() {
    super.initState();
    filteredDrivers = drivers;
  }

  void _filterDrivers(String query) {
    setState(() {
      filteredDrivers = drivers
          .where((driver) => driver.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _cancelDriver(String driverId) {
    // Implement the logic to cancel driver from bus here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$driverId cancelled')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cancel Driver'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search Driver by Name or ID',
                border: OutlineInputBorder(),
              ),
              onChanged: _filterDrivers,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredDrivers.length,
                itemBuilder: (context, index) {
                  final driver = filteredDrivers[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(driver),
                      trailing: ElevatedButton(
                        onPressed: () {
                          _cancelDriver(driver);
                        },
                        child: Text('Cancel'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
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
