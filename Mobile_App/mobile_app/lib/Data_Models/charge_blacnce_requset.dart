class ChargeRequest {
  final int id;
  final int userId;
  final String image;
  final String status;
  final String point;

  ChargeRequest({
    required this.id,
    required this.userId,
    required this.image,
    required this.status,
    required this.point,
  });

  factory ChargeRequest.fromJson(Map<String, dynamic> json) {
    return ChargeRequest(
      id: json['id'],
      userId: json['user_id'],
      image: 'http://127.0.0.1:8000/storage/${json['image']}',
      status: json['status'],
      point: json['point'],
    );
  }
}
