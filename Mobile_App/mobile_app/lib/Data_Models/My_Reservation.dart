class MYReservation {
  final String id;
  final int busTripId;
  final String price;
  final String type;
  final String company_name;
  final String Pickup_Point;
  final String from;
  final String to;
  final int Distance;
  final String start_time;
  final String end_time;
  final String trip_Duration;
  final String Date;
  final int seats;

  MYReservation({
    required this.id,
    required this.busTripId,
    required this.price,
    required this.type,
    required this.company_name,
    required this.Pickup_Point,
    required this.from,
    required this.to,
    required this.Distance,
    required this.start_time,
    required this.end_time,
    required this.trip_Duration,
    required this.Date,
    required this.seats,
  });

  factory MYReservation.fromJson(Map<String, dynamic> json) {
    // var seatsFromJson = json['seats'] as List;
    // List<Seat> seatList =
    //     seatsFromJson.map((seat) => Seat.fromJson(seat)).toList();

    return MYReservation(
      id: json['id'],
      busTripId: json['bustrip_id'],
      price: json['price'],
      type: json['type'],
      company_name: json['company_name'],
      Pickup_Point: json['Pickup_Point'],
      from: json['from'],
      to: json['to'],
      Distance: json['Distance'],
      start_time: json['start_time'],
      end_time: json['end_time'],
      trip_Duration: json['trip_Duration'],
      Date: json['Date'],
      seats: json['seats'],
    );
  }
}

// class Seat {
//   final String id;
//   final int status;

//   Seat({required this.id, required this.status});

//   factory Seat.fromJson(Map<String, dynamic> json) {
//     return Seat(
//       id: json['id'],
//       status: json['status'],
//     );
//   }
// }
