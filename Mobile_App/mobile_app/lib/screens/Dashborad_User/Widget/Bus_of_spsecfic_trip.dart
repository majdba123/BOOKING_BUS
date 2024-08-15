import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/user/Buss_of_spsecfic_trip.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Colors.dart';

class BusCardofSpecicTrip extends StatefulWidget {
  final int tripId;
  BusCardofSpecicTrip({required this.tripId});

  @override
  _BusCardofSpecicTripState createState() =>
      _BusCardofSpecicTripState(tripId: tripId);
}

class _BusCardofSpecicTripState extends State<BusCardofSpecicTrip> {
  final int tripId;

  _BusCardofSpecicTripState({required this.tripId});

  @override
  void initState() {
    super.initState();
    final provider =
        Provider.of<BussofSpsccifTripProvider>(context, listen: false);
    final authprovider = Provider.of<AuthProvider>(context, listen: false);
    provider.getBussofSpecicTrip(tripId, authprovider.accessToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back button
        toolbarHeight: 100.0, // Adjusted height for better spacing
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryColor,
                AppColors.primaryColor.withOpacity(0.8)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 18.0, vertical: 14.0), // Adjusted padding
          child: Consumer<BussofSpsccifTripProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading || provider.busResponses.isEmpty) {
                return const Text('Loading...');
              }

              final busTrip = provider.busResponses.first;

              return Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Center alignment for better UX
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          busTrip.from,
                          style: TextStyle(
                            fontSize: 22.0, // Larger font size
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(
                          Icons.directions_bus,
                          color: Colors.white,
                          size: 28.0, // Slightly larger icon
                        ),
                      ),
                      Expanded(
                        child: Text(
                          busTrip.to,
                          style: TextStyle(
                            fontSize: 22.0, // Larger font size
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Center(
                    child: Text(
                      'Available Bus Trips',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        centerTitle: false, // Aligns the title content in the header
      ),
      body: Consumer<BussofSpsccifTripProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          final busTrips = provider.busResponses;

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: busTrips.length,
            itemBuilder: (context, index) {
              final busTrip = busTrips[index];

              return Card(
                margin: EdgeInsets.only(bottom: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 3,
                child: InkWell(
                  onTap: () {
                    // Action on tapping the bus card
                  },
                  splashColor: AppColors.primaryColor.withOpacity(0.1),
                  highlightColor: Colors.grey.withOpacity(0.1),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/logo_bus.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    busTrip.type,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    'Event: ${busTrip.event}',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text('Bus No: ${busTrip.busId}',
                                  style: TextStyle(color: Colors.green[800])),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTimeLocationColumn(
                                busTrip.fromTime, busTrip.from, context),
                            Icon(Icons.directions_bus,
                                color: Colors.grey, size: 24.0),
                            _buildTimeLocationColumn(
                                busTrip.toTime, busTrip.to, context),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        Divider(
                          height: 32.0,
                          thickness: 1.5,
                          color: Colors.grey[300],
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 20),
                            SizedBox(width: 4.0),
                            Text('Rating: 4.4',
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 14.0)),
                            Spacer(),
                            Row(
                              children: [
                                Icon(Icons.person, size: 20),
                                SizedBox(width: 4.0),
                                Text('${busTrip.seats.length} Seats',
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 14.0)),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        Divider(
                            height: 25.0,
                            thickness: 1.5,
                            color: Colors.grey[300]),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Break Places',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0)),
                            ...busTrip.breaks.map((breakPlace) {
                              String government = breakPlace.government;
                              if (breakPlace.nameBreak == "start" &&
                                  breakPlace.government == "Nothing") {
                                government = busTrip.from;
                              } else if (breakPlace.nameBreak == "end" &&
                                  breakPlace.government == "Nothing") {
                                government = busTrip.to;
                              }
                              Color statusColor;
                              String statusText;
                              switch (breakPlace.status) {
                                case "done 1":
                                  statusColor = Colors.yellow[800]!;
                                  statusText = "Return Only";
                                  break;
                                case "done 2":
                                  statusColor = Colors.red[700]!;
                                  statusText = "Finish Trip";
                                  break;
                                default:
                                  statusColor = Colors.green[700]!;
                                  statusText = "Pending";
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.place,
                                        color: AppColors.primaryColor),
                                    SizedBox(width: 8.0),
                                    Expanded(
                                      child: Text(
                                          '${breakPlace.nameBreak}, $government',
                                          style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 14.0)),
                                    ),
                                    Text(
                                      statusText,
                                      style: TextStyle(
                                          color: statusColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Column _buildTimeLocationColumn(
      String time, String location, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          location,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }
}
