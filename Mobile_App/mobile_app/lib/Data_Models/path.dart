class Path {
  final int id;
  final int companyId;
  final String from;
  final String to;
  final DateTime createdAt;
  final DateTime updatedAt;

  Path({
    required this.id,
    required this.companyId,
    required this.from,
    required this.to,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Path.fromJson(Map<String, dynamic> json) {
    return Path(
      id: json['id'],
      companyId: json['company_id'],
      from: json['from'],
      to: json['to'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
