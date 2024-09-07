class TripForDriverModel {
  final int id;
  final String bus_id;
  final String from;
  final String to;
  final int Distance;
  final String from_time;
  final String to_time;
  final String ReturnfromTime;
  final String ReturntoTime;
  final String date;
  final int Passengers;
  final int Stops;
  final String trip_duration;
  final String status;

  TripForDriverModel({
    required this.id,
    required this.bus_id,
    required this.from,
    required this.to,
    required this.Distance,
    required this.from_time,
    required this.to_time,
    required this.ReturnfromTime,
    required this.ReturntoTime,
    required this.date,
    required this.Passengers,
    required this.Stops,
    required this.trip_duration,
    required this.status,
  });

  factory TripForDriverModel.fromJson(Map<String, dynamic> json) {
    return TripForDriverModel(
      id: json['id'],
      bus_id: json['bus_id'],
      from: json['from'],
      to: json['to'],
      Distance: json['Distance'],
      from_time: json['goingfromTime'],
      to_time: json['goingtoTime'],
      ReturnfromTime: json['ReturnfromTime'],
      ReturntoTime: json['ReturntoTime'],
      date: json['date'],
      Passengers: json['Passengers'],
      Stops: json['Stops'],
      trip_duration: json['trip_duration'],
      status: json['status'],
    );
  }
}
