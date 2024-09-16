class CancelRule {
  final int hours_before;
  final double discount_percentage;
  final String description;
  CancelRule({
    required this.hours_before,
    required this.discount_percentage,
    required this.description,
  });

  factory CancelRule.fromJson(Map<String, dynamic> json) {
    return CancelRule(
      hours_before: json['hours_before'],
      discount_percentage: double.parse(json['discount_percentage']),
      description: json['description'],
    );
  }
}
