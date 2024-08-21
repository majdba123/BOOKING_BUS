class Address {
  final String id;
  final String city;
  final String area;

  Address({required this.id, required this.city, required this.area});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'].toString(),
      city: json['city'],
      area: json['area'],
    );
  }
}
