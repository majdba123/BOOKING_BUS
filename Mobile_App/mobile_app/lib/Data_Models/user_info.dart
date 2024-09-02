class UserInfomodel {
  final String id;
  final String name;
  final String email;
  final String points;
  final String? profile_image;
  final String? phoneNumber;

  UserInfomodel({
    required this.id,
    required this.name,
    required this.email,
    required this.points,
    required this.profile_image,
    required this.phoneNumber,
  });

  factory UserInfomodel.fromJson(Map<String, dynamic> json) {
    return UserInfomodel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        points: json['point'],
        profile_image: json['profile_image'],
        phoneNumber: json['phoneNumber']);
  }
}
