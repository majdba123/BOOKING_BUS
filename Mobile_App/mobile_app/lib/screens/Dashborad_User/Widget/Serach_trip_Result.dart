import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart'; // Import the Lottie package
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/route_card.dart';
import 'package:mobile_app/Colors.dart';

class BusSearchScreen extends StatefulWidget {
  @override
  _BusSearchScreenState createState() => _BusSearchScreenState();
}

class _BusSearchScreenState extends State<BusSearchScreen>
    with TickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  String selectedFilter = 'All';
  List<String> filters = ['All', 'By Company', 'By Price', 'By From', 'By To'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header with Search and Filter
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryColor,
                  AppColors.primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            padding: EdgeInsets.only(
                top: 50.0, left: 20.0, right: 20.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All Trips By path',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10.0),
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search trips...',
                    hintStyle: TextStyle(color: Colors.white70),
                    prefixIcon: Icon(Icons.search, color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                SizedBox(height: 10.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: filters.map((filter) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: selectedFilter == filter,
                          onSelected: (selected) {
                            setState(() {
                              selectedFilter = filter;
                            });
                          },
                          selectedColor: Colors.white,
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Consumer<TripuserProvider>(
                builder: (context, tripProvider, child) {
                  if (tripProvider.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  // Apply search and filter logic
                  List filteredTrips = tripProvider.AllTripsItems.where((trip) {
                    if (selectedFilter == 'By Company') {
                      return trip.companyName
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase());
                    } else if (selectedFilter == 'By Price') {
                      return trip.price
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase());
                    } else if (selectedFilter == 'By From') {
                      return trip.from
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase());
                    } else if (selectedFilter == 'By To') {
                      return trip.to
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase());
                    } else {
                      return trip.companyName
                              .toLowerCase()
                              .contains(searchController.text.toLowerCase()) ||
                          trip.price
                              .toLowerCase()
                              .contains(searchController.text.toLowerCase()) ||
                          trip.from
                              .toLowerCase()
                              .contains(searchController.text.toLowerCase()) ||
                          trip.to
                              .toLowerCase()
                              .contains(searchController.text.toLowerCase());
                    }
                  }).toList();

                  if (filteredTrips.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/images/no_result.json', // Use your Lottie file path here
                            width: 150,
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'No trips found',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Try adjusting your filters or search term.',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return AnimatedList(
                    key: GlobalKey<AnimatedListState>(),
                    initialItemCount: filteredTrips.length,
                    itemBuilder: (context, index, animation) {
                      final trip = filteredTrips[index];
                      return SlideTransition(
                        position: animation.drive(Tween(
                          begin: Offset(1, 0),
                          end: Offset(0, 0),
                        ).chain(CurveTween(curve: Curves.easeInOut))),
                        child: FadeTransition(
                          opacity: animation,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: RouteCard(
                              imageUrl:
                                  'https://t3.ftcdn.net/jpg/02/51/59/46/360_F_251594672_c7xertPrElSFJ5eTd6V0CmQE1CyGC6Ke.jpg',
                              companyName: trip.companyName,
                              tripId: trip.tripId,
                              from: trip.from,
                              to: trip.to,
                              price: trip.price,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
