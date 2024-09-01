class Seat {
  final String id;
  final String bus_id;
  final int status;
  final DateTime createdAt;
 final DateTime updatedAt;
  Seat({
    required this.id,
    required this.bus_id,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      id: json['id'],
      bus_id: json['bus_id'],
       status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
