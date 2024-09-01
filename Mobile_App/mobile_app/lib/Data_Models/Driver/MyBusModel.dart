class MyBusModel {
  final String company_name;
  final String number_bus;
  final int number_passenger;

  MyBusModel(
      {required this.company_name,
      required this.number_bus,
      required this.number_passenger});

  factory MyBusModel.fromJson(Map<String, dynamic> json) {
    return MyBusModel(
        company_name: json['company_name'],
        number_bus: json['number_bus'],
        number_passenger: json['number_passenger']);
  }
}
