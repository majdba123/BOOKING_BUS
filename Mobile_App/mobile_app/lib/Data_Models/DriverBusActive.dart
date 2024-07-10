class DriverBusActive {
  final int id;
  final int busId;
  final int driverId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int driverUserId;
  final int driverCompanyId;
  final String driverStatus;
  final DateTime driverCreatedAt;
  final DateTime driverUpdatedAt;

  DriverBusActive({
    required this.id,
    required this.busId,
    required this.driverId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.driverUserId,
    required this.driverCompanyId,
    required this.driverStatus,
    required this.driverCreatedAt,
    required this.driverUpdatedAt,
  });

  factory DriverBusActive.fromJson(Map<String, dynamic> json) {
    return DriverBusActive(
      id: json['id'],
      busId: json['bus_id'],
      driverId: json['driver_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      driverUserId: json['driver']['user_id'],
      driverCompanyId: json['driver']['company_id'],
      driverStatus: json['driver']['status'],
      driverCreatedAt: DateTime.parse(json['driver']['created_at']),
      driverUpdatedAt: DateTime.parse(json['driver']['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bus_id': busId,
      'driver_id': driverId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'driver': {
        'user_id': driverUserId,
        'company_id': driverCompanyId,
        'status': driverStatus,
        'created_at': driverCreatedAt.toIso8601String(),
        'updated_at': driverUpdatedAt.toIso8601String(),
      },
    };
  }
}
