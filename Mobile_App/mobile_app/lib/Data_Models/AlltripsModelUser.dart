import 'package:flutter/src/material/radio_list_tile.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/Data_Models/BUS_Trip.dart';

class AllTrips {
  final int tripId;
  final String companyName;
  final String from;
  final String to;
  final String price;

  AllTrips({
    required this.tripId,
    required this.companyName,
    required this.from,
    required this.to,
    required this.price,
  });

  factory AllTrips.fromJson(Map<String, dynamic> json) {
    return AllTrips(
      tripId: json['trip_id'],
      companyName: json['company_name'],
      from: json['from'],
      to: json['to'],
      price: json['price'],
    );
  }
}
