// WalletModel: amount: int, transactionDescription: String, transactionStatus: String, date: String, transactionType: String
class WalletModel {
  final int amount;
  final String? transactionDescription;
  final String transactionStatus;
  final DateTime date;
  final String transactionType;

  WalletModel({
    required this.amount,
    this.transactionDescription,
    required this.transactionStatus,
    required this.date,
    required this.transactionType,
  });

  // Factory constructor để khởi tạo từ JSON
  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      amount: json['amount'],
      transactionDescription: json['transactionDescription'],
      transactionStatus: json['transactionStatus'],
      date: DateTime.parse(json['date']),
      transactionType: json['transactionType'],
    );
  }
}

class ExtraBalanceModel {
  final int balance;
  final DateTime? expiredDate;

  ExtraBalanceModel({
    required this.balance,
    this.expiredDate,
  });

  factory ExtraBalanceModel.fromJson(Map<String, dynamic> json) {
    return ExtraBalanceModel(
      balance: json['balance'],
      expiredDate: json['expiredDate'] != null
          ? DateTime.tryParse(json['expiredDate'])
          : null,
    );
  }
}
