class BreakData {
  final int break_id;
  final String break_name;
  final double latitude;
  final double longitude;
  final int passengers_count;
  final String pivoit_id;
  BreakData({
    required this.break_id,
    required this.break_name,
    required this.latitude,
    required this.longitude,
    required this.passengers_count,
    required this.pivoit_id,
  });

  factory BreakData.fromJson(Map<String, dynamic> json) {
    return BreakData(
      break_id: json['break_id'],
      break_name: json['break_name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      passengers_count: json['passengers_count'],
      pivoit_id: json['pivoit_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'break_id': break_id,
      'break_name': break_name,
      'latitude': latitude,
      'longitude': longitude,
      'passengers_count': passengers_count,
    };
  }
}
