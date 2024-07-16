// bus_trips_screen.dart

import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/Specfic_Trip.dart';
import 'package:mobile_app/Data_Models/Trips_Status.dart';
import 'package:mobile_app/Provider/Company/Trip_Provider.dart';
import 'package:mobile_app/Provider/Company/Trip_Status.dart';
import 'package:mobile_app/Provider/Login_Provider.dart';
import 'package:mobile_app/screens/DashBorad_Company/Trip_managemt/show_spsecfic_trip.dart';
import 'package:provider/provider.dart';


class BusTripsStatusScreen extends StatefulWidget {
  @override
  _BusTripsScreenState createState() => _BusTripsScreenState();
}

class _BusTripsScreenState extends State<BusTripsStatusScreen> {
  String _selectedStatus = 'padding'; // Default status

  @override
  void initState() {
    super.initState();
     var authProvider = Provider.of<AuthProvider>(context, listen: false).accessToken;
  
    Provider.of<TripBusStatusProvider>(context, listen: false).fetchTripsByStatus(authProvider, _selectedStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Trips'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: _selectedStatus,
            onChanged: (String? newValue) {
              setState(() {
                _selectedStatus = newValue!;
              });
              var authProvider = Provider.of<AuthProvider>(context, listen: false).accessToken;
              Provider.of<TripBusStatusProvider>(context, listen: false).fetchTripsByStatus(authProvider, _selectedStatus);
            },
            items: <String>['padding', 'finished'].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Expanded(
            child: Consumer<TripBusStatusProvider>(
              builder: (context, tripProvider, _) {
                if (tripProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  print(tripProvider.trips);
                  return ListView.builder(
                    itemCount: tripProvider.tripsByStatus.length,
                    itemBuilder: (context, index) {
                      return TripCard(trip: tripProvider.tripsByStatus[index]);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TripCard extends StatelessWidget {
  final TripByStatus trip;

  TripCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: () {
      
     Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => 
             
               SpecificTripScreen(trip_id: trip.tripid,)
              ),
            );
    },
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text('Trip ID: ${trip.tripid}'),
              subtitle: Text('Status: ${trip.status}'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Text('Price: \$${trip.price.toStringAsFixed(2)}'),
                  Text('Created At: ${trip.createdAt}'),
                  Text('Updated At: ${trip.updatedAt}'),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}



