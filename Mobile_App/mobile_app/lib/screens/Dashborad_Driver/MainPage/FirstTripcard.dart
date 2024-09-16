import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/Driver/TripForDriver.dart';
import 'package:mobile_app/Provider/Driver/Driver.dart';
import 'package:provider/provider.dart';

class FirstTrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Consumer<DriverProvider>(builder: (context, provider, child) {
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
      String dateString = "${tripdriver.date_start} ${tripdriver.from_time}";

      DateTime from = DateTime.parse(dateString);

      DateTime now = DateTime.now();

      Duration difference = now.difference(from).abs();

      int days = difference.inDays;
      int totalHours = difference.inHours;
      int hours = totalHours.remainder(24) % 12;
      if (hours == 0) hours = 12;
      String formattedDay = '-1';
      String foramtedHorus = '-1';
      if (days > 0) {
        formattedDay = '$days';
        foramtedHorus = '${hours.toString().padLeft(2, '0')}';
      } else {
        foramtedHorus = '${hours.toString().padLeft(2, '0')}';
      }

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
                    children: <Widget>[
                      if (formattedDay != '-1' && foramtedHorus != '-1') ...[
                        Text(
                          '$formattedDay D',
                          style: TextStyle(
                            fontSize: screenHeight * 0.055,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4267B2),
                          ),
                        ),
                        Text(
                          '${foramtedHorus} hours left',
                          style: TextStyle(
                            fontSize: screenHeight * 0.018,
                            color: Colors.grey[600],
                          ),
                        ),
                      ] else if (formattedDay == '-1') ...[
                        Text(
                          '$foramtedHorus',
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
                      ] else if (formattedDay != '-1') ...[
                        Text(
                          '$formattedDay',
                          style: TextStyle(
                            fontSize: screenHeight * 0.055,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4267B2),
                          ),
                        ),
                      ]
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
