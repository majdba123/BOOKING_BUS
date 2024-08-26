import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/user/Buss_of_spsecfic_trip.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Bus_Seats_Select_UI_User/SeatsGridPage.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Bus_Trip_of_Specifc_Trip/Break_Stop_Time_line.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Bus_Trip_of_Specifc_Trip/Cloumn_Time_location.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Colors.dart';

class BusCardofSpecicTrip extends StatefulWidget {
  @override
  _BusCardofSpecicTripState createState() => _BusCardofSpecicTripState();
}

class _BusCardofSpecicTripState extends State<BusCardofSpecicTrip> {
  @override
  void initState() {
    super.initState();
    final provider =
        Provider.of<BussofSpsccifTripProvider>(context, listen: false);
    final authprovider = Provider.of<AuthProvider>(context, listen: false);
    provider.getBussofSpecicTrip(provider.tripid, authprovider.accessToken);
  }

  @override
  Widget build(BuildContext context) {
    var providerTripUser =
        Provider.of<TripuserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryColor,
                AppColors.primaryColor.withOpacity(0.8),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
          child: Consumer<BussofSpsccifTripProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading || provider.busResponses.isEmpty) {
                return const Text('Loading...');
              }

              final busTrip = provider.busResponses.first;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          busTrip.from,
                          style: const TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(
                          Icons.directions_bus,
                          color: Colors.white,
                          size: 28.0,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          busTrip.to,
                          style: const TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  const Center(
                    child: Text(
                      'Available Bus Trips',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        centerTitle: false,
      ),
      body: Consumer<BussofSpsccifTripProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final busTrips = provider.busResponses;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: busTrips.length,
            itemBuilder: (context, index) {
              final busTrip = busTrips[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 3,
                child: InkWell(
                  onTap: () {
                    providerTripUser.selectBusTrip(busTrip);

                    providerTripUser.selectTripType((busTrip.type == 'all')
                        ? 2
                        : (busTrip.type == 'going')
                            ? 1
                            : -1);
                    provider.setFrom(busTrip.from);
                    provider.setTo(busTrip.to);
                    provider.setFromTime(busTrip.fromTime);
                    provider.setToTime(busTrip.toTime);
                    provider.setDuration(busTrip.tripDuration);
                    provider.setDistance(busTrip.Distance);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SeatsGridPage(),
                      ),
                    );
                  },
                  splashColor: AppColors.primaryColor.withOpacity(0.1),
                  highlightColor: Colors.grey.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: const DecorationImage(
                                  image:
                                      AssetImage('assets/images/logo_bus.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    busTrip.nameCompany,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    'Type: ${busTrip.type}',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text('Price: ${busTrip.price}\$',
                                  style: TextStyle(color: Colors.green[800])),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildTimeLocationColumn(
                                busTrip.fromTime, busTrip.from, context),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/distance.png',
                                  width: 30,
                                  height: 30,
                                ),
                                const SizedBox(
                                    width:
                                        2), // Add some space between the image and the text
                                Text(
                                  '${busTrip.Distance}km',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            buildTimeLocationColumn(
                                busTrip.toTime, busTrip.to, context),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Divider(
                          height: 32.0,
                          thickness: 1.5,
                          color: Colors.grey[300],
                        ),
                        buildBreakStopTimeline(busTrip),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            const Icon(Icons.access_time),
                            Text(' ${busTrip.tripDuration} H',
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0)),
                            const Spacer(),
                            Row(
                              children: [
                                const Icon(Icons.person, size: 20),
                                const SizedBox(width: 4.0),
                                Text('${busTrip.seats} Seats',
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 14.0)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}