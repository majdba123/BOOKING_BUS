import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Driver/Driver.dart';
import 'package:provider/provider.dart';

class PassengerListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Consumer<DriverProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (provider.PassengerListAtPivoit == null ||
            provider.PassengerListAtPivoit!.isEmpty) {
          return Center(child: Text('No passengers At this Breack'));
        }
        return Column(
          children:
              provider.PassengerListAtPivoit!.asMap().entries.map((entry) {
            int index = entry.key;
            String passenger = entry.value;

            return Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
              child: Row(
                children: [
                  Icon(Icons.arrow_upward,
                      color: Colors.green, size: screenHeight * 0.022),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    ' ${index + 1}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenHeight * 0.018,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    '- $passenger',
                    style: TextStyle(
                      fontSize: screenHeight * 0.018,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
