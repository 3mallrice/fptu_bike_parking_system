class UserData {
  String bearerToken;
  String name;
  String email;
  String avatar;
  String customerType;

  UserData({
    required this.bearerToken,
    required this.name,
    required this.email,
    required this.avatar,
    required this.customerType,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      bearerToken: json['bearerToken'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
      customerType: json['customerType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bearerToken': bearerToken,
      'name': name,
      'email': email,
      'avatar': avatar,
      'customerType': customerType,
    };
  }

  @override
  String toString() {
    return 'UserData {bearerToken: $bearerToken, name: $name, email: $email, avatar: $avatar, customerType: $customerType}';
  }
}

class CustomerType {
  static const String paid = "PAID";
  static const String nonPaid = "NONPAID";
}
