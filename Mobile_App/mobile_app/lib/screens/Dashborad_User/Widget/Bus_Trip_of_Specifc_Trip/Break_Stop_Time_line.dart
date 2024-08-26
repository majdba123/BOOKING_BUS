import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';
import 'package:mobile_app/screens/Dashborad_User/Widget/Bus_Trip_of_Specifc_Trip/Road_Path_line.dart';

Widget buildBreakStopTimeline(busTrip) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Stops',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
          color: AppColors.primaryColor,
        ),
      ),
      SizedBox(height: 10.0),
      LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final segmentWidth = totalWidth / busTrip.breaks.length;
          return Stack(
            alignment: Alignment.centerLeft,
            children: [
              Positioned(
                left: segmentWidth / 2,
                right: segmentWidth / 2,
                child: CustomPaint(
                  size: Size(
                    totalWidth - segmentWidth,
                    10.0,
                  ),
                  painter: RoadPathPainter(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: busTrip.breaks.map<Widget>((breakPlace) {
                  return Container(
                    width: segmentWidth,
                    child: Column(
                      children: [
                        Text(
                          '40',
                          // breakPlace.time, // Time of the stop
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Icon(
                          Icons.location_on,
                          color: AppColors.primaryColor,
                          size: 20.0,
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          breakPlace.nameBreak, // Name of the stop
                          style: TextStyle(
                            fontSize: 12.0,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    ],
  );
}
