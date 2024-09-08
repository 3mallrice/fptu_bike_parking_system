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

class VnPayReturn {
  final int vnpAmount;
  final String vnpBankCode;
  final String vnpBankTranNo;
  final String vnpCardType;
  final String vnpOrderInfo;
  final String vnpPayDate;
  final String vnpResponseCode;
  final String vnpTmnCode;
  final String vnpTransactionNo;
  final String vnpTransactionStatus;
  final String vnpTxnRef;
  final String vnpSecureHash;

  VnPayReturn({
    required this.vnpAmount,
    required this.vnpBankCode,
    required this.vnpBankTranNo,
    required this.vnpCardType,
    required this.vnpOrderInfo,
    required this.vnpPayDate,
    required this.vnpResponseCode,
    required this.vnpTmnCode,
    required this.vnpTransactionNo,
    required this.vnpTransactionStatus,
    required this.vnpTxnRef,
    required this.vnpSecureHash,
  });

  factory VnPayReturn.fromUrl(String url) {
    final uri = Uri.parse(url);
    final queryParams = uri.queryParameters;

    return VnPayReturn(
      vnpAmount: int.parse(queryParams['vnp_Amount'] ?? '0'),
      vnpBankCode: queryParams['vnp_BankCode'] ?? '',
      vnpBankTranNo: queryParams['vnp_BankTranNo'] ?? '',
      vnpCardType: queryParams['vnp_CardType'] ?? '',
      vnpOrderInfo: Uri.decodeComponent(queryParams['vnp_OrderInfo'] ?? ''),
      vnpPayDate: queryParams['vnp_PayDate'] ?? '',
      vnpResponseCode: queryParams['vnp_ResponseCode'] ?? '',
      vnpTmnCode: queryParams['vnp_TmnCode'] ?? '',
      vnpTransactionNo: queryParams['vnp_TransactionNo'] ?? '',
      vnpTransactionStatus: queryParams['vnp_TransactionStatus'] ?? '',
      vnpTxnRef: queryParams['vnp_TxnRef'] ?? '',
      vnpSecureHash: queryParams['vnp_SecureHash'] ?? '',
    );
  }

  @override
  String toString() {
    return 'VnPayReturn{vnpAmount: $vnpAmount, vnpBankCode: $vnpBankCode, vnpBankTranNo: $vnpBankTranNo, vnpCardType: $vnpCardType, vnpOrderInfo: $vnpOrderInfo, vnpPayDate: $vnpPayDate, vnpResponseCode: $vnpResponseCode, vnpTmnCode: $vnpTmnCode, vnpTransactionNo: $vnpTransactionNo, vnpTransactionStatus: $vnpTransactionStatus, vnpTxnRef: $vnpTxnRef, vnpSecureHash: $vnpSecureHash}';
  }
}
