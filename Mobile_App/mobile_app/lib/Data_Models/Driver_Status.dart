import 'company.dart'; // Assuming you have the Company class in a separate file.
import 'user.dart'; // Assuming you have the User class in a separate file.

class DriverStauts {
  final int id;
  final String name;
  final String email;
  final String status;

  DriverStauts({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
  });

  factory DriverStauts.fromJson(Map<String, dynamic> json) {
    return DriverStauts(
      id: json['driver_id'],
      name: json['name'],
      email: json['email_driver'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'status': status,
    };
  }
}
