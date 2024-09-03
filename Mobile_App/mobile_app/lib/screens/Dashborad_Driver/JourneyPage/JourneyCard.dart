import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Data_Models/Driver/TripForDriver.dart';
import 'package:mobile_app/Provider/Driver/Driver.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Journey_Detailes_Page/JourneyDetailsScreen.dart';

class JourneyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    var fontSize = screenHeight * 0.017;
    var iconSize = screenHeight * 0.025;

    return Consumer<DriverProvider>(builder: (context, provider, child) {
      // Handle loading state
      if (provider.isLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      if (provider.errorMessage != null) {
        return Center(
          child: Text('Error: ${provider.errorMessage}'),
        );
      }
      List<TripForDriverModel>? trips = provider.MyTrip;
      if (trips == null || trips.isEmpty) {
        return Center(
          child: Text('No trips available'),
        );
      }

      return Column(
        children: trips.asMap().entries.map((entry) {
          int index = entry.key;
          TripForDriverModel trip = entry.value;

          Widget tripCard = Container(
            margin: EdgeInsets.only(bottom: screenHeight * 0.015),
            padding: EdgeInsets.all(19.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${trip.from} to ${trip.to}',
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        if (provider.typePage == "alltrip") ...[
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              '${trip.trip_duration} H',
                              // ' ${trip.from_time}',
                              style: TextStyle(
                                fontSize: fontSize * 0.75,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ] else ...[
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              'DONE',
                              // ' ${trip.from_time}',
                              style: TextStyle(
                                fontSize: fontSize * 0.95,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Text(
                          '${trip.from_time}',
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '${trip.to_time}',
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: iconSize, color: Colors.grey),
                        Text(
                          ' ${trip.from} ',
                          style: TextStyle(
                            fontSize: fontSize * 0.85,
                            color: Colors.grey,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.location_on,
                            size: iconSize, color: Colors.grey),
                        Text(
                          ' ${trip.to}',
                          style: TextStyle(
                            fontSize: fontSize * 0.85,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.people,
                                size: iconSize, color: Colors.grey),
                            SizedBox(width: 4),
                            Text(
                              '${trip.Passengers} Passengers',
                              style: TextStyle(
                                fontSize: fontSize * 0.75,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/distance.png',
                              width: 30,
                              height: 30,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              '${trip.Distance}Kms',
                              style: TextStyle(
                                fontSize: fontSize * 0.75,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Text(
                          '${trip.Stops} Stops',
                          style: TextStyle(
                            fontSize: fontSize * 0.75,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          );

          if (provider.typePage == "alltrip") {
            return InkWell(
              onTap: () async {
                // print(t);
                provider.setIndexTrip(index);
                var accessToken =
                    Provider.of<AuthProvider>(context, listen: false)
                        .accessToken;
                await provider.fetchTripsDetails(accessToken, trip.id);
                 provider.settotalPassengerEmpty;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JourneyDetailsScreen(),
                  ),
                );
              },
              child: tripCard,
            );
          } else {
            return tripCard;
          }
        }).toList(),
      );
    });
  }
}
