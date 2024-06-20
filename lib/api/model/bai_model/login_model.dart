class UserData {
  final String? bearerToken;
  final String? name;
  final String? email;
  final String? role;

  UserData({
    this.bearerToken,
    this.name,
    this.email,
    this.role,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      bearerToken: json['bearerToken'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
    );
  }
}
