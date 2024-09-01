class DriverBusActive {
  final String id;
  final String busId;
  final String driver_name;
  final int ?driver_phone;
  final String status;
  final String company_name;
 final String bus_plate_number;


  DriverBusActive({
    required this.id,
    required this.busId,
    required this.driver_name,
    required this.status,
    required this.driver_phone,
    required this.company_name,
    required this.bus_plate_number,
    
  });

  factory DriverBusActive.fromJson(Map<String, dynamic> json) {
    return DriverBusActive(
      id: json['id'],
      busId: json['bus_id'],
      driver_name: json['driver_name'],
      driver_phone: json['driver_phone']!=null ?json['driver_phone']:null,
      status: json['status'],
      company_name: json['company_name'],
      bus_plate_number: json['bus_plate_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bus_id': busId,
      'driver_name': driver_name,
      'driver_phone': driver_phone,
      'status': status,
     'company_name': company_name,
      'bus_plate_number': bus_plate_number,
    };
  }
}
