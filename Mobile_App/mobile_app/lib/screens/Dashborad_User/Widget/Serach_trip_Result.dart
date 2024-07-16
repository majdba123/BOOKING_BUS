import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/Trip_by_Path.dart';
import 'package:mobile_app/Data_Models/flight_model.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Seat_Selection_Screen.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/bottom_nav_bar.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/horizontal_list.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/route_card.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/search_Trip_form.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/section_title.dart';
import 'package:mobile_app/widgets/my_text_button.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/Provider/Login_Provider.dart';

class BusSearchScreen extends StatelessWidget {
  final Future<void> searchFuture;

  BusSearchScreen({required this.searchFuture});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
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
        
                  final trip = tripProvider.trips.first;
        
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FractionallySizedBox(
                          widthFactor: 1.0,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.26,
                            color: AppColors.primaryColor,
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top + 23.0,
                              bottom: 20.0,
                              left: 16.0,
                              right: 16.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.all(8.0),
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_back,
                                        color: Colors.white),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'FROM',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'TO',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      trip.from,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      ' .......... ',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 14),
                                    ),
                                    Icon(Icons.directions_bus,
                                        color: Colors.grey),
                                    Text(
                                      ' .......... ',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 18),
                                    ),
                                    Text(
                                      trip.to,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
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
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SeatsGridPage()));
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


class BusCard extends StatelessWidget {
  final TripByPath trip;
  final VoidCallback onTap;

  BusCard({required this.trip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardPadding = constraints.maxWidth * 0.04;
        double imageWidth = constraints.maxWidth * 0.12;
        double textFontSize = constraints.maxWidth * 0.045;
        double smallTextFontSize = constraints.maxWidth * 0.035;
        double iconSize = constraints.maxWidth * 0.05;

        return Card(
          margin: EdgeInsets.only(bottom: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: imageWidth,
                        height: imageWidth,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('assets/images/logo_bus.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: cardPadding),
                      Text(trip.companyId,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: textFontSize)),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text('N.Bus :${trip.busTrips[0].busId}', style: TextStyle(color: Colors.green)),
                      ),
                    ],
                  ),
                  SizedBox(height: cardPadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${trip.busTrips[0].fromTime} Am',
                              style: TextStyle(
                                  fontSize: textFontSize, color: AppColors.primaryColor)),
                          SizedBox(height: 4.0),
                          Text(trip.from, style: TextStyle(color: Colors.grey, fontSize: smallTextFontSize)),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Duration', style: TextStyle(color: Colors.grey, fontSize: smallTextFontSize)),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Row(
                              children: [
                                Text(
                                  ' ------------ ',
                                  style: TextStyle(color: Colors.grey, fontSize: smallTextFontSize),
                                ),
                                Icon(Icons.directions_bus, color: Colors.grey, size: iconSize),
                                Text(
                                  ' ------------- ',
                                  style: TextStyle(color: Colors.grey, fontSize: smallTextFontSize),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${trip.busTrips[0].toTime} Am ',
                              style: TextStyle(
                                  fontSize: textFontSize, color: AppColors.primaryColor)),
                          SizedBox(height: 4.0),
                          Text(trip.to, style: TextStyle(color: Colors.grey, fontSize: smallTextFontSize)),
                        ],
                      ),
                    ],
                  ),
                  Divider(
                    height: 32.0,
                    thickness: 1.5,
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow, size: iconSize),
                      SizedBox(width: 4.0),
                      Text('Rating', style: TextStyle(color: Colors.grey, fontSize: smallTextFontSize)),
                      Spacer(),
                      Container(margin: EdgeInsets.only(right: 38.0),
                        child: Row(
                          children: [
                            Icon(Icons.person, size: iconSize),
                             Text('${trip.busTrips[0].seatCount}', style: TextStyle(color: Colors.grey, fontSize: smallTextFontSize)),
                          ],
                        ),
                      ),
                     
                      Spacer(),
                      Text('${trip.price} \$',
                          style: TextStyle(
                              fontSize: textFontSize, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
final flightsAvailableJson = [
  {
    "id": "1",
    "logo": "assets/images/companies_logo/gol_logo.png",
    "price": 190.90,
    "title": "Brazil to England",
    "seats": [
      {
        "available": false,
      },
      {
        "available": false,
      },
      {
        "available": false,
      },
      {
        "available": true,
      },
      {
        "available": false,
      },
      {
        "available": false,
      },
      {
        "available": false,
      },
      {
        "available": false,
      },
      {
        "available": false,
      },
      {
        "available": true,
      },
      {
        "available": false,
      },
      {
        "available": true,
      },
      {
        "available": false,
      },
      {
        "available": true,
      },
      {
        "available": true,
      },
      {
        "available": true,
      },
      {
        "available": false,
      },
      {
        "available": true,
      },
      {
        "available": true,
      },
      {
        "available": true,
      },
      {
        "available": true,
      },
      {
        "available": true,
      },
      {
        "available": false,
      },
      {
        "available": true,
      },
      {
        "available": false,
      },
      {
        "available": true,
      },
      {
        "available": true,
      },
      {
        "available": true,
      },
      {
        "available": true,
      },
      {
        "available": true,
      },
      {
        "available": true,
      },
      {
        "available": true,
      },
      {
        "available": false,
      },
      {
        "available": true,
      },
      {
        "available": false,
      },
      {
        "available": true,
      },
    ],
  },
  {
    "id": "2",
    "logo": "assets/images/companies_logo/latam_logo.png",
    "price": 190.90,
    "title": "Brazil to England",
    "seats": [
      {
        "available": false,
      },
      {
        "available": true,
      },
      {
        "available": true,
      },
    ],
  },
  {
    "id": "3",
    "logo": "assets/images/companies_logo/gol_logo.png",
    "price": 190.90,
    "title": "Brazil to England",
    "seats": [
      {
        "available": true,
      },
      {
        "available": true,
      },
      {
        "available": false,
      },
      {
        "available": true,
      },
    ],
  },
  {
    "id": "4",
    "logo": "assets/images/companies_logo/gol_logo.png",
    "price": 190.90,
    "title": "Brazil to England",
    "seats": [
      {
        "available": false,
      },
      {
        "available": true,
      },
    ],
  },
  {
    "id": "5",
    "logo": "assets/images/companies_logo/latam_logo.png",
    "price": 190.90,
    "title": "Brazil to England",
    "seats": [
      {
        "available": true,
      },
      {
        "available": false,
      },
      {
        "available": true,
      },
    ],
  },
  {
    "id": "6",
    "logo": "assets/images/companies_logo/latam_logo.png",
    "price": 190.90,
    "title": "Brazil to England",
    "seats": [
      {
        "available": false,
      },
      {
        "available": true,
      },
      {
        "available": false,
      },
      {
        "available": false,
      },
      {
        "available": true,
      },
    ],
  },
];
