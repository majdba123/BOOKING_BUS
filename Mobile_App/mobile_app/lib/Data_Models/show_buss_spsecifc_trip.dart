import 'dart:convert';
import 'dart:ffi';

import 'package:mobile_app/Data_Models/Breack_place.dart';

class BusResponse {
  int bus_trip_id;
  String busId;
  String from;
  String to;
  String nameCompany;
  String ReturnfromTime;
  String ReturntoTime;
  String goingfromTime;
  String goingtoTime;
  String date_start;
  String date_end;
  String type;
  String event;
  int Distance;
  int price;
  String tripDuration;
  List<BreakPlace> breaks;
  int seats;

  BusResponse({
    required this.bus_trip_id,
    required this.busId,
    required this.from,
    required this.to,
    required this.ReturnfromTime,
    required this.ReturntoTime,
    required this.goingfromTime,
    required this.goingtoTime,
    required this.nameCompany,
    required this.date_start,
    required this.date_end,
    required this.type,
    required this.event,
    required this.breaks,
    required this.seats,
    required this.Distance,
    required this.tripDuration,
    required this.price,
  });

  factory BusResponse.fromJson(Map<String, dynamic> json) {
    var breaksFromJson = json['breaks'] as List;
    List<BreakPlace> breaksList =
        breaksFromJson.map((i) => BreakPlace.fromJson(i)).toList();
    print(breaksList);
    // var seatsFromJson = json['seats'] as List;
    // List<SeatModel> seatsList =
    //     seatsFromJson.map((i) => SeatModel.fromJson(i)).toList();

    return BusResponse(
        bus_trip_id: json['bus_trip_id'],
        busId: json['bus_id'],
        from: json['from'],
        to: json['to'],
        nameCompany: json['nameCompany'],
        goingfromTime: json['goingfromTime'],
        goingtoTime: json['goingtoTime'],
        ReturnfromTime: json['ReturnfromTime'],
        ReturntoTime: json['ReturntoTime'],
        date_end: json['date_end'],
        date_start: json['date_start'],
        type: json['type'],
        event: json['event'],
        breaks: breaksList,
        seats: json['seats'],
        Distance: json['Distance'],
        tripDuration: json['tripDuration'],
        price: json['price']);
  }
}
