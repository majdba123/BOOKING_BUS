import 'package:flutter/material.dart';
import 'package:mobile_app/screens/DashBorad_Company/Driver_managment/Create_Driver.dart';
import 'package:mobile_app/screens/DashBorad_Company/Driver_managment/Driver_By_status.dart';
import 'package:mobile_app/screens/DashBorad_Company/Driver_managment/Get_All_drivers.dart';




class DriverManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationForm()),
                );
              },
              child: Text('Create a Driver'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GetAllDriversPage()),
                );
              },
              child: Text('Get All Drivers'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GetDriversByStatusPage()),
                );
              },
              child: Text('Get Drivers by Status'),
            ),
          ],
        ),
      ),
    );
  }
}




