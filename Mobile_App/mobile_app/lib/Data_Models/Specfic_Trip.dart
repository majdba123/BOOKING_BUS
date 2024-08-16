// models.dart

class SpecificTrip {
  int id;
  int companyId;
  int pathId;
  String status;
  double price;
  String createdAt;
  String updatedAt;
  List<BusDetails> busTrip;
  List<BreakTrip> breaksTrip;
  PathDetails path;

  SpecificTrip({
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

  factory SpecificTrip.fromJson(Map<String, dynamic> json) {
    var busTripList = json['bus_trip'] as List;
    List<BusDetails> busTrips = busTripList.map((e) => BusDetails.fromJson(e)).toList();

    var breaksList = json['breaks_trip'] as List;
    List<BreakTrip> breaksTrips = breaksList.map((e) => BreakTrip.fromJson(e)).toList();

    return SpecificTrip(
      id: json['id'],
      companyId: json['company_id'],
      pathId: json['path_id'],
      status: json['status'],
      price: double.parse(json['price']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      busTrip: busTrips,
      breaksTrip: breaksTrips,
      path: PathDetails.fromJson(json['path']),
    );
  }
}

class BusDetails {
  int id;
  int tripId;
  int busId;
  String fromTime;
  String date;
  String toTime;
  String status;
  String type;
  String event;
  String createdAt;
  String updatedAt;
  List<Pivot> pivot;

  BusDetails({
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

  factory BusDetails.fromJson(Map<String, dynamic> json) {
    var pivotList = json['pivoit'] as List;
    List<Pivot> pivots = pivotList.map((e) => Pivot.fromJson(e)).toList();

    return BusDetails(
      id: json['id'],
      tripId: json['trip_id'],
      busId: json['bus_id'],
      fromTime: json['from_time'],
      date: json['date'],
      toTime: json['to_time'],
      status: json['status'],
      type: json['type'],
      event: json['event'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      pivot: pivots,
    );
  }
}

class BreakTrip {
  int id;
  int tripId;
  int breaksId;
  String createdAt;
  String updatedAt;
  Break breakDetails;

  BreakTrip({
    required this.id,
    required this.tripId,
    required this.breaksId,
    required this.createdAt,
    required this.updatedAt,
    required this.breakDetails,
  });

  factory BreakTrip.fromJson(Map<String, dynamic> json) {
    return BreakTrip(
      id: json['id'],
      tripId: json['trip_id'],
      breaksId: json['breaks_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      breakDetails: Break.fromJson(json['break']),
    );
  }
}

class Break {
  int id;
  int areaId;
  String name;
  String createdAt;
  String updatedAt;
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
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      area: Area.fromJson(json['area']),
    );
  }
}

class Area {
  int id;
  String name;
  String createdAt;
  String updatedAt;

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
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class PathDetails {
  int id;
  int companyId;
  String from;
  String to;
  String createdAt;
  String updatedAt;

  PathDetails({
    required this.id,
    required this.companyId,
    required this.from,
    required this.to,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PathDetails.fromJson(Map<String, dynamic> json) {
    return PathDetails(
      id: json['id'],
      companyId: json['company_id'],
      from: json['from'],
      to: json['to'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class Pivot {
  int id;
  int busTripId;
  int breaksTripId;
  String status;
  String createdAt;
  String updatedAt;

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
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
