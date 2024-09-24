import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/user/Accpeted_private_trip_By_company.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Map_in_private_trip/CreatePrivateTrip.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Map_in_private_trip/map.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/PrivateTrip/TripCard.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/user/private_Trip_provider.dart';
import 'package:mobile_app/Colors.dart';
import 'package:lottie/lottie.dart'; // Import the Lottie package

class PrivateTripByStatus extends StatefulWidget {
  @override
  State<PrivateTripByStatus> createState() => _PrivateTripByStatusState();
}

class _PrivateTripByStatusState extends State<PrivateTripByStatus> {
  var accessToken;
  @override
  void initState() {
    super.initState();

    accessToken = Provider.of<AuthProvider>(context, listen: false).accessToken;
    context.read<PrivateTripuserProvider>().fetchTripsByStatus(accessToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => MapUI(),
                ),
                // result: ModalRoute.withName('/mainPageUser'),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: Text(
          'Private Trip',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
      body: Stack(
        children: [
          backImage(context),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: context.watch<PrivateTripuserProvider>().status,
                      items:
                          <String>['pending', 'completed'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        context
                            .read<PrivateTripuserProvider>()
                            .setStatus(newValue!);
                        // final accessToken =
                        //     Provider.of<AuthProvider>(context, listen: false)
                        //         .accessToken;
                        context
                            .read<PrivateTripuserProvider>()
                            .fetchTripsByStatus(accessToken);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Consumer<PrivateTripuserProvider>(
                    builder: (context, tripProvider, child) {
                      if (tripProvider.isLoading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (tripProvider.privatetrips.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                'assets/images/comming_soon.json',
                                width: 300,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                              // SizedBox(height: 20),
                              Text(
                                'No Private Trips Make one Now !..',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: tripProvider.privatetrips.length,
                        itemBuilder: (context, index) {
                          // return TripCard(index: index);
                          return TripCardPrivateTrip(
                              tripProvider.privatetrips[index], index);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
