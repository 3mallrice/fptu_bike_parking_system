class ZaloPayModel {
  final int returnCode;
  final String returnMessage;
  final int subReturnCode;
  final String subReturnMessage;
  final String orderUrl;
  final String zpTransToken;
  final String orderToken;
  final String qrCode;

  ZaloPayModel({
    required this.returnCode,
    required this.returnMessage,
    required this.subReturnCode,
    required this.subReturnMessage,
    required this.orderUrl,
    required this.zpTransToken,
    required this.orderToken,
    required this.qrCode,
  });

  factory ZaloPayModel.fromJson(Map<String, dynamic> json) {
    return ZaloPayModel(
      returnCode: json['return_code'],
      returnMessage: json['return_message'],
      subReturnCode: json['sub_return_code'],
      subReturnMessage: json['sub_return_message'],
      orderUrl: json['order_url'],
      zpTransToken: json['zp_trans_token'],
      orderToken: json['order_token'],
      qrCode: json['qr_code'],
    );
  }
}

class VnPayResponse {
  final String paymentUrl;

  VnPayResponse({
    required this.paymentUrl,
  });

  factory VnPayResponse.fromJson(Map<String, dynamic> json) {
    return VnPayResponse(
      paymentUrl: json['paymentUrl'],
    );
  }
}
