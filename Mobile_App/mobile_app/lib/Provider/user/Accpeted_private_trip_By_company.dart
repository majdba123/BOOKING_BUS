import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/User/Private_trip.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/user/private_Trip_provider.dart';
import 'package:provider/provider.dart';

import 'package:mobile_app/colors.dart';

class AccpetedPrivateTripByCompany extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: Text(
          'Accpeted Private Trip By Company',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<void>(
          future: _fetchTrips(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading trips'));
            } else {
              return Consumer<PrivateTripuserProvider>(
                builder: (context, tripProvider, child) {
                  if (tripProvider.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (tripProvider.privatetripsRequest.isEmpty) {
                    return Center(child: Text('No trips available'));
                  }
                  return ListView.builder(
                    itemCount: tripProvider.privatetripsRequest.length,
                    itemBuilder: (context, index) {
                      return TripCard(index: index);
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _fetchTrips(BuildContext context) async {
    final accessToken =
        Provider.of<AuthProvider>(context, listen: false).accessToken;
    final tripId =
        Provider.of<PrivateTripuserProvider>(context, listen: false).tripId;
    await context
        .read<PrivateTripuserProvider>()
        .fetchPrivateTripsAccepetedRequsetByComapny(tripId!, accessToken);
  }
}

class TripCard extends StatelessWidget {
  final int index;

  TripCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer<PrivateTripuserProvider>(
      builder: (context, tripProvider, child) {
        final trip = tripProvider.privatetripsRequest[index];

        return LayoutBuilder(
          builder: (context, constraints) {
            double cardPadding = constraints.maxWidth * 0.04;
            double imageWidth = constraints.maxWidth * 0.12;
            double textFontSize = constraints.maxWidth * 0.045;
            double smallTextFontSize = constraints.maxWidth * 0.035;

            return Card(
              margin: EdgeInsets.only(bottom: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
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
                              Text(
                                'CompanyID: ${trip.company_id}',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: textFontSize,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                'N.Private Trip: ${trip.private_trip_id}',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: textFontSize,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  trip.price,
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: cardPadding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            _acceptPrivateOrder(context, trip.private_trip_id);
                          },
                          child: Text('Accept'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _acceptPrivateOrder(BuildContext context, String tripId) async {
    final accessToken =
        Provider.of<AuthProvider>(context, listen: false).accessToken;
    try {
      await PrivateTrip().acceptPrivateOrder(accessToken, tripId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Trip accepted successfully')),
      );

      // Refresh the trips list after successful acceptance
      context.read<PrivateTripuserProvider>().fetchTripsByStatus(accessToken);
      Navigator.of(context).pop();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to accept trip: $error')),
      );
    }
  }
}
