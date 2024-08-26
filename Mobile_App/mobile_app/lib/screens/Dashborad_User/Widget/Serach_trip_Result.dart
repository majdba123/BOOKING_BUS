import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/Trip_by_Path.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Bus_Seats_Select_UI_User/SeatsGridPage.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:intl/intl.dart';

class BusSearchScreen extends StatelessWidget {
  final Future<void> searchFuture;

  BusSearchScreen({required this.searchFuture});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Stack(
        children: [
          FutureBuilder<void>(
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
                                        tripProvider.trips.first.from,
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
                                        tripProvider.trips.first.to,
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
                              children: tripProvider.trips.expand((trip) {
                                return trip.busTrips.map((busTrip) {
                                  return BusCard(
                                    trip: trip,
                                    busTrip: busTrip,
                                    onTap: () {
                                      Provider.of<TripuserProvider>(context,
                                              listen: false)
                                          .selectBus(busTrip);

                                      Provider.of<TripuserProvider>(context,
                                              listen: false)
                                          .selectTripType(
                                              (busTrip.type == 'all')
                                                  ? 2
                                                  : (busTrip.type == 'going')
                                                      ? 1
                                                      : -1);
                                      Provider.of<TripuserProvider>(context,
                                              listen: false)
                                          .select_from_name(trip.from);
                                      Provider.of<TripuserProvider>(context,
                                              listen: false)
                                          .select_to_name(trip.to);
                                      Provider.of<TripuserProvider>(context,
                                              listen: false)
                                          .select_price_tikect(
                                              int.parse(trip.price));
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => SeatsGridPage(
                                              // companyName: trip.companyId,
                                              // from: trip.from,
                                              // to: trip.to,
                                              // fromTime: busTrip.fromTime,
                                              // toTime: busTrip.toTime,
                                              // seats: busTrip.seats,
                                              )));
                                    },
                                  );
                                }).toList();
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
          Positioned(
            bottom: 20.0,
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
            child: FilterBar(),
          ),
        ],
      ),
    );
  }
}

class FilterBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FilterOption(icon: Icons.west_outlined, label: 'one way'),
          FilterOption(
              icon: Icons.assignment_return_rounded, label: 'Round Trip'),
          FilterOption(icon: Icons.money_outlined, label: 'Chpiset'),
          FilterOption(icon: Icons.star, label: 'fast'),
          FilterIcon(icon: Icons.filter_list),
        ],
      ),
    );
  }
}

class FilterOption extends StatelessWidget {
  final IconData icon;
  final String label;

  const FilterOption({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 8),
        ),
      ],
    );
  }
}

class FilterIcon extends StatelessWidget {
  final IconData icon;

  const FilterIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(height: 4),
        Text(
          'Filter',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}

class BusCard extends StatelessWidget {
  final TripByPath trip;
  final BusTrip busTrip;
  final VoidCallback onTap;

  BusCard({required this.trip, required this.busTrip, required this.onTap});

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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(trip.companyId,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: textFontSize)),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${busTrip.fromTime} Am',
                              style: TextStyle(
                                  fontSize: textFontSize,
                                  color: AppColors.primaryColor)),
                          SizedBox(height: 4.0),
                          Text(trip.from,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: smallTextFontSize)),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${busTrip.duration}hrs',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: smallTextFontSize)),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Row(
                              children: [
                                Text(
                                  ' ------------ ',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: smallTextFontSize),
                                ),
                                Icon(Icons.directions_bus,
                                    color: Colors.grey, size: iconSize),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${busTrip.toTime} Am',
                              style: TextStyle(
                                  fontSize: textFontSize,
                                  color: AppColors.primaryColor)),
                          SizedBox(height: 4.0),
                          Text(trip.to,
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
                      Icon(Icons.star, color: Colors.yellow, size: iconSize),
                      SizedBox(width: 4.0),
                      Text('Rating',
                          style: TextStyle(
                              color: Colors.grey, fontSize: smallTextFontSize)),
                      Spacer(),
                      Row(
                        children: [
                          Icon(Icons.person, size: iconSize),
                          SizedBox(width: 4.0),
                          Text('${busTrip.seatCount}',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: smallTextFontSize)),
                        ],
                      ),
                      Spacer(),
                      Text('${trip.price} \$',
                          style: TextStyle(
                              fontSize: textFontSize,
                              fontWeight: FontWeight.bold)),
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
                          government = trip.from;
                        } else if (breakPlace.nameBreak == "end" &&
                            breakPlace.government == "Nothing") {
                          government = trip.to;
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
                              Icon(Icons.place, color: AppColors.primaryColor),
                              SizedBox(width: 8.0),
                              Expanded(
                                child: Text(
                                    '${breakPlace.nameBreak}, $government',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: smallTextFontSize)),
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
  }
}
