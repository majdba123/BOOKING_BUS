import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/Driver/TripForDriver.dart';
import 'package:mobile_app/Provider/Driver/TripDriver.dart';
import 'package:provider/provider.dart';

class FirstTrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Consumer<TripDriverProvider>(builder: (context, provider, child) {
      // Handle loading state
      if (provider.isLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      if (provider.errorMessage != null) {
        return Center(
          child: Text('Error: ${provider.errorMessage}'),
        );
      }
      TripForDriverModel? tripdriver = provider.TripDriver;
      if (tripdriver == null) {
        return Center(
          child: Text('No trip available'),
        );
      }
      // DateTime tripTime = DateTime.parse((tripdriver.from_time));

      // DateTime now = DateTime.now();

      // Calculate the difference in hours
      // Duration difference = tripTime.difference(now);
      // double hoursDifference =
      //     difference.inHours + (difference.inMinutes.remainder(60) / 60);
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: Color(0xFF9EDDCE)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${tripdriver?.from} - ${tripdriver?.to}',
                    style: TextStyle(
                      fontSize: screenHeight * 0.013,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '${tripdriver?.Distance} kms, ${tripdriver?.trip_duration} hrs',
                    style: TextStyle(
                      fontSize: screenHeight * 0.011,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                '${tripdriver?.Passengers} Passengers • ${tripdriver?.Stops} Stops',
                style: TextStyle(
                  fontSize: screenHeight * 0.018,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: screenHeight * 0.025),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: screenHeight * 0.015,
                            color: Color(0xFF4267B2),
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          Text(
                            '${tripdriver?.from} ${tripdriver?.from_time} pm',
                            style: TextStyle(
                              fontSize: screenHeight * 0.015,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Container(
                        height: screenHeight * 0.03,
                        child: VerticalDivider(
                          thickness: 2.0,
                          color: Colors.grey[400],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: screenHeight * 0.015,
                            color: Color(0xFF27AE60),
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          Text(
                            '${tripdriver?.to} ${tripdriver?.to_time} am',
                            style: TextStyle(
                              fontSize: screenHeight * 0.015,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '4',
                        style: TextStyle(
                          fontSize: screenHeight * 0.055,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4267B2),
                        ),
                      ),
                      Text(
                        'hours left',
                        style: TextStyle(
                          fontSize: screenHeight * 0.018,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
