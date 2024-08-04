// models/private_trip_company.dart
class PrivateTripCompany {
  final int id;
  final int userId;
  final String from;
  final String to;
  final String date;
  final String startTime;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  PrivateTripCompany({
    required this.id,
    required this.userId,
    required this.from,
    required this.to,
    required this.date,
    required this.startTime,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PrivateTripCompany.fromJson(Map<String, dynamic> json) {
    return PrivateTripCompany(
      id: json['id'],
      userId: json['user_id'],
      from: json['from'],
      to: json['to'],
      date: json['date'],
      startTime: json['start_time'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
