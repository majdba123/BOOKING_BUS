import 'package:flutter/material.dart';
import 'package:mobile_app/Colors.dart';

Column buildTimeLocationColumn(
    String time, String location, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        time,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
        ),
      ),
      SizedBox(height: 4.0),
      Text(
        location,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14.0,
        ),
      ),
    ],
  );
}
