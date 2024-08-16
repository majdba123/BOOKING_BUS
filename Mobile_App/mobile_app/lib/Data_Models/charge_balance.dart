class ChargeBalance {
  final int id;
  final int userId;
  final String image;
  final String point;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChargeBalance({
    required this.id,
    required this.userId,
    required this.image,
    required this.point,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChargeBalance.fromJson(Map<String, dynamic> json) {
    return ChargeBalance(
      id: json['id'],
      userId: json['user_id'],
      image: json['image'],
      point: json['point'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'image': image,
      'point': point,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
