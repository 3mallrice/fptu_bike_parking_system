class PackageModel {
  final String? name;
  final int? coinAmount;
  final int? price;
  final int? extraCoin;
  final int? expPackage;

  PackageModel({
    this.name,
    this.coinAmount,
    this.price,
    this.extraCoin,
    this.expPackage,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      name: json['name'],
      coinAmount: json['coinAmount'],
      price: json['price'],
      extraCoin: json['extraCoin'],
      expPackage: json['expPackage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'coinAmount': coinAmount,
      'price': price,
      'extraCoin': extraCoin,
      'expPackage': expPackage,
    };
  }
}
