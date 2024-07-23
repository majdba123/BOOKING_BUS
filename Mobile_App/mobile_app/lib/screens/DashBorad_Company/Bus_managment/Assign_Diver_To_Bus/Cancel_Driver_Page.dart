import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Company/Assign_bus_provider.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:provider/provider.dart';
class CancelDriverPage extends StatefulWidget {
  @override
  _CancelDriverPageState createState() => _CancelDriverPageState();
}

class _CancelDriverPageState extends State<CancelDriverPage> {


  @override
  void initState() {
    super.initState();
    _fetchDrivers();
  }
 Future<void> _fetchDrivers() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final driverProvider = Provider.of<AssingBusProvider>(context, listen: false);
     driverProvider.fetchDriverByStatus(authProvider.accessToken,'available');
    print( driverProvider.DriversStauts);
  }
  void _filterDrivers(String query) {
   
  }

  void _cancelDriver(String driverId) {
    // Implement the logic to cancel driver from bus here
final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final driverProvider = Provider.of<AssingBusProvider>(context, listen: false);
     driverProvider.CancelAssignDriver(authProvider.accessToken, driverId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$driverId cancel')),
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
              child: Consumer<AssingBusProvider>(
                builder: (context, driverProvider, _) {
                  if (driverProvider.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (driverProvider.DriversStauts.isEmpty) {
                    return Center(child: Text('No drivers found'));
                  }
                  return ListView.builder(
                itemCount:  driverProvider.DriversStauts.length,
                itemBuilder: (context, index) {
                  final driver =  driverProvider.DriversStauts[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text('${index+1}) ${driver.name}'),
                      subtitle: Text('${driver.status}'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          _cancelDriver(driver.id.toString());
                        },
                        child: Text('Cancel'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                  );
                },
              );
              },))
          ],
        ),
      ),
    );
  }
}
