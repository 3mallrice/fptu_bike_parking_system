class HowDidYouParkAndSpend {
  final DateTime date;
  final int numberOfParkings;
  final int amount;

  HowDidYouParkAndSpend({
    required this.date,
    required this.numberOfParkings,
    required this.amount,
  });

  factory HowDidYouParkAndSpend.fromJson(Map<String, dynamic> json) {
    return HowDidYouParkAndSpend(
      date: json['date'],
      numberOfParkings: json['numberOfParkings'],
      amount: json['amount'],
    );
  }
}

class PaymentMethodUsage {
  final String method;
  final int count;

  PaymentMethodUsage({
    required this.method,
    required this.count,
  });

  factory PaymentMethodUsage.fromJson(Map<String, dynamic> json) {
    return PaymentMethodUsage(
      method: json['method'],
      count: json['count'],
    );
  }
}
