class Reservation {
  final String message;
  final String reservationId;
  final String busTripId;
  final String breakName;
  final List<Seat> seats;
  final int price;
  final String userName;

  Reservation({
    required this.message,
    required this.reservationId,
    required this.busTripId,
    required this.breakName,
    required this.seats,
    required this.price,
    required this.userName,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    var seatList = json['seats'] as List;
    List<Seat> seatObjs =
        seatList.map((seatJson) => Seat.fromJson(seatJson)).toList();

    return Reservation(
      message: json['message'],
      reservationId: json['reservation_id'],
      busTripId: json['bus_trip_id'],
      breakName: json['break'],
      seats: seatObjs,
      price: json['price'],
      userName: json['user_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'reservation_id': reservationId,
      'bus_trip_id': busTripId,
      'break': breakName,
      'seats': seats.map((seat) => seat.toJson()).toList(),
      'price': price,
      'user_name': userName,
    };
  }

  map(Function(dynamic seat) param0) {}
}

class Seat {
  final String id;
  final String seatId;
  final String reservationId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Seat({
    required this.id,
    required this.seatId,
    required this.reservationId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      id: json['id'],
      seatId: json['seat_id'],
      reservationId: json['reservation_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seat_id': seatId,
      'reservation_id': reservationId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
