import 'package:flutter/material.dart';
import 'package:mobile_app/screens/DashBorad_Company/Trip_mangement/Trip.dart';
import 'package:mobile_app/screens/DashBorad_Company/Trip_mangement/update_Trip.dart';

class TripListPage extends StatefulWidget {
  @override
  _TripListPageState createState() => _TripListPageState();
}

class _TripListPageState extends State<TripListPage> {
  List<Trip> trips = [
    Trip("New York", "Los Angeles"),
    Trip("San Francisco", "Las Vegas"),
    Trip("New York", "Los Angeles"),
    Trip("San Francisco", "Las Vegas"),
    Trip("New York", "Los Angeles"),
    Trip("San Francisco", "Las Vegas"),
    Trip("New York", "Los Angeles"),
    Trip("San Francisco", "Las Vegas"),
    Trip("New York", "Los Angeles"),
    Trip("San Francisco", "Las Vegas"),
    // Add more trip entries here
  ];

  void _deleteTrip(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Trip'),
        content: Text('Are you sure you want to delete the trip from ${trips[index].source} to ${trips[index].destination}?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                trips.removeAt(index);
              });
              Navigator.of(context).pop();
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _updateTrip(int index, String source, String destination) {
    setState(() {
      trips[index].source = source;
      trips[index].destination = destination;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Trips'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: trips.length,
          itemBuilder: (context, index) {
            final trip = trips[index];
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
                        Text(
                          '${trip.source} ➔ ${trip.destination}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateTripPage(
                                      trip: trip,
                                      tripIndex: index,
                                    ),
                                  ),
                                );
                                if (result != null) {
                                  _updateTrip(index, result['source'], result['destination']);
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deleteTrip(index);
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
        ),
      ),
    );
  }
}
