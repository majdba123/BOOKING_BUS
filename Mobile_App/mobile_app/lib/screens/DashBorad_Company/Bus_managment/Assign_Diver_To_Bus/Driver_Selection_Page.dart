import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Company/Assign_bus_provider.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Provider/Company/driver_provider.dart';
import 'package:mobile_app/Provider/Login_Provider.dart';

class DriverSelectionPage extends StatefulWidget {
  final String busId;

  DriverSelectionPage({required this.busId});

  @override
  _DriverSelectionPageState createState() => _DriverSelectionPageState(busId: busId);
}

class _DriverSelectionPageState extends State<DriverSelectionPage> {
   final String busId;
  _DriverSelectionPageState({required this.busId});
  

  @override
  void initState() {
    super.initState();
    _fetchDrivers();
  }

  Future<void> _fetchDrivers() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final driverProvider = Provider.of<AssingBusProvider>(context, listen: false);
     driverProvider.fetchDriverByStatus(authProvider.accessToken,'pending');
  }

  void _filterDrivers(String query) {
    final driverProvider = Provider.of<AssingBusProvider>(context, listen: false);
    // setState(() {
    //   driverProvider.Drivers = driverProvider.Drivers
    //       .where((driver) => driver.driverName.toLowerCase().contains(query.toLowerCase()))
    //       .toList();
    // });
  }

  void _assignDriver(int driverId,String busId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final driverProvider = Provider.of<AssingBusProvider>(context, listen: false);
    await driverProvider.AssignDriverToBus(authProvider.accessToken,busId, driverId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$driverId assigned to ${widget.busId}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Driver for ${widget.busId}'),
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
                  if (driverProvider.Drivers.isEmpty) {
                    return Center(child: Text('No drivers found'));
                  }
                  return ListView.builder(
                    itemCount: driverProvider.Drivers.length,
                    itemBuilder: (context, index) {
                      final driver = driverProvider.Drivers[index];
                    
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text('Name : ${driver.user!.name}'),
                          subtitle:Text('Status :${driver.status}') ,
                          trailing: ElevatedButton(
                            onPressed: () {
                              print('the driver id is ');
                              print(driver.id);
                              _assignDriver(driver.id,busId);
                              Navigator.of(context).pop();
                            },
                            child: Text('Assign'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ),
                      );
                    },
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
