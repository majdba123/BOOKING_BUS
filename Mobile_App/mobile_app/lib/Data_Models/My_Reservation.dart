class MYReservation {
  final String id;
  final String from;
  final String to;
  final String type;
  final String status;
  final String breakName;
  final double price;
  final List<Seat> seats;

  MYReservation({
    required this.id,
    required this.from,
    required this.to,
    required this.type,
    required this.status,
    required this.breakName,
    required this.price,
    required this.seats,
  });

  factory MYReservation.fromJson(Map<String, dynamic> json) {
    var seatsFromJson = json['seats'] as List;
    List<Seat> seatList =
        seatsFromJson.map((seat) => Seat.fromJson(seat)).toList();

    return MYReservation(
      id: json['id'],
      from: json['from'],
      to: json['to'],
      type: json['type'],
      status: json['status'],
      breakName: json['break'],
      price: double.parse(json['price']),
      seats: seatList,
    );
  }
}

class Seat {
  final String id;
  final int status;

  Seat({required this.id, required this.status});

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      id: json['id'],
      status: json['status'],
    );
  }
}
