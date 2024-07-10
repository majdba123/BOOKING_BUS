class BusInfo {
  int busId;
  String type;
  String startTime;
  String endTime;

  BusInfo({
    required this.busId,
    required this.type,
    required this.startTime,
    required this.endTime,
  });

  BusInfo copyWith({
    int? busId,
    String? type,
    String? startTime,
    String? endTime,
  }) {
    return BusInfo(
      busId: busId ?? this.busId,
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
