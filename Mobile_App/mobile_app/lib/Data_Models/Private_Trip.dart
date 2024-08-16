class PrivateTripModel {
  final int id;
  final String from;
  final String to;
  final String date;
  final String time;
  // final double price;
  final String status;

  PrivateTripModel(
      {required this.id,
      required this.from,
      required this.to,
      required this.date,
      required this.time,
      // required this.price,
      required this.status});

  factory PrivateTripModel.fromJson(Map<String, dynamic> json) {
    return PrivateTripModel(
      id: json['id'],
      from: json['from'],
      to: json['to'],
      date: json['date'],
      time: json['start_time'],
      // price: json['price'],
      status: json['status'],
    );
  }
}
