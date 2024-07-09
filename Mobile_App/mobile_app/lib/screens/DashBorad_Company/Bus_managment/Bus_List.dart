import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Company/Bus_Provider.dart';
import 'package:mobile_app/Provider/Company/Seat_Provider.dart';
import 'package:mobile_app/Provider/Login_Provider.dart';
import 'package:mobile_app/screens/Bus_Seats/seats.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Data_Models/Bus.dart';
import 'package:mobile_app/screens/DashBorad_Company/Bus_managment/Upadte_Bus.dart';


class BusListPage extends StatefulWidget {
  @override
  State<BusListPage> createState() => _BusListPageState();
}

class _BusListPageState extends State<BusListPage> {
  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    Provider.of<BusProvider>(context, listen: false).fetchBuss(authProvider.accessToken);
  }

 void _showUpdateDialog(BuildContext context, Bus bus, int index) {
    final _numberBusController = TextEditingController(text:bus.number_bus );
    final _numberPassangerController = TextEditingController(text:bus.number_passenger.toString() );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update bus'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _numberBusController,
              decoration: InputDecoration(labelText: 'number bus'),
            ),
            TextField(
              controller: _numberPassangerController,
              decoration: InputDecoration(labelText: 'number passanger'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final busProvider = Provider.of<BusProvider>(context, listen: false);
               final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await busProvider.updateBus(authProvider.accessToken, bus.id, _numberBusController.text, _numberPassangerController.text);
              Navigator.of(context).pop();
            },
            child: Text('Update'),
          ),
           
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int id, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete bus'),
        content: Text('Are you sure you want to delete this bus?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final busProvider = Provider.of<BusProvider>(context, listen: false);
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await busProvider.deleteBus(authProvider.accessToken, id);
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
      final busProvider = Provider.of<BusProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('All Buses'),
      ),
      body: busProvider.isLoading
          ? Center(child: CircularProgressIndicator()):Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<BusProvider>(
          builder: (context, busProvider, _) => ListView.builder(
            itemCount: busProvider.Buss.length,
            itemBuilder: (context, index) {
              final bus = busProvider.Buss[index];
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
                      Text(
                        'Bus Number: ${bus.number_bus}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Number of Passengers: ${bus.number_passenger}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            onPressed: () {
                              _showUpdateDialog(context, bus,index);
                            },
                            child: Text(
                              'Update',
                              style: TextStyle(color: Colors.orange[900]),
                            ),
                          ),
                          SizedBox(width: 16),
                          TextButton(
                            onPressed: () {
                              _showDeleteDialog(context,bus.id,index);
                            },
                            child: Text(
                              'Delete',
                              style: TextStyle(color: Colors.red[900]),
                            ),
                          ),
                          SizedBox(width: 16),
                          TextButton(
            onPressed: () async {

              
              final seatProvider = Provider.of<SeatProvider>(context, listen: false);
               final authProvider = Provider.of<AuthProvider>(context, listen: false);
             await seatProvider.fetchSeatByBusId(authProvider.accessToken, bus.id);
             print(seatProvider.Seats);
               Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BusSeatLayoutPage(),
                ),
              );
              // Navigator.of(context).pop();
            },
            child: Text('seat'),
          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
//   void _navigateToUpdateBus(BuildContext context, Bus bus) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => UpdateBusPage(bus: bus)),
//     );
//   }


}