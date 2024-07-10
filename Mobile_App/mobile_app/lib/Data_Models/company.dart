import 'package:mobile_app/Data_Models/user.dart';

class Company {
  final int id;
  final int userId;
  final String nameCompany;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User user;

  Company({
    required this.id,
    required this.userId,
    required this.nameCompany,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      userId: json['user_id'],
      nameCompany: json['name_company'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name_company': nameCompany,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user': user.toJson(),
    };
  }
}