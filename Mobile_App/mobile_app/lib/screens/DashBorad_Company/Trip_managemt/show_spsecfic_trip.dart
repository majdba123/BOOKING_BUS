// bus_trips_screen.dart

import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/Specfic_Trip.dart';
import 'package:mobile_app/Provider/Company/Trip_Provider.dart';
import 'package:mobile_app/Provider/Company/Trip_Status.dart';
import 'package:mobile_app/Provider/Login_Provider.dart';
import 'package:provider/provider.dart';


class SpecificTripScreen extends StatefulWidget {
  late int trip_id ;
  SpecificTripScreen({required this.trip_id});
  @override
  _SpecificTripScreenState createState() => _SpecificTripScreenState(trip_id: trip_id);
}

class _SpecificTripScreenState extends State<SpecificTripScreen> {
  late int trip_id ; // Default status
_SpecificTripScreenState({required this.trip_id});
  @override
  void initState() {
    super.initState();
     var authProvider = Provider.of<AuthProvider>(context, listen: false).accessToken;
  
    Provider.of<TripBusStatusProvider>(context, listen: false).fetchSpecficTrip(authProvider, trip_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('spescfic Trip'),
      ),
      body: Column(
        children: [
          
          Expanded(
            child: Consumer<TripBusStatusProvider>(
              builder: (context, SpecificTrip, _) {
                if (SpecificTrip.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  print(SpecificTrip.trips);
                  return ListView.builder(
                    itemCount: SpecificTrip.trips.length,
                    itemBuilder: (context, index) {
                      return TripCard(trip: SpecificTrip.trips[index]);
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
  final SpecificTrip trip;

  TripCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('Trip ID: ${trip.id}'),
            subtitle: Text('Status: ${trip.status}'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('From: ${trip.path.from}'),
                Text('To: ${trip.path.to}'),
                Text('Price: \$${trip.price.toStringAsFixed(2)}'),
                Text('Created At: ${trip.createdAt}'),
                Text('Updated At: ${trip.updatedAt}'),
              ],
            ),
          ),
          Divider(),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: trip.busTrip.length,
            itemBuilder: (context, index) {
              return BusDetailsCard(busDetails: trip.busTrip[index]);
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: trip.breaksTrip.length,
            itemBuilder: (context, index) {
              return BreakDetailsCard(breakDetails: trip);
            },
          ),
        ],
      ),
    );
  }
}

class BusDetailsCard extends StatelessWidget {
  final BusDetails busDetails;

  BusDetailsCard({required this.busDetails});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: ListTile(
        title: Text('Bus ID: ${busDetails.busId}'),
        subtitle: Text('From Time: ${busDetails.fromTime} | To Time: ${busDetails.toTime}'),
      ),
    );
  }
}

class BreakDetailsCard extends StatelessWidget {
  final SpecificTrip breakDetails;

  BreakDetailsCard({required this.breakDetails});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: ListTile(
        title: Text('Break ID: ${breakDetails.breaksTrip[0].id} ,name breack: ${breakDetails.breaksTrip[0].breakDetails.name} '),
        subtitle: Text('Created At: ${breakDetails.createdAt}'),
      ),
    );
  }
}
