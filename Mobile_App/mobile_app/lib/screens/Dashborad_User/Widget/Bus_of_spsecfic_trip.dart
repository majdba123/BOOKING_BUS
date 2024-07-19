import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Login_Provider.dart';
import 'package:mobile_app/Provider/user/Buss_of_spsecfic_trip.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/Data_Models/show_buss_spsecifc_trip.dart'; // Adjust the path as needed

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
    print('the trip id is $tripId');
    final provider =
        Provider.of<BussofSpsccifTripProvider>(context, listen: false);
    final authprovider = Provider.of<AuthProvider>(context, listen: false);
    provider.getBussofSpecicTrip(tripId, authprovider.accessToken);
  print(provider.busResponses);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('this is title'),
        ),
        body: Consumer<BussofSpsccifTripProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            final busTrips = provider.busResponses;

            return ListView.builder(
              itemCount: busTrips.length,
              itemBuilder: (context, index) {
                final busTrip = busTrips[index];

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
                                        image: AssetImage(
                                            'assets/images/logo_bus.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: cardPadding),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 4.0),
                                        Text(
                                          'Bus Type: ${busTrip.type}',
                                          style: TextStyle(
                                              color: AppColors.primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: smallTextFontSize),
                                        ),
                                        SizedBox(height: 4.0),
                                        Text(
                                          'Bus Event: ${busTrip.event}',
                                          style: TextStyle(
                                              color: AppColors.primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: smallTextFontSize),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                    decoration: BoxDecoration(
                                      color: Colors.green[100],
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text('N.Bus :${busTrip.busId}',
                                        style: TextStyle(color: Colors.green)),
                                  ),
                                ],
                              ),
                              SizedBox(height: cardPadding),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('${busTrip.fromTime} Am',
                                          style: TextStyle(
                                              fontSize: textFontSize,
                                              color: AppColors.primaryColor)),
                                      SizedBox(height: 4.0),
                                      Text(busTrip.from,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: smallTextFontSize)),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 12.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              ' ------------ ',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: smallTextFontSize),
                                            ),
                                            Icon(Icons.directions_bus,
                                                color: Colors.grey,
                                                size: iconSize),
                                            Text(
                                              ' ------------- ',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: smallTextFontSize),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('${busTrip.toTime} Am',
                                          style: TextStyle(
                                              fontSize: textFontSize,
                                              color: AppColors.primaryColor)),
                                      SizedBox(height: 4.0),
                                      Text(busTrip.to,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: smallTextFontSize)),
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
                                  Icon(Icons.star,
                                      color: Colors.yellow, size: iconSize),
                                  SizedBox(width: 4.0),
                                  Text('Rating',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: smallTextFontSize)),
                                  Spacer(),
                                  Row(
                                    children: [
                                      Icon(Icons.person, size: iconSize),
                                      SizedBox(width: 4.0),
                                      Text('${busTrip.seats.length}',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: smallTextFontSize)),
                                    ],
                                  ),
                                  Spacer(),
                                ],
                              ),
                              SizedBox(height: cardPadding),
                              Divider(height: 25.0, thickness: 1.5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Break Places',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: textFontSize)),
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
                                        statusColor = Colors.yellow;
                                        statusText = "Return Only";
                                        break;
                                      case "done 2":
                                        statusColor = Colors.red;
                                        statusText = "Finish Trip";
                                        break;
                                      default:
                                        statusColor = Colors.green;
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
                                                    color: Colors.grey,
                                                    fontSize:
                                                        smallTextFontSize)),
                                          ),
                                          Text(
                                            statusText,
                                            style: TextStyle(
                                                color: statusColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: smallTextFontSize),
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
            );
          },
        ));
  }
}
