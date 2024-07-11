import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/Driver.dart';
import 'package:mobile_app/Data_Models/Driver_Status.dart';
import 'package:mobile_app/Provider/Company/Driver_Provider.dart';
import 'package:mobile_app/Provider/Login_Provider.dart';
import 'package:provider/provider.dart';

class GetDriversByStatusPage extends StatefulWidget {
  @override
  _GetDriversByStatusPageState createState() => _GetDriversByStatusPageState();
}

class _GetDriversByStatusPageState extends State<GetDriversByStatusPage> {
  String selectedStatus = 'pending'; // Default status selection

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final driverProvider = Provider.of<DriverProvider>(context, listen: false);
      driverProvider.fetchDriverByStatus( authProvider.accessToken,selectedStatus);
    });
  }

  @override
  Widget build(BuildContext context) {
    final driverProvider = Provider.of<DriverProvider>(context);
    final List<DriverStauts> drivers = driverProvider.DriversStauts;
    final bool isLoading = driverProvider.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text('Drivers by Status'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              value: selectedStatus,
              onChanged: (value) {
                setState(() {
                  selectedStatus = value!;
                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                  final driverProvider = Provider.of<DriverProvider>(context, listen: false);
                  driverProvider.fetchDriverByStatus( authProvider.accessToken,selectedStatus);
                });
              },
              items: ['pending', 'available', 'completed']
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status.toUpperCase()),
                      ))
                  .toList(),
              decoration: InputDecoration(
                labelText: 'Select Status',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          isLoading
              ? Expanded(child: Center(child: CircularProgressIndicator()))
              : Expanded(
                  child: ListView.builder(
                    itemCount: drivers.length,
                    itemBuilder: (context, index) {
                      final driver = drivers[index];
                      return Card(
                        child: ListTile(
                          title: Text(driver.name),
                          subtitle: Text(driver.status),
                          trailing: Text(driver.status.toUpperCase()),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
