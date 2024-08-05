import 'dart:convert';

import 'package:fptu_bike_parking_system/api/model/bai_model/api_response.dart';
import 'package:fptu_bike_parking_system/api/model/bai_model/zalopay_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../../core/helper/local_storage_helper.dart';

class CallPaymentApi {
  static const String baseUrl = 'https://backend.khangbpa.com/api';

  // static const apiName = '/deposit';
  // final String api = baseUrl + apiName;

  String token = "";
  var log = Logger();

  //POST: /api/deposit/{packageId}
  //Deposit money to get coin via ZaloPay
  Future<ZaloPayModel?> depositCoin(String packageId) async {
    try {
      token = GetLocalHelper.getBearerToken();

      if (token.isEmpty) {
        log.e('Token is empty');
        return null;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/deposit/$packageId'),
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
        return apiResponse.data;
      } else {
        log.e('Failed to deposit coin: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log.e('Error during deposit coin: $e');
    }
    return null;
  }

  //POST: /callback
  //Callback from ZaloPay to open ZaloPay app
  Future<bool> callbackZaloPay() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/callback'),
      );
      if (response.statusCode == 200) {
        log.i('Callback ZaloPay: ${response.body}');
        return true;
      } else {
        log.e('Failed to callback ZaloPay: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log.e('Error during callback ZaloPay: $e');
    }
    return false;
  }
}
