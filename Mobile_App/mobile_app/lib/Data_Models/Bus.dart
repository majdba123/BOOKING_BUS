class Bus {
  final String id;
  final String companyId;
  final String number_bus;
  final int number_passenger;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  Bus({
    required this.id,
    required this.companyId,
    required this.number_bus,
    required this.number_passenger,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id'],
      companyId: json['company_id'],
      number_bus: json['number_bus'],
      number_passenger: json['number_passenger'] is int
          ? json['number_passenger']
          : int.tryParse(json['number_passenger']),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
