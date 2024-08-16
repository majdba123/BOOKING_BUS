import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/user/Accpeted_private_trip_By_company.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/Provider/Auth_provider.dart';
import 'package:mobile_app/Provider/user/private_Trip_provider.dart';
import 'package:mobile_app/Colors.dart';

class PrivateTripByStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  items: <String>['padding', 'completed'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    context
                        .read<PrivateTripuserProvider>()
                        .setStatus(newValue!);
                    final accessToken =
                        Provider.of<AuthProvider>(context, listen: false)
                            .accessToken;
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
                        child:
                            Text('No Comapany Accpeted this trip until Now'));
                  }
                  return ListView.builder(
                    itemCount: tripProvider.privatetrips.length,
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
    return Consumer<PrivateTripuserProvider>(
      builder: (context, tripProvider, child) {
        final trip = tripProvider.privatetrips[index];

        return InkWell(
          onTap: () {
            tripProvider.settripid(trip.id);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AccpetedPrivateTripByCompany()),
            );
          },
          child: LayoutBuilder(
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
                      Text(
                        'Start Time: ${trip.time}',
                        style: TextStyle(
                          fontSize: textFontSize,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
