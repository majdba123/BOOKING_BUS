class UserFavorite {
  final String companyId;

  UserFavorite({required this.companyId});

  factory UserFavorite.fromJson(Map<String, dynamic> json) {
    return UserFavorite(
      companyId: json['company_id'],
    );
  }
}
