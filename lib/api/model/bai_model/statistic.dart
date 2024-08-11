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
      date: DateTime.parse(json['date']),
      numberOfParkings: json['totalPayment'],
      amount: json['amount'],
    );
  }

  //toString method
  @override
  String toString() {
    return 'HowDidYouParkAndSpend{date: $date, numberOfParkings: $numberOfParkings, amount: $amount}';
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
      method: json['paymentMethod'],
      count: json['totalPayment'],
    );
  }

  //toString method
  @override
  String toString() {
    return 'PaymentMethodUsage{method: $method, count: $count}';
  }
}
