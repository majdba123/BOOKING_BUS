import 'package:flutter/material.dart';

class JourneyRouteInfo2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

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
                  'Coimbatore to Chennai',
                  style: TextStyle(
                    fontSize: screenHeight * 0.02,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  '48 Passengers · 28 Stops',
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
              'IN 4 HOURS',
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
