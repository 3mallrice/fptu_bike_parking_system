class CoinPackage {
  final String id;
  final String packageName;
  final String amount;
  final int price;
  final int? extraCoin;
  final int? extraEXP;

  CoinPackage({
    required this.id,
    required this.packageName,
    required this.amount,
    required this.price,
    this.extraCoin,
    this.extraEXP,
  });

  factory CoinPackage.fromJson(Map<String, dynamic> json) {
    return CoinPackage(
      id: json['id'],
      packageName: json['name'],
      amount: json['coinAmount'],
      price: json['price'],
      extraCoin: json['extraCoin'],
      extraEXP: json['expPackage'],
    );
  }
}
