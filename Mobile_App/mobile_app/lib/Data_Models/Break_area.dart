class BreakArea {
  final int id;
   final int areaId;
  final String name;
  final DateTime createdAt;
 final DateTime updatedAt;
  BreakArea({
    required this.id,
    required this.areaId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BreakArea.fromJson(Map<String, dynamic> json) {
    return BreakArea(
      id: json['id'],
      name: json['name'],
     areaId:json['area_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
