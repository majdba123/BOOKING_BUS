import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/Trip_Model/Trip.dart';
import 'package:mobile_app/Provider/Company/Trip_provider.dart';
import 'package:provider/provider.dart';
import 'update_trip.dart';

class TripListPage extends StatefulWidget {
  @override
  _TripListPageState createState() => _TripListPageState();
}

class _TripListPageState extends State<TripListPage> {
  final String accessToken = "2|F6Qt2hWRZ98NGd0UAhcY7PMRoIhuaaVHTDPoYTTEeaa05b04";

  @override
  void initState() {
    super.initState();
    Provider.of<TripProvider>(context, listen: false).fetchTrips(accessToken);
  }

  void _deleteTrip(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Trip'),
        content: Text('Are you sure you want to delete the trip?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final tripProvider = Provider.of<TripProvider>(context, listen: false);
              await tripProvider.deleteTrip(accessToken, tripProvider.trips[index].id);
              Navigator.of(context).pop();
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _updateTrip(int index, String from, String to) async {
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    Trip updatedTrip = tripProvider.trips[index].copyWith(from: from, to: to);
    await tripProvider.updateTrip(accessToken, updatedTrip);
  }

  @override
  Widget build(BuildContext context) {
    final tripProvider = Provider.of<TripProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('All Trips'),
      ),
      body: tripProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: tripProvider.trips.length,
                itemBuilder: (context, index) {
                  final trip = tripProvider.trips[index];
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
                                '${trip.from} ➔ ${trip.to}',
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
                                        _updateTrip(index, result['from'], result['to']);
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

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TripProvider(),
      child: MaterialApp(
        home: TripListPage(),
      ),
    ),
  );
}
