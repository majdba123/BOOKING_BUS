import 'package:flutter/material.dart';
import 'package:mobile_app/screens/DashBorad_Company/Driver_managment/Driver.dart';
import 'package:mobile_app/screens/DashBorad_Company/Driver_managment/Update_Driver_Page.dart';


class GetAllDriversPage extends StatefulWidget {
  @override
  _GetAllDriversPageState createState() => _GetAllDriversPageState();
}

class _GetAllDriversPageState extends State<GetAllDriversPage> {
  List<Driver> drivers = [
    Driver(name: 'John Doe', email: 'john.doe@example.com', status: "p"),
    Driver(name: 'Jane Smith', email: 'jane.smith@example.com', status: "p"),
    Driver(name: 'Michael Johnson', email: 'michael.johnson@example.com', status: "p"),
  ];

  void deleteDriver(Driver driver) {
    setState(() {
      drivers.remove(driver);
    });
  }

  void updateDriver(Driver oldDriver, Driver newDriver) {
    setState(() {
      int index = drivers.indexOf(oldDriver);
      drivers[index] = newDriver;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Drivers'),
      ),
      body: ListView.builder(
        itemCount: drivers.length,
        itemBuilder: (context, index) {
          return DriverCard(
            driver: drivers[index],
            onDelete: () => deleteDriver(drivers[index]),
            onUpdate: (newDriver) => updateDriver(drivers[index], newDriver),
          );
        },
      ),
    );
  }
}

class DriverCard extends StatelessWidget {
  final Driver driver;
  final VoidCallback onDelete;
  final Function(Driver) onUpdate;

  DriverCard({
    required this.driver,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: ListTile(
        title: Text(driver.name),
        subtitle: Text(driver.email),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateDriverPage(driver: driver),
                  ),
                ).then((updatedDriver) {
                  if (updatedDriver != null) {
                    onUpdate(updatedDriver);
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Delete Driver'),
                    content: Text('Are you sure you want to delete ${driver.name}?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          onDelete();
                          Navigator.of(context).pop();
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
