class SeatModel {
  final int status;
  final int id;
  SeatModel({
    required this.status,
    required this.id,
  });

  factory SeatModel.fromJson(Map<String, dynamic> json) {
    return SeatModel(
      status: json['status'],
      id: json['id'],
    );
  }
}
