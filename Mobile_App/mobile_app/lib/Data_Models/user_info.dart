class UserInfomodel {
  final String name;
  final String email;
  final String points;
  var profile;

  UserInfomodel(
      {required this.name,
      required this.email,
      required this.points,
      required this.profile});

  factory UserInfomodel.fromJson(Map<String, dynamic> json) {
    return UserInfomodel(
      name: json['name'],
      email: json['email'],
      points: json['point'],
      profile: json['profile'],
    );
  }
}
