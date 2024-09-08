import 'package:flutter/material.dart';
import 'package:mobile_app/Provider/Driver/Driver.dart';
import 'package:provider/provider.dart';

class JourneyRouteInfo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    var driverProvider = Provider.of<DriverProvider>(context, listen: false);
    var trip = driverProvider.MyTrip?[driverProvider.indextrip];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${trip?.from} to ${trip?.to}',
                  style: TextStyle(
                    fontSize: screenHeight * 0.02,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  '${trip?.Passengers} Passengers · ${trip?.Stops} Stops',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: screenHeight * 0.018,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.02,
              vertical: screenHeight * 0.008,
            ),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 233, 222),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${trip?.status}',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
                fontSize: screenHeight * 0.014,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
