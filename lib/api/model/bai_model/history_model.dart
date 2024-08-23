class HistoryModel {
  final String id;
  final DateTime timeIn;
  final DateTime? timeOut;
  final String status;
  final String plateNumber;
  final int? amount;
  final String gateIn;
  final String? gateOut;
  final String? paymentMethod;
  final String parkingArea;
  final bool isFeedback;
  final int? moneyEstimated;

  HistoryModel({
    required this.id,
    required this.timeIn,
    this.timeOut,
    required this.status,
    required this.plateNumber,
    this.amount,
    required this.gateIn,
    this.gateOut,
    this.paymentMethod,
    required this.parkingArea,
    required this.isFeedback,
    this.moneyEstimated,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'],
      timeIn: DateTime.parse(json['timeIn']),
      timeOut: json['timeOut'] != null ? DateTime.parse(json['timeOut']) : null,
      status: json['status'],
      plateNumber: json['plateNumber'],
      amount: json['amount'],
      gateIn: json['gateIn'],
      gateOut: json['gateOut'],
      paymentMethod: json['paymentMethod'],
      parkingArea: json['parkingArea'],
      isFeedback: json['isFeedback'],
      moneyEstimated: json['moneyEstimated'],
    );
  }

  @override
  String toString() {
    return 'HistoryModel{id: $id, timeIn: $timeIn, timeOut: $timeOut, status: $status, plateNumber: $plateNumber, amount: $amount, gateIn: $gateIn, gateOut: $gateOut, paymentMethod: $paymentMethod, parkingArea: $parkingArea, isFeedback: $isFeedback, moneyEstimated: $moneyEstimated}';
  }
}
