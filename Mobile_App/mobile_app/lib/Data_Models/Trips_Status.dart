class TripByStatus {
  String tripid;
  // int companyId;
  String pathId;
  String status;
  double price;
  String createdAt;
  String updatedAt;


  TripByStatus({
    required this.tripid,
    // required this.companyId,
    required this.pathId,
    required this.status,
    required this.price,
    required this.createdAt,
    required this.updatedAt,

  });

  factory TripByStatus.fromJson(Map<String, dynamic> json) {

    return TripByStatus(
      tripid: json['id'],
      // companyId: json['company_id'],
      pathId: json['path_id'],
      status: json['status'],
      price: double.parse(json['price']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      
    );
  }
}