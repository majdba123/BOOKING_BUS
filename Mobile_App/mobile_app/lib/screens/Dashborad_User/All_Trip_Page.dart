import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Provider/user/Trip_user_provider.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/route_card.dart';

class AllTripage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Trips'),
      ),
      body: Consumer<TripuserProvider>(
        builder: (context, tripProvider, child) {
          if (tripProvider.trips.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: tripProvider.trips.length,
            itemBuilder: (context, index) {
              final trip = tripProvider.trips[index];
              return RouteCard(
                imageUrl:
                    'https://t3.ftcdn.net/jpg/02/51/59/46/360_F_251594672_c7xertPrElSFJ5eTd6V0CmQE1CyGC6Ke.jpg',
                companyName: trip.companyId,
                tripId: trip.tripId,
                from: trip.from,
                to: trip.to,
                price: trip.price,
              );
            },
          );
        },
      ),
    );
  }
}
