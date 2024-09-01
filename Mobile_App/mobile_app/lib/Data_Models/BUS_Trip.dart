import 'dart:convert';

class BusTrip {
  String id;
  String companyId;
  String pathId;
  String status;
  String price;
  DateTime createdAt;
  DateTime updatedAt;
  List<BusTripDetails> busTrip;
  List<BreaksTrip> breaksTrip;
  Path2 path;

  BusTrip({
    required this.id,
    required this.companyId,
    required this.pathId,
    required this.status,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    required this.busTrip,
    required this.breaksTrip,
    required this.path,
  });

  factory BusTrip.fromJson(Map<String, dynamic> json) {
    return BusTrip(
      id: json['id'],
      companyId: json['company_id'],
      pathId: json['path_id'],
      status: json['status'],
      price: json['price'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      busTrip: List<BusTripDetails>.from(
          json['bus_trip'].map((x) => BusTripDetails.fromJson(x))),
      breaksTrip: List<BreaksTrip>.from(
          json['breaks_trip'].map((x) => BreaksTrip.fromJson(x))),
      path: Path2.fromJson(json['path']),
    );
  }
}

class BusTripDetails {
  String id;
  String tripId;
  String busId;
  String fromTime;
  String date;
  String toTime;
  String status;
  String type;
  String event;
  DateTime createdAt;
  DateTime updatedAt;
  List<Pivot> pivot;

  BusTripDetails({
    required this.id,
    required this.tripId,
    required this.busId,
    required this.fromTime,
    required this.date,
    required this.toTime,
    required this.status,
    required this.type,
    required this.event,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
  });

  factory BusTripDetails.fromJson(Map<String, dynamic> json) {
    return BusTripDetails(
      id: json['id'],
      tripId: json['trip_id'],
      busId: json['bus_id'],
      fromTime: json['from_time'],
      date: json['date'],
      toTime: json['to_time'],
      status: json['status'],
      type: json['type'],
      event: json['event'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      pivot: List<Pivot>.from(json['pivoit'].map((x) => Pivot.fromJson(x))),
    );
  }
}

class Pivot {
  String id;
  String busTripId;
  String breaksTripId;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  Pivot({
    required this.id,
    required this.busTripId,
    required this.breaksTripId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      id: json['id'],
      busTripId: json['bus__trip_id'],
      breaksTripId: json['breaks_trip_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class BreaksTrip {
  String id;
  String tripId;
  String breaksId;
  DateTime createdAt;
  DateTime updatedAt;
  Break breakDetails;

  BreaksTrip({
    required this.id,
    required this.tripId,
    required this.breaksId,
    required this.createdAt,
    required this.updatedAt,
    required this.breakDetails,
  });

  factory BreaksTrip.fromJson(Map<String, dynamic> json) {
    return BreaksTrip(
      id: json['id'],
      tripId: json['trip_id'],
      breaksId: json['breaks_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      breakDetails: Break.fromJson(json['break']),
    );
  }
}

class Break {
  String id;
  String areaId;
  String name;
  DateTime createdAt;
  DateTime updatedAt;
  Area area;

  Break({
    required this.id,
    required this.areaId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.area,
  });

  factory Break.fromJson(Map<String, dynamic> json) {
    return Break(
      id: json['id'],
      areaId: json['area_id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      area: Area.fromJson(json['area']),
    );
  }
}

class Area {
  String id;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  Area({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Path2 {
  String id;
  String companyId;
  String from;
  String to;
  DateTime createdAt;
  DateTime updatedAt;

  Path2({
    required this.id,
    required this.companyId,
    required this.from,
    required this.to,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Path2.fromJson(Map<String, dynamic> json) {
    return Path2(
      id: json['id'],
      companyId: json['company_id'],
      from: json['from'],
      to: json['to'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
