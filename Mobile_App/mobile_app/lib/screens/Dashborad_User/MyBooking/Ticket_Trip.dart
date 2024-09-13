import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/My_Reservation.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Bus_Trip_of_Specifc_Trip/Road_Path_line.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/TicketDetailsScreen.dart';

import 'package:provider/provider.dart';

class TicketTrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    var fontSize = screenHeight * 0.017;
    var iconSize = screenHeight * 0.025;

    return Consumer<TripuserProvider>(builder: (context, provider, child) {
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
      List<MYReservation>? trips = provider.Myreservations;
      if (trips == null || trips.isEmpty) {
        return Center(
          child: Text('No Reservation available'),
        );
      }

      return Column(
        children: trips.asMap().entries.map((entry) {
          int index = entry.key;
          MYReservation trip = entry.value;

          Widget tripCard = Container(
            margin: EdgeInsets.only(
                bottom: screenHeight * 0.019,
                left: screenHeight * 0.019,
                right: screenHeight * 0.019),
            padding: EdgeInsets.all(22.0),
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                          image: const DecorationImage(
                            image: AssetImage('assets/images/logo_bus.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        '${trip.company_name.toUpperCase()}',
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green[400],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      '${trip.price} \$',
                      style: TextStyle(
                        fontSize: fontSize * 0.90,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    ' ${trip.start_time}',
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.calendar_month,
                      size: iconSize, color: Colors.grey),
                  Text(
                    ' ${trip.Date}',
                    style: TextStyle(
                      fontSize: fontSize * 0.85,
                      color: Colors.grey,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '${trip.end_time}',
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
                  Icon(Icons.location_on, size: iconSize, color: Colors.grey),
                  Text(
                    ' ${trip.from} ',
                    style: TextStyle(
                      fontSize: fontSize * 0.85,
                      color: Colors.grey,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.circle,
                    color: Colors.grey,
                    size: 10.0,
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Positioned(
                    left: 100,
                    right: 100,
                    child: CustomPaint(
                      size: Size(
                        120,
                        10.0,
                      ),
                      painter: RoadPathPainter(),
                    ),
                  ),
                  Icon(
                    Icons.circle,
                    color: Colors.grey,
                    size: 10.0,
                  ),
                  Spacer(),
                  Icon(Icons.location_on, size: iconSize, color: Colors.grey),
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
                      Icon(Icons.event_seat,
                          size: iconSize, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        'Seat ${trip.seats} ',
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
                  Row(
                    children: [
                      Icon(Icons.arrow_upward,
                          size: iconSize, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        '${trip.Pickup_Point} ',
                        style: TextStyle(
                          fontSize: fontSize * 0.75,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ]),
          );

          // if (provider.typePage == "alltrip") {
          return InkWell(
            onTap: () {
              // print(t);
              // WidgetsBinding.instance.addPostFrameCallback((_) async {
              //   provider.setIndexTrip(index);
              //   var accessToken =
              //       Provider.of<AuthProvider>(context, listen: false)
              //           .accessToken;
              //   await provider.fetchTripsDetails(accessToken, trip.id);
              provider.saveSpecficRservationIndex(index);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TicketDetailsScreen(),
                ),
              );
            },
            child: tripCard,
          );
          // }
          //  else {
          //   return tripCard;
          // }
        }).toList(),
      );
    });
  }
}
