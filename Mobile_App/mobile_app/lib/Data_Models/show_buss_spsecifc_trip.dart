import 'dart:convert';

class BusResponse {
  int busId;
  String from;
  String to;
  String fromTime;
  String toTime;
  String type;
  String event;
  List<Break> breaks;
  List<Seat> seats;

  BusResponse({
    required this.busId,
    required this.from,
    required this.to,
    required this.fromTime,
    required this.toTime,
    required this.type,
    required this.event,
    required this.breaks,
    required this.seats,
  });

  factory BusResponse.fromJson(Map<String, dynamic> json) {
    var breaksFromJson = json['breaks'] as List;
    List<Break> breaksList = breaksFromJson.map((i) => Break.fromJson(i)).toList();

    var seatsFromJson = json['seats'] as List;
    List<Seat> seatsList = seatsFromJson.map((i) => Seat.fromJson(i)).toList();

    return BusResponse(
      busId: json['bus_id'],
      from: json['from'],
      to: json['to'],
      fromTime: json['from_time'],
      toTime: json['to_time'],
      type: json['type'],
      event: json['event'],
      breaks: breaksList,
      seats: seatsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bus_id': busId,
      'from': from,
      'to': to,
      'from_time': fromTime,
      'to_time': toTime,
      'type': type,
      'event': event,
      'breaks': breaks.map((e) => e.toJson()).toList(),
      'seats': seats.map((e) => e.toJson()).toList(),
    };
  }
}

class Break {
  String government;
  String nameBreak;
  String status;

  Break({
    required this.government,
    required this.nameBreak,
    required this.status,
  });

  factory Break.fromJson(Map<String, dynamic> json) {
    return Break(
      government: json['government'],
      nameBreak: json['name_break'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'government': government,
      'name_break': nameBreak,
      'status': status,
    };
  }
}

class Seat {
  int status;

  Seat({required this.status});

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(status: json['status']);
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
    };
  }
}