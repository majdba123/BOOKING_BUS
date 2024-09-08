class RateDriverModel {
  final double Driving_Rateing;
  final double Speed_Rateing;

  RateDriverModel({
    required this.Driving_Rateing,
    required this.Speed_Rateing,
  });

  factory RateDriverModel.fromJson(Map<String, dynamic> json) {
    return RateDriverModel(
      Driving_Rateing: (json['Driving_Rateing'] as num).toDouble(),
      Speed_Rateing: (json['Speed_Rateing'] as num).toDouble(),
    );
  }
}
