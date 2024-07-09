class Driver {
  final int id;
  final int user_id;
  final int company_id;
  final String status;
  final DateTime createdAt;
 final DateTime updatedAt;
  Driver({
    required this.id,
    required this.user_id,
    required this.company_id,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      user_id: json['user_id'],
     company_id: json['company_id'],
       status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
