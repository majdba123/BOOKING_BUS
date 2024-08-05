import 'package:flutter/material.dart';
import 'package:mobile_app/screens/DashBorad_Company/Driver_managment/Driver.dart';



class GetDriversByStatusPage extends StatefulWidget {
  @override
  _GetDriversByStatusPageState createState() => _GetDriversByStatusPageState();
}

class _GetDriversByStatusPageState extends State<GetDriversByStatusPage> {
  String selectedStatus = 'pending'; // Default status selection

  final List<Driver> drivers = [
    Driver(name: 'John Doe', email: 'john.doe@example.com', status: 'pending'),
    Driver(name: 'Jane Smith', email: 'jane.smith@example.com', status: 'available'),
     Driver(name: 'Jane Smith', email: 'jane.smith@example.com', status: 'available'),
      Driver(name: 'Jane Smith', email: 'jane.smith@example.com', status: 'available'),
       Driver(name: 'Jane Smith', email: 'jane.smith@example.com', status: 'available'),
        Driver(name: 'Jane Smith', email: 'jane.smith@example.com', status: 'available'),
    Driver(name: 'Michael Johnson', email: 'michael.johnson@example.com', status: 'finished'),
  ];

  List<Driver> getFilteredDrivers(String status) {
    return drivers.where((driver) => driver.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
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
                });
              },
              items: ['pending', 'available', 'finished']
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
          Expanded(
            child: ListView.builder(
              itemCount: getFilteredDrivers(selectedStatus).length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(getFilteredDrivers(selectedStatus)[index].name),
                    subtitle: Text(getFilteredDrivers(selectedStatus)[index].email),
                    trailing: Text(getFilteredDrivers(selectedStatus)[index].status.toUpperCase()),
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