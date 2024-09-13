import 'dart:convert';

import 'package:bai_system/api/model/bai_model/api_response.dart';
import 'package:bai_system/api/model/bai_model/payment_model.dart';
import 'package:bai_system/core/const/frontend/message.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../../core/const/frontend/error_catcher.dart';
import '../../../core/helper/local_storage_helper.dart';
import 'api_root.dart';

class CallPaymentApi {
  static const String baseUrl = APIRoot.root;
  static const apiName = '/deposit';
  final String api = baseUrl + apiName;

  String token = "";
  var log = Logger();

  //POST: /api/deposit/{packageId}
  //Deposit money to get coin via ZaloPay
  Future<APIResponse<ZaloPayModel>> depositCoinZaloPay(String packageId) async {
    try {
      token = GetLocalHelper.getBearerToken() ?? "";

      if (token == "") {
        log.e('Token is empty');
        return APIResponse(
          isTokenValid: false,
          message: ErrorMessage.tokenInvalid,
        );
      }

      final response = await http.post(
        Uri.parse('$api/zalopay/$packageId'),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        APIResponse<ZaloPayModel> apiResponse = APIResponse.fromJson(
          jsonResponse,
          (json) => ZaloPayModel.fromJson(json as Map<String, dynamic>),
        );

        log.i('Deposit coin: $jsonResponse');
        return apiResponse;
      } else if (response.statusCode == 401) {
        log.e('Token is invalid');

        return APIResponse(
          isTokenValid: false,
          message: ErrorMessage.tokenInvalid,
        );
      } else {
        log.e('Failed to deposit coin: ${response.statusCode}');
        return APIResponse(
            statusCode: response.statusCode,
            message: HttpErrorMapper.getErrorMessage(response.statusCode));
      }
    } catch (e) {
      log.e('Error during deposit coin: $e');
      return APIResponse(
        statusCode: 400,
        message: ErrorMessage.somethingWentWrong,
      );
    }
  }

  //POST: /api/deposit/vnpay/{packageId}?vnp_BankCode=INTCARD
  //Deposit money to get coin via vnp_BankCode using VnPay Payment Gateway
  Future<APIResponse<VnPayResponse>> depositCoinVnPay(
      String packageId, String vnpBankcode) async {
    try {
      token = GetLocalHelper.getBearerToken() ?? "";

      if (token == "") {
        log.e('Token is empty');
        return APIResponse(
          isTokenValid: false,
          message: ErrorMessage.tokenInvalid,
        );
      }

      final response = await http.post(
        Uri.parse('$api/vnpay/$packageId?vnp_BankCode=$vnpBankcode'),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        APIResponse<VnPayResponse> apiResponse = APIResponse.fromJson(
          jsonResponse,
          (json) => VnPayResponse.fromJson(json as Map<String, dynamic>),
        );

        log.i('Deposit coin via VnPay: $jsonResponse');
        return apiResponse;
      } else if (response.statusCode == 401) {
        log.e('Token is invalid');

        return APIResponse(
          isTokenValid: false,
          message: ErrorMessage.tokenInvalid,
        );
      } else {
        log.e('Failed to deposit coin via VnPay: ${response.statusCode}');
        return APIResponse(
            statusCode: response.statusCode,
            message: HttpErrorMapper.getErrorMessage(response.statusCode));
      }
    } catch (e) {
      log.e('Error during deposit coin via VnPay: $e');
      return APIResponse(
        statusCode: 400,
        message: ErrorMessage.somethingWentWrong,
      );
    }
  }
}
