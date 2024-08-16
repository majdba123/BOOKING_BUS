import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/Trip_by_Path.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/bottom_nav_bar.dart';

import 'package:mobile_app/screens/Dashborad_User/Widget/route_card.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/search_Trip_form.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/section_title.dart';
import 'package:mobile_app/widgets/my_text_button.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';

class BusSearchScreen extends StatelessWidget {
  final Future<void> searchFuture;

  BusSearchScreen({required this.searchFuture});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: FutureBuilder<void>(
        future: searchFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Consumer<TripuserProvider>(
              builder: (context, tripProvider, child) {
                if (tripProvider.trips.isEmpty) {
                  return Center(child: Text('No trips found.'));
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FractionallySizedBox(
                        widthFactor: 1.0,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryColor,
                                Colors.blueAccent
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                            ),
                          ),
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top + 25.0,
                            bottom: 16.0,
                            left: 16.0,
                            right: 16.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                icon:
                                    Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Chennai, TN',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'India',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(Icons.directions_bus,
                                      color: Colors.white, size: 40),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Bangalore, KA',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'India',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                'Nov 27',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: tripProvider.trips.map((trip) {
                            return BusCard(
                              trip: trip,
                              onTap: () {
                                // Navigate to Seat Selection
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) => SeatSelectionScreen(bus: trip)));
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
// class BusCard extends StatelessWidget {
//   final Map bus;
//   final VoidCallback onTap;

//   BusCard({required this.bus, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.only(bottom: 16.0),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       child: InkWell(
//         onTap: onTap,
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(bus['name'],
//                           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//                       SizedBox(height: 4.0),
//                       Text(bus['type'], style: TextStyle(color: Colors.grey)),
//                     ],
//                   ),
//                   Spacer(),
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//                     decoration: BoxDecoration(
//                       color: Colors.green[100],
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     child: Text(bus['tag'], style: TextStyle(color: Colors.green)),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(bus['departure'], style: TextStyle(fontSize: 16.0)),
//                       SizedBox(height: 4.0),
//                       Text(bus['departure_location'], style: TextStyle(color: Colors.grey)),
//                     ],
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(bus['duration'], style: TextStyle(color: Colors.grey)),
//                     ],
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(bus['arrival'], style: TextStyle(fontSize: 16.0)),
//                       SizedBox(height: 4.0),
//                       Text(bus['arrival_location'], style: TextStyle(color: Colors.grey)),
//                     ],
//                   ),
//                 ],
//               ),
//               Divider(height: 32.0),
//               Row(
//                 children: [
//                   Icon(Icons.star, color: Colors.yellow, size: 16.0),
//                   SizedBox(width: 4.0),
//                   Text(bus['rating'], style: TextStyle(color: Colors.grey)),
//                   Spacer(),
//                   Text(bus['price'],
//                       style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
class BusCard extends StatelessWidget {
  final TripByPath trip;
  final VoidCallback onTap;

  BusCard({required this.trip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(trip.companyId, // Use company name if available
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(height: 4.0),
                      // Text(trip.type ?? 'Unknown', style: TextStyle(color: Colors.grey)), // Assuming `type` field in trip
                    ],
                  ),
                  Spacer(),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    // child: Text(trip.tag ?? '', style: TextStyle(color: Colors.green)), // Assuming `tag` field in trip
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(trip.departure, style: TextStyle(fontSize: 16.0)),
                      SizedBox(height: 4.0),
                      // Text(trip.departureLocation ?? '', style: TextStyle(color: Colors.grey)), // Assuming `departureLocation` field
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(trip.duration ?? '', style: TextStyle(color: Colors.grey)), // Assuming `duration` field
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(trip.arrival, style: TextStyle(fontSize: 16.0)),
                      SizedBox(height: 4.0),
                      // Text(trip.arrivalLocation ?? '', style: TextStyle(color: Colors.grey)), // Assuming `arrivalLocation` field
                    ],
                  ),
                ],
              ),
              Divider(height: 32.0),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow, size: 16.0),
                  SizedBox(width: 4.0),
                  // Text(trip.rating ?? '', style: TextStyle(color: Colors.grey)), // Assuming `rating` field
                  Spacer(),
                  Text('${trip.price} GBP', // Assuming `price` field
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
