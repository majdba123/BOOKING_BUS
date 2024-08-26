import 'package:flutter/material.dart';
import 'package:mobile_app/colors.dart';
import 'SeatLegend.dart';

class SeatLegendRow extends StatelessWidget {
  const SeatLegendRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SeatLegend(label: 'Booked', color: Colors.red),
          SizedBox(width: 16.0),
          SeatLegend(label: 'Available', color: Colors.grey),
          SizedBox(width: 16.0),
          SeatLegend(label: 'Your Seat', color: AppColors.primaryColor),
        ],
      ),
    );
  }
}
