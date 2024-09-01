import 'dart:convert';

import 'package:bai_system/api/model/bai_model/api_response.dart';
import 'package:bai_system/api/model/bai_model/zalopay_model.dart';
import 'package:bai_system/core/const/frontend/message.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../../core/helper/local_storage_helper.dart';
import 'api_root.dart';

class CallPaymentApi {
  static const String baseUrl = APIRoot.root;

  // static const apiName = '/deposit';
  // final String api = baseUrl + apiName;

  String token = "";
  var log = Logger();

  //POST: /api/deposit/{packageId}
  //Deposit money to get coin via ZaloPay
  Future<APIResponse<ZaloPayModel>> depositCoin(String packageId) async {
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
        Uri.parse('$baseUrl/deposit/zalopay/$packageId'),
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
            message:
                "${ErrorMessage.somethingWentWrong}: Status code ${response.statusCode}");
      }
    } catch (e) {
      log.e('Error during deposit coin: $e');
      return APIResponse(message: "${ErrorMessage.somethingWentWrong}: $e");
    }
  }
}
