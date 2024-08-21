import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:mobile_app/screens/Dashborad_Driver/Journey_Detailes_Page/JourneyDetailsScreen.dart';

class JourneyCard extends StatelessWidget {
  final String from;
  final String to;
  final String timeLeft;
  final String departureTime;
  final String arrivalTime;
  final String stops;
  final String passengers;
  final Color bgColor;
  final Color tagColor;
  final double fontSize;
  final double iconSize;
  final Color dashColor;
  final bool showArrowIcon;
  final bool
      showDetailsButton; // Add this property to control the visibility of the "VIEW DETAILS" button

  JourneyCard({
    required this.from,
    required this.to,
    required this.timeLeft,
    required this.departureTime,
    required this.arrivalTime,
    required this.stops,
    required this.passengers,
    required this.bgColor,
    required this.tagColor,
    required this.fontSize,
    required this.iconSize,
    required this.dashColor,
    this.showArrowIcon = false,
    this.showDetailsButton = true, // Default value is true
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$from to $to',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: tagColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  timeLeft,
                  style: TextStyle(
                    fontSize: fontSize * 0.75,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                departureTime,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text(
                arrivalTime,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, size: iconSize, color: Colors.grey),
              Text(
                ' $from CMBT',
                style: TextStyle(
                  fontSize: fontSize * 0.75,
                  color: Colors.grey,
                ),
              ),
              Spacer(),
              Icon(Icons.location_on, size: iconSize, color: Colors.grey),
              Text(
                ' $to BS',
                style: TextStyle(
                  fontSize: fontSize * 0.75,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Row(
                children: [
                  Icon(Icons.people, size: iconSize, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    passengers,
                    style: TextStyle(
                      fontSize: fontSize * 0.75,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Text(
                stops,
                style: TextStyle(
                  fontSize: fontSize * 0.75,
                  color: Colors.grey,
                ),
              ),
              Spacer(),
              if (showDetailsButton)
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JourneyDetailsScreen(),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        'VIEW DETAILS',
                        style: TextStyle(
                          fontSize: fontSize * 0.75,
                          color: tagColor,
                        ),
                      ),
                      if (showArrowIcon)
                        Icon(
                          Icons.arrow_forward,
                          size: iconSize * 0.8,
                          color: tagColor,
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
