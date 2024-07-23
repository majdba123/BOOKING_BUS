import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/DriverBusActive.dart';
import 'package:mobile_app/Provider/Company/Driver_Provider.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:provider/provider.dart';

class ActiveDriversPage extends StatefulWidget {
  @override
  _ActiveDriversPageState createState() => _ActiveDriversPageState();
}

class _ActiveDriversPageState extends State<ActiveDriversPage> {
  bool _initialized = false;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      Provider.of<DriverProvider>(context, listen: false)
          .fetchDriversOnActiveBus(authProvider.accessToken)
          .then((_) {
        if (mounted) {
          setState(() {
            _initialized = true;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final driverProvider = Provider.of<DriverProvider>(context);
    final List<DriverBusActive> drivers = driverProvider.DriversBusActive;
    final bool isLoading = !_initialized || driverProvider.isLoading;

    // Filter the drivers based on the search query
    final List<DriverBusActive> filteredDrivers = drivers.where((driver) {
      final String driverId = driver.driver_name.toString();
      final String busId = driver.busId.toString();
      return driverId.contains(_searchQuery) || busId.contains(_searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Active Drivers with Active Buses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Driver name or Bus ID',
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
            SizedBox(height: 16),
            isLoading
                ? Expanded(child: Center(child: CircularProgressIndicator()))
                : filteredDrivers.isEmpty
                    ? Expanded(child: Center(child: Text('No data available')))
                    : Expanded(
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
                                    'https://via.placeholder.com/150',
                                  ),
                                  radius: 30,
                                ),
                                title: Text('Driver name: ${driver.driver_name}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Bus ID: ${driver.busId}'),
                                    Text('company_name  ${driver.company_name}'),
                                    Text('bus_plate_number: ${driver.bus_plate_number}'),
                                  
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
