class UserData {
  String bearerToken;
  String name;
  String email;
  String avatar;

  UserData({
    required this.bearerToken,
    required this.name,
    required this.email,
    required this.avatar,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      bearerToken: json['bearerToken'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bearerToken': bearerToken,
      'name': name,
      'email': email,
      'avatar': avatar,
    };
  }

  @override
  String toString() {
    return 'UserData {bearerToken: $bearerToken, name: $name, email: $email, avartar: $avatar}';
  }
}
