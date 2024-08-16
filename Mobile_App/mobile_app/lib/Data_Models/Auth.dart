class AuthResponse {
  final String accessToken;
  final String typeUser;

  AuthResponse({required this.accessToken, required this.typeUser});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'],
      typeUser: json['type_user'],
    );
  }
}