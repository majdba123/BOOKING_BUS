import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/BUS_Trip.dart';
import 'package:mobile_app/Provider/Company/Trip_Provider.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:provider/provider.dart';

class BusTripScreen extends StatefulWidget {
  @override
  _BusTripScreenState createState() => _BusTripScreenState();
}

class _BusTripScreenState extends State<BusTripScreen> {
  @override
  void initState() {
    super.initState();
    var authProvider = Provider.of<AuthProvider>(context, listen: false).accessToken;
    Provider.of<TripBusProvider>(context, listen: false).fetchBusTrip(authProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Trips'),
      ),
      body: Consumer<TripBusProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (provider.busTripDetails.isEmpty) {
            return Center(child: Text('No bus trips available'));
          }

          return ListView.builder(
            itemCount: provider.busTripDetails.length,
            itemBuilder: (context, index) {
              final busTrip = provider.busTripDetails[index];
              return BusTripCard(busTrip: busTrip);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var authProvider = Provider.of<AuthProvider>(context, listen: false).accessToken;
          Provider.of<TripBusProvider>(context, listen: false).fetchBusTrip(authProvider);
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class BusTripCard extends StatelessWidget {
  final BusTrip busTrip;

  BusTripCard({required this.busTrip});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Image.asset('assets/bus_icon.png', width: 50, height: 50), // Ensure you have a logo at this path
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${busTrip.path.from} to ${busTrip.path.to}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[900]),
                  ),
                  Text(
                    '\$${busTrip.price}',
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          if (busTrip.busTrip.isNotEmpty) ...[
            Text(
              'Bus Details:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ...busTrip.busTrip.map((busDetail) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bus ID: ${busDetail.busId}', style: TextStyle(fontSize: 16)),
                  Text('Date: ${busDetail.date}', style: TextStyle(fontSize: 16)),
                  Text('Start Time: ${busDetail.fromTime}', style: TextStyle(fontSize: 16)),
                  Text('End Time: ${busDetail.toTime}', style: TextStyle(fontSize: 16)),
                  Text('Event: ${busDetail.event}', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                ],
              );
            }).toList(),
          ] else ...[
            Text('No Bus Details Available', style: TextStyle(fontSize: 16, color: Colors.red)),
          ],
          Text(
            'Breaks:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          if (busTrip.breaksTrip.isNotEmpty)
            ...busTrip.breaksTrip.map((breakTrip) {
              return Text('- ${breakTrip.breakDetails.name} (${breakTrip.breakDetails.area.name})');
            }).toList()
          else
            Text('No Breaks Available', style: TextStyle(fontSize: 16, color: Colors.red)),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Call delete trip function here
              Provider.of<TripBusProvider>(context, listen: false).deleteTrip(
                Provider.of<AuthProvider>(context, listen: false).accessToken,
                busTrip.id,
              );
            },
            child: Text('Delete Trip'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              textStyle: TextStyle(fontSize: 16),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
