class HowDidYouParkAndSpend {
  final int totalPaymentInThisMonth;
  final int totalTimePakedInThisMonth;

  HowDidYouParkAndSpend({
    required this.totalPaymentInThisMonth,
    required this.totalTimePakedInThisMonth,
  });

  factory HowDidYouParkAndSpend.fromJson(Map<String, dynamic> json) {
    return HowDidYouParkAndSpend(
      totalPaymentInThisMonth: json['totalPaymentInThisMonth'],
      totalTimePakedInThisMonth: json['totalTimePakedInThisMonth'],
    );
  }

  //toString method
  @override
  String toString() {
    return 'HowDidYouParkAndSpend{numberOfParkings: $totalTimePakedInThisMonth, totalPayment: $totalPaymentInThisMonth}';
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
