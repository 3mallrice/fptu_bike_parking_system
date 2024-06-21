class UserData {
  final String? bearerToken;
  final String? name;
  final String? email;
  final String? avartar;

  UserData({
    this.bearerToken,
    this.name,
    this.email,
    this.avartar,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      bearerToken: json['bearerToken'],
      name: json['name'],
      email: json['email'],
      avartar: json['avatar'],
    );
  }

  @override
  String toString() {
    return 'UserData {bearerToken: $bearerToken, name: $name, email: $email, avartar: $avartar}';
  }
}
