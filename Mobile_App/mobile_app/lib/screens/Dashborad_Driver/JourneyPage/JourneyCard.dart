import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Data_Models/Driver/TripForDriver.dart';
import 'package:mobile_app/Provider/Driver/Driver.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Journey_Detailes_Page/JourneyDetailsScreen.dart';

class JourneyCard extends StatelessWidget {
  @override
  var tagColor = Colors.redAccent;
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
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
        children: trips.map((trip) {
          return Container(
            margin: EdgeInsets.only(bottom: screenHeight * 0.015),
            padding: EdgeInsets.all(16.0),
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
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: tagColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          '4h',
                          // ' ${trip.from_time}',
                          style: TextStyle(
                            fontSize: fontSize * 0.75,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
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
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: iconSize, color: Colors.grey),
                      Text(
                        ' ${trip.from} CMBT',
                        style: TextStyle(
                          fontSize: fontSize * 0.75,
                          color: Colors.grey,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.location_on,
                          size: iconSize, color: Colors.grey),
                      Text(
                        ' ${trip.to} BS',
                        style: TextStyle(
                          fontSize: fontSize * 0.75,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.people,
                              size: iconSize, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            '${trip.Passengers}',
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
                      Spacer(),
                      // showDetailsButton
                      if (true)
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JourneyDetailsScreen(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                'VIEW DETAILS',
                                style: TextStyle(
                                  fontSize: fontSize * 0.75,
                                  color: tagColor,
                                ),
                              ),
                              // showArrowIcon
                              if (true)
                                Icon(
                                  Icons.arrow_forward,
                                  size: iconSize * 0.8,
                                  color: tagColor,
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}
