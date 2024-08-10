// WalletModel: amount: int, transactionDescription: String, transactionStatus: String, date: String, transactionType: String
class WalletModel {
  final String id;
  final int amount;
  final String? description;
  final String status;
  final DateTime date;
  final String type;

  WalletModel({
    required this.id,
    required this.amount,
    this.description,
    required this.status,
    required this.date,
    required this.type,
  });

  // Factory constructor để khởi tạo từ JSON
  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'],
      amount: json['amount'],
      description: json['transactionDescription'],
      status: json['transactionStatus'],
      date: DateTime.parse(json['date']),
      type: json['transactionType'],
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
