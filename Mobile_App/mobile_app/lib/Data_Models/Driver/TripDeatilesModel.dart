import 'package:mobile_app/Data_Models/Driver/BreakTripModel.dart';

class TripDeatilesModel {
  final int bus_trip_id;
  final String bus_id;
  final double from_lat;
  final double from_long;
  final double to_lat;
  final double to_long;
  final List<BreakData> breaks_data;

  TripDeatilesModel({
    required this.bus_trip_id,
    required this.bus_id,
    required this.from_lat,
    required this.from_long,
    required this.to_lat,
    required this.to_long,
    required this.breaks_data,
  });

  factory TripDeatilesModel.fromJson(Map<String, dynamic> json) {
    var list = json['breaks_data'] as List;
    List<BreakData> breaksList =
        list.map((i) => BreakData.fromJson(i)).toList();

    return TripDeatilesModel(
      bus_trip_id: json['bus_trip_id'],
      bus_id: json['bus_id'],
      from_lat: json['from_lat'],
      from_long: json['from_long'],
      to_lat: json['to_lat'],
      to_long: json['to_long'],
      breaks_data: breaksList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bus_trip_id': bus_trip_id,
      'bus_id': bus_id,
      'from_lat': from_lat,
      'from_long': from_long,
      'to_lat': to_lat,
      'to_long': to_long,
      'breaks_data':
          breaks_data.map((breakData) => breakData.toJson()).toList(),
    };
  }
}
