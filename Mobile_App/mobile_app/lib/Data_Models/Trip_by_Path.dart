
class TripByPath {
  final int tripId;
  final String companyId;
  final String from;
  final String to;
  final String price;
  final List<BusTrip> busTrips;

  TripByPath({
    required this.tripId,
    required this.companyId,
    required this.from,
    required this.to,
    required this.price,
    required this.busTrips,
  });

  factory TripByPath.fromJson(Map<String, dynamic> json) {
    var busTripsJson = json['bus_trips'] as List;
    List<BusTrip> busTripsList =
        busTripsJson.map((busTrip) => BusTrip.fromJson(busTrip)).toList();

    return TripByPath(
      tripId: json['trip_id'],
      companyId: json['company_id'],
      from: json['from'],
      to: json['to'],
      price: json['price'],
      busTrips: busTripsList,
    );
  }
}

class BusTrip {
  final int busId;
  final String fromTime;
  final String toTime;
  final String type;
  final String event;
  final int seatCount;

  BusTrip({
    required this.busId,
    required this.fromTime,
    required this.toTime,
    required this.type,
    required this.event,
    required this.seatCount,
  });

  factory BusTrip.fromJson(Map<String, dynamic> json) {
    var seatsJson = json['seats'] as List;
    int seatCount = seatsJson.length;

    return BusTrip(
      busId: json['bus_id'],
      fromTime: json['from_time'],
      toTime: json['to_time'],
      type: json['type'],
      event: json['event'],
      seatCount: seatCount,
    );
  }
}
