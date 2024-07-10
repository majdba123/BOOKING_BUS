import 'company.dart';  // Assuming you have the Company class in a separate file.
import 'user.dart';     // Assuming you have the User class in a separate file.

class Driver {
  final int id;
  final int userId;
  final int companyId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User? user;
  final Company? company;

  Driver({
    required this.id,
    required this.userId,
    required this.companyId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.company,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      userId: json['user_id'],
      companyId: json['company_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      company: json['company'] != null ? Company.fromJson(json['company']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'company_id': companyId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user': user?.toJson(),
      'company': company?.toJson(),
    };
  }
}
