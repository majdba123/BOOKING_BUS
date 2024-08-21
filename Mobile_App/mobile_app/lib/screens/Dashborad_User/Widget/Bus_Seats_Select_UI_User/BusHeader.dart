import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/Colors.dart';

class BusHeader extends StatelessWidget {
  final String companyName;
  final String from;
  final String to;
  final String fromTime;
  final String toTime;

  const BusHeader({
    Key? key,
    required this.companyName,
    required this.from,
    required this.to,
    required this.fromTime,
    required this.toTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20.0,
        bottom: 15.0,
        left: 16.0,
        right: 16.0,
      ),
      child: Column(
        children: [
          Text(
            companyName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailColumn(Icons.place, from),
              _buildDetailColumn(Icons.access_time, '$fromTime - $toTime'),
              _buildDetailColumn(Icons.place, to),
            ],
          ),
          SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIconWithText(Icons.timer, '5 min'),
              SizedBox(width: 12.0),
              _buildIconWithText(Icons.wb_sunny, '24°C'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailColumn(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        SizedBox(height: 2.0),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildIconWithText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 16),
        SizedBox(width: 4.0),
        Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }
}
