class Inquiry {
  final int id;
  final int userId;
  final String email;
  final String question;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Inquiry({
    required this.id,
    required this.userId,
    required this.email,
    required this.question,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Inquiry.fromJson(Map<String, dynamic> json) {
    return Inquiry(
      id: json['id'],
      userId: json['user_id'],
      email: json['email'],
      question: json['quastion'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'email': email,
      'quastion': question,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
