import 'package:flutter/src/material/radio_list_tile.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/Data_Models/BUS_Trip.dart';

class TripByPath {
  final int tripId;
  final String companyId;
  final String from;
  final String to;
  final String price;
  final List<BusTrip> busTrips;

  TripByPath({
    required this.tripId,
    required this.companyId,
    required this.from,
    required this.to,
    required this.price,
    required this.busTrips,
  });

  factory TripByPath.fromJson(Map<String, dynamic> json) {
    var busTripsJson = json['bus_trips'] as List;
    List<BusTrip> busTripsList =
        busTripsJson.map((busTrip) => BusTrip.fromJson(busTrip)).toList();

    return TripByPath(
      tripId: json['trip_id'],
      companyId: json['company_id'],
      from: json['from'],
      to: json['to'],
      price: json['price'],
      busTrips: busTripsList,
    );
  }
}

class BusTrip {
  final int busId;
  final String fromTime;
  final String toTime;
  final String type;
  final String event;
  final int seatCount;
  final List<BreakPlace> breaks;
  final List<SeatModel> seats;
  final String duration; // Add this field

  BusTrip({
    required this.busId,
    required this.fromTime,
    required this.toTime,
    required this.type,
    required this.event,
    required this.seatCount,
    required this.breaks,
    required this.seats,
    required this.duration, // Add this field
  });

  factory BusTrip.fromJson(Map<String, dynamic> json) {
    var seatsJson = json['seats'] as List;
    List<SeatModel> seatsList =
        seatsJson.map((seat) => SeatModel.fromJson(seat)).toList();

    var breaksJson = json['pivot'] as List;
    List<BreakPlace> breaksList = breaksJson
        .map((breakPlace) => BreakPlace.fromJson(breakPlace))
        .toList();

    // Parse the times and calculate the duration
    DateFormat dateFormat = DateFormat('HH:mm');
    DateTime fromDateTime = dateFormat.parse(json['from_time']);
    DateTime toDateTime = dateFormat.parse(json['to_time']);
    Duration duration = toDateTime.difference(fromDateTime);
    String formattedDuration = formatDurationAsHHMM(duration);

    return BusTrip(
      busId: json['bus_id'],
      fromTime: json['from_time'],
      toTime: json['to_time'],
      type: json['type'],
      event: json['event'],
      seatCount: seatsList.length,
      breaks: breaksList,
      seats: seatsList,
      duration: formattedDuration, // Set the calculated duration
    );
  }

  static String formatDurationAsHHMM(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}

class BreakPlace {
  final int breakId;
  final String government;
  final String nameBreak;
  final String status;

  BreakPlace({
    required this.breakId,
    required this.government,
    required this.nameBreak,
    required this.status,
  });

  factory BreakPlace.fromJson(Map<String, dynamic> json) {
    return BreakPlace(
      breakId: json['break_id'],
      government: json['government'],
      nameBreak: json['name_break'],
      status: json['status'],
    );
  }

  map(RadioListTile<Break> Function(dynamic point) param0) {}
}

class SeatModel {
  final int status;
  final int id;
  SeatModel({
    required this.status,
    required this.id,
  });

  factory SeatModel.fromJson(Map<String, dynamic> json) {
    return SeatModel(
      status: json['status'],
      id: json['id'],
    );
  }
}
