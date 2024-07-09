import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Company/Driver_Provider.dart';
import 'package:mobile_app/Provider/Login_Provider.dart';
import 'package:mobile_app/Data_Models/Driver.dart';
import 'package:mobile_app/screens/DashBorad_Company/Driver_managment/Update_Driver_Page.dart';
import 'package:provider/provider.dart';


class GetAllDriversPage extends StatefulWidget {
  @override
  _GetAllDriversPageState createState() => _GetAllDriversPageState();
}

class _GetAllDriversPageState extends State<GetAllDriversPage> {
 @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    Provider.of<DriverProvider>(context, listen: false).fetchDrivers(authProvider.accessToken);
  }
// void _showUpdateDialog(BuildContext context, Driver trip, int index) {
//     final _fromController = TextEditingController(text: trip.from);
//     final _toController = TextEditingController(text: trip.to);

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Update Trip'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: _fromController,
//               decoration: InputDecoration(labelText: 'From'),
//             ),
//             TextField(
//               controller: _toController,
//               decoration: InputDecoration(labelText: 'To'),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () async {
//               final tripProvider = Provider.of<TripProvider>(context, listen: false);
//                final authProvider = Provider.of<AuthProvider>(context, listen: false);
//               await tripProvider.updateTrip(authProvider.accessToken, trip.id, _fromController.text, _toController.text);
//               Navigator.of(context).pop();
//             },
//             child: Text('Update'),
//           ),
//         ],
//       ),
//     );
//   }

  void _showDeleteDialog(BuildContext context, int id, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete driver'),
        content: Text('Are you sure you want to delete this driver?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final driverProvider = Provider.of<DriverProvider>(context, listen: false);
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await driverProvider.deleteDriver(authProvider.accessToken, id);
              Navigator.of(context).pop();
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
        final driverProvider = Provider.of<DriverProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('All Drivers'),
      ),
      body: driverProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
        itemCount: driverProvider.Drivers.length,
        itemBuilder: (context, index) {
           final driver = driverProvider.Drivers[index];
          return Card(
                    margin: EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${driver.id}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[900],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Created: ${driver.createdAt}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    'Updated: ${driver.updatedAt}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      // _showUpdateDialog(context, trip, index);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _showDeleteDialog(context, driver.id, index);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
        },
      )),
    );
  }
}

