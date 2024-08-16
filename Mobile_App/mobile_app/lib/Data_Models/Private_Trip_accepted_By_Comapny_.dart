class PrivateTripAccpetedBycompanyModel {
  final int id;
  final int company_id;
  final int private_trip_id;
  final String price;

  final String status;

  PrivateTripAccpetedBycompanyModel(
      {required this.id,
      required this.company_id,
      required this.private_trip_id,
      required this.price,

      // required this.price,
      required this.status});

  factory PrivateTripAccpetedBycompanyModel.fromJson(
      Map<String, dynamic> json) {
    return PrivateTripAccpetedBycompanyModel(
      id: json['id'],
      company_id: json['company_id'],
      private_trip_id: json['private_trip_id'],
      price: json['price'],
      status: json['status'],
    );
  }
}
