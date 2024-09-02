class PrivateTripModel {
  final String id;
  final String from;
  final String to;
  final String date;
  final String time;
  // final double price;
  int Distance;
  final String lat_from;
  final String long_from;
  final String lat_to;
  final String long_to;

  PrivateTripModel({
    required this.id,
    required this.from,
    required this.to,
    required this.date,
    required this.time,
    // required this.price,
    required this.Distance,
    required this.lat_from,
    required this.lat_to,
    required this.long_from,
    required this.long_to,
  });

  factory PrivateTripModel.fromJson(Map<String, dynamic> json) {
    return PrivateTripModel(
      id: json['id'],
      from: json['from'],
      to: json['to'],
      date: json['date'],
      time: json['start_time'],
      // price: json['price'],
      Distance: json['Distance'],
      lat_from: json['from_latitude'],
      long_from: json['from_longitude'],
      lat_to: json['to_latitude'],
      long_to: json['to_longitude'],
    );
  }
}
