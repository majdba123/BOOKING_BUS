import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/Driver.dart';
import 'package:mobile_app/Provider/Company/Driver_Provider.dart';
import 'package:mobile_app/Provider/Login_Provider.dart';
import 'package:provider/provider.dart';

class ActiveDriversPage extends StatefulWidget {
  @override
  _ActiveDriversPageState createState() => _ActiveDriversPageState();
}

class _ActiveDriversPageState extends State<ActiveDriversPage> {
  // String accessToken = "1|CbPIttquOsvjIx0D0JBcijWJKvY7gWb3Y2G5ixWee0511d0b";
  @override
  void initState() {
    super.initState();
     final authProvider = Provider.of<AuthProvider>(context, listen: false);
    Provider.of<DriverProvider>(context, listen: false).fetchDriversOnActiveBus(authProvider.accessToken);
  }

  @override
  Widget build(BuildContext context) {
    final driverProvider = Provider.of<DriverProvider>(context);
    final List<Driver> drivers = driverProvider.Drivers;
    // final bool isLoading = driverProvider.isLoading;

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
              onChanged: (query) {
                setState(() {
                  // Filter logic here
                });
              },
            ),
            SizedBox(height: 16),
           driverProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
                  itemCount: drivers.length,
                  itemBuilder: (context, index) {
                    final driver = drivers[index];
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
                        title: Text('${driver.user_id}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email: ${driver.user_id}'),
                            Text('Bus ID: ${driver.company_id}'),
                          ],
                        ),
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
