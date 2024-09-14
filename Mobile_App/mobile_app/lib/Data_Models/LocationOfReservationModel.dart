class LocationOFRservation {
  final String name;
  final double latitude;
  final double longitude;
  LocationOFRservation({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory LocationOFRservation.fromJson(Map<String, dynamic> json) {
    return LocationOFRservation(
      name: json['name'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
    );
  }
}
