// screens/private_trip_by_status.dart
import 'package:flutter/material.dart';
import 'package:mobile_app/Api_Services/User/Private_trip.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/Company/Private_Trip_provider.dart';
import 'package:provider/provider.dart';

import 'package:mobile_app/colors.dart';

class PrivateTripByComapany extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final accessToken = Provider.of<AuthProvider>(context).accessToken;
    context.read<PrivateTripProvider>().fetchPrivateTrips(accessToken);

    return Scaffold(
      appBar: AppBar(
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Consumer<PrivateTripProvider>(
                builder: (context, tripProvider, child) {
                  if (tripProvider.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (tripProvider.privateTrips.isEmpty) {
                    return Center(child: Text('No trips available'));
                  }
                  return ListView.builder(
                    itemCount: tripProvider.privateTrips.length,
                    itemBuilder: (context, index) {
                      return TripCard(index: index);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TripCard extends StatelessWidget {
  final int index;

  TripCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer<PrivateTripProvider>(
      builder: (context, tripProvider, child) {
        final trip = tripProvider.privateTrips[index];

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
                                'From: ${trip.from}',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: textFontSize,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                'To: ${trip.to}',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: textFontSize,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                'Date: ${trip.date}',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: smallTextFontSize,
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Time: ${trip.startTime}',
                              style: TextStyle(
                                fontSize: textFontSize,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            SizedBox(height: 4.0),
                          ],
                        ),
                        if (trip.status == 'padding')
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              _showPriceDialog(context, trip.id);
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
}

Future<void> _showPriceDialog(BuildContext context, int tripId) async {
  TextEditingController priceController = TextEditingController();

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // User must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enter Price'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Please enter the price for the private trip:'),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: 'Enter price'),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Accept'),
            onPressed: () {
              if (priceController.text.isNotEmpty) {
                int price = int.parse(priceController.text);
                Navigator.of(context).pop();
                _acceptPrivateOrder(context, tripId, price);
              }
            },
          ),
        ],
      );
    },
  );
}

Future<void> _acceptPrivateOrder(
    BuildContext context, int tripId, int price) async {
  final accessToken =
      Provider.of<AuthProvider>(context, listen: false).accessToken;
  try {
    await PrivateTrip().acceptPrivateOrder(accessToken, tripId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Trip accepted successfully')),
    );
    // Refresh the trips list after successful acceptance
    context.read<PrivateTripProvider>().fetchPrivateTrips(accessToken);
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to accept trip: $error')),
    );
  }
}
