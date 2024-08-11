import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/screens/Dashborad_User/All_Trip_Page.dart';
import 'package:mobile_app/screens/Dashborad_User/All_compines.dart';
import 'package:mobile_app/screens/Dashborad_User/Auto_Scroll_list_horizental_Trip.dart';
import 'package:mobile_app/screens/Dashborad_User/HorizontalList.dart';
import 'package:mobile_app/screens/Dashborad_User/Pusher_Client/Pusher_Client.dart';
import 'package:mobile_app/screens/Dashborad_User/Pusher_Client/Pusher_SinlgeTon.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/CardInfoTripHorizontalList.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Card_for_Add_favorites_comapny.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/bottom_nav_bar.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/route_card.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/search_Trip_form.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/section_title.dart';
import 'package:mobile_app/screens/signin_page.dart';
import 'package:mobile_app/widgets/my_text_button.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';

class DashboardUser extends StatefulWidget {
  @override
  State<DashboardUser> createState() => _DashboardUserState();
}

class _DashboardUserState extends State<DashboardUser> {
  Map<String, String> _eventData = {};

  // late PusherClient pusher;
  // late Channel channel;

  @override
  void initState() {
    super.initState();
    PusherService().subscribeToChannel("my-channel", (event) {
      setState(() {
        _eventData["form-submitted"] = event.data;
        print('the event data from trip is!!!');
        print(event.data);
      });
    });
    // WidgetsBinding.instance.addObserver(this);
    // Fetch all trips when the screen is initialized
    Provider.of<TripuserProvider>(context, listen: false).getallTrips(
        Provider.of<AuthProvider>(context, listen: false).accessToken);

    Provider.of<TripuserProvider>(context, listen: false).getAllcompanies(
        Provider.of<AuthProvider>(context, listen: false).accessToken);

    // PusherChannelServies.instance.onconnectProced();
  }

  void _logout(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false).logout();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: AppColors.primaryColor,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 25.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 160.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'NameApp',
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        Text(
                          'Book your bus',
                          style: TextStyle(color: Colors.green, fontSize: 10.0),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications_sharp, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.logout, color: Colors.white),
                    onPressed: () => _logout(context),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Container(
                  color: AppColors.primaryColor,
                  height: 150.0,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                  margin: EdgeInsets.only(top: 10.0),
                  child: SearchBusForm(),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<TripuserProvider>(
                builder: (context, tripProvider, child) {
                  if (tripProvider.trips.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionTitle(
                        title: 'All Trip',
                        navigateTo: AllTripage(),
                      ),
                      SizedBox(height: 8.0),
                      AutoScrollingHorizontalList(
                        items: tripProvider.trips
                            .map((trip) => RouteCard(
                                  imageUrl:
                                      'https://t3.ftcdn.net/jpg/02/51/59/46/360_F_251594672_c7xertPrElSFJ5eTd6V0CmQE1CyGC6Ke.jpg',
                                  companyName: trip.companyId,
                                  tripId: trip.tripId,
                                  from: trip.from,
                                  to: trip.to,
                                  price: trip.price,
                                ))
                            .toList(),
                      ),
                      SizedBox(height: 12.0),
                      SectionTitle(
                        title: 'Top Company',
                        navigateTo: AllCompaniesPage(),
                      ),
                      SizedBox(height: 8.0),
                      AutoScrollingHorizontalList(
                        items: tripProvider.compaines
                            .map((company) => CardfavoriteCompany(
                                  name_of_company: company.nameCompany,
                                  image_link: 'ads',
                                  company_id: company.id,
                                ))
                            .toList(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
