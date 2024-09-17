class Notifaction {
  final int id;
  final String notification;
  final DateTime created_at;

  Notifaction({
    required this.id,
    required this.notification,
    required this.created_at,
  });

  factory Notifaction.fromJson(Map<String, dynamic> json) {
    return Notifaction(
      id: json['id'],
      notification: json['notification'],
      created_at: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'notification': notification,
      'created_at': created_at.toIso8601String(),
    };
  }
}
