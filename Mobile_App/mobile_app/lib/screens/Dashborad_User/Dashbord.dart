import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/screens/Dashborad_User/All_Trip_Page.dart';
import 'package:mobile_app/screens/Dashborad_User/All_compines.dart';
import 'package:mobile_app/screens/Dashborad_User/Auto_Scroll_list_horizental_Trip.dart';
import 'package:mobile_app/screens/Dashborad_User/Horizental_list_Fav_company.dart';
import 'package:mobile_app/screens/Dashborad_User/HorizontalList.dart';
import 'package:mobile_app/screens/Dashborad_User/Pusher_Client/Pusher_Client.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/card_for_add_favorites_comapny.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/filtter_Bar_main_ui.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/route_card.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/search_Trip_form.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/section_title.dart';
import 'package:mobile_app/screens/signin_page.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';

class DashboardUser extends StatefulWidget {
  @override
  State<DashboardUser> createState() => _DashboardUserState();
}

class _DashboardUserState extends State<DashboardUser> {
  Map<String, String> _eventData = {};
  bool _isSubscribed = false; // Track subscription status
  bool _dataLoaded = false; // Track if data has been loaded

  @override
  void initState() {
    super.initState();
    _subscribeToPusher();
    _loadData(); // Load data once on initialization
  }

  @override
  void dispose() {
    _unsubscribeFromPusher(); // Unsubscribe when leaving the screen
    super.dispose();
  }

  void _subscribeToPusher() {
    if (!_isSubscribed) {
      PusherService().subscribeToChannel("my-channel", (event) {
        setState(() {
          _eventData["form-submitted"] = event.data;
          print('the event data from trip is!!!');
          print(event.data);
        });
      });
      _isSubscribed = true;
    }
  }

  void _unsubscribeFromPusher() {
    if (_isSubscribed) {
      PusherService().unsubscribeFromChannel("my-channel");
      _isSubscribed = false;
    }
  }

  void _loadData() {
    if (!_dataLoaded) {
      // Only load data if it hasn't been loaded yet
      final tripProvider =
          Provider.of<TripuserProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      tripProvider.getallTrips(authProvider.accessToken);
      tripProvider.getAllcompanies(authProvider.accessToken);

      setState(() {
        _dataLoaded = true; // Mark data as loaded
      });
    }
  }

  void _logout(BuildContext context) {
    _unsubscribeFromPusher(); // Unsubscribe on logout
    Provider.of<AuthProvider>(context, listen: false).logout();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: AppColors.primaryColor,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 20.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'BusX',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.notifications,
                                    color: Colors.white),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.logout, color: Colors.white),
                                onPressed: () => _logout(context),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Book your bus!',
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      color: AppColors.primaryColor,
                      height: 180.0,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      margin: EdgeInsets.only(top: 20.0),
                      child: SearchBusForm(),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Consumer<TripuserProvider>(
                    builder: (context, tripProvider, child) {
                      if (tripProvider.AllTripsItems.isEmpty) {
                        return Center(child: CircularProgressIndicator());
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionTitle(
                            title: 'Popular Trips',
                            navigateTo: AllTripage(),
                          ),
                          SizedBox(height: 8.0),
                          AutoScrollingHorizontalList(
                            items: tripProvider.AllTripsItems.map(
                                (trip) => RouteCard(
                                      imageUrl:
                                          'https://t3.ftcdn.net/jpg/02/51/59/46/360_F_251594672_c7xertPrElSFJ5eTd6V0CmQE1CyGC6Ke.jpg',
                                      companyName: trip.companyName,
                                      tripId: trip.tripId,
                                      from: trip.from,
                                      to: trip.to,
                                      price: trip.price,
                                    )).toList(),
                          ),
                          SizedBox(height: 12.0),
                          SectionTitle(
                            title: 'Top Companies',
                            navigateTo: AllCompaniesPage(),
                          ),
                          SizedBox(height: 8.0),
                          AutoScrollingHorizontalListCompany(
                            items: tripProvider.compaines
                                .map((company) => CardfavoriteCompany(
                                      name_of_company: company.nameCompany,
                                      image_link:
                                          'https://alkadmous.com/SD08/msf/1481723158_57034255.jpg',
                                      company_id: company.id,
                                    ))
                                .toList(),
                          ),
                          SizedBox(height: 80.0),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          _buildBottomNavBar(),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Positioned(
      left: MediaQuery.of(context).size.width * 0.15,
      right: MediaQuery.of(context).size.width * 0.15,
      bottom: MediaQuery.of(context).size.height * 0.03,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(35.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: FilterBarUserUi(
          height: 70.0,
          iconSize: 28.0,
        ),
      ),
    );
  }
}
