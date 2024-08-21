class BusInfo {
  int busId;
  String type;
  String startTime;
  String endTime;
String date;
  BusInfo({
    required this.busId,
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.date
  });

  BusInfo copyWith({
    int? busId,
    String? type,
    String? startTime,
    String? endTime,
    String? date,
  }) {
    return BusInfo(
      busId: busId ?? this.busId,
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      date: date ?? this.date,
    );
  }
}
