import 'package:flutter/material.dart';
import 'package:mobile_app/Data_Models/BUS_Trip.dart';

class BreakPlace {
  final String breakId;
  final String latitude;
  final String longitude;
  final String government;
  final String nameBreak;
  final String status;

  BreakPlace({
    required this.breakId,
    required this.government,
    required this.nameBreak,
    required this.status,
    required this.latitude,
    required this.longitude,
  });

  factory BreakPlace.fromJson(Map<String, dynamic> json) {
    return BreakPlace(
      breakId: json['break_id'],
      government: json['government'],
      nameBreak: json['name_break'],
      status: json['status'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  map(RadioListTile<Break> Function(dynamic point) param0) {}
}
