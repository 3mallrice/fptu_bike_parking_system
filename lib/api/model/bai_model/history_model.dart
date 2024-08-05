class HistoryModel {
  final String id;
  final DateTime timeIn;
  final DateTime timeOut;
  final String status;
  final String plateNumber;
  final int amount;
  final String gateIn;
  final String gateOut;
  final String paymentMethod;
  final String parkingArea;

  HistoryModel({
    required this.id,
    required this.timeIn,
    required this.timeOut,
    required this.status,
    required this.plateNumber,
    required this.amount,
    required this.gateIn,
    required this.gateOut,
    required this.paymentMethod,
    required this.parkingArea,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'],
      timeIn: DateTime.parse(json['timeIn']),
      timeOut: DateTime.parse(json['timeOut']),
      status: json['status'],
      plateNumber: json['plateNumber'],
      amount: json['amount'],
      gateIn: json['gateIn'],
      gateOut: json['gateOut'],
      paymentMethod: json['paymentMethod'],
      parkingArea: json['parkingArea'],
    );
  }
}
