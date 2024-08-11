import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../../core/const/frondend/message.dart';
import '../../../core/helper/local_storage_helper.dart';
import '../../model/bai_model/api_response.dart';
import '../../model/bai_model/statistic.dart';
import 'api_root.dart';

class StatisticApi {
  static const apiName = '/statistic/customer';
  final String api = APIRoot.root + apiName;

  String token = "";
  var log = Logger();

  // GET: /api/statistic/customer/park
  // How did you park in last 30 days
  Future<APIResponse<List<HowDidYouParkAndSpend>>> getHowDidYouPark() async {
    try {
      token = GetLocalHelper.getBearerToken() ?? "";

      if (token == "") {
        log.e('Token is empty');
        return APIResponse(
          message: ErrorMessage.tokenInvalid,
          isTokenValid: false,
        );
      }

      final response = await http.get(
        Uri.parse('$api/park'),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);

        APIResponse<List<HowDidYouParkAndSpend>> apiResponse =
            APIResponse.fromJson(
          responseJson,
          (json) => (json as List)
              .map((item) =>
                  HowDidYouParkAndSpend.fromJson(item as Map<String, dynamic>))
              .toList(),
        );

        return apiResponse;
      } else {
        log.e(
            'Failed to get how did you park in last 30 days: ${response.statusCode}');
        return APIResponse(
            message:
                "${ErrorMessage.somethingWentWrong}: Status code ${response.statusCode}");
      }
    } catch (e) {
      log.e('Error during get how did you park in last 30 days: $e');
      return APIResponse(message: "${ErrorMessage.somethingWentWrong}: $e");
    }
  }

  // GET: /api/statistic/customer/payment/method
  // How did you pay in this month
  Future<APIResponse<List<PaymentMethodUsage>>> getHowDidYouPay() async {
    try {
      token = GetLocalHelper.getBearerToken() ?? "";

      if (token == "") {
        log.e('Token is empty');
        return APIResponse(
          message: ErrorMessage.tokenInvalid,
          isTokenValid: false,
        );
      }

      final response = await http.get(
        Uri.parse('$api/payment/method'),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);

        APIResponse<List<PaymentMethodUsage>> apiResponse =
            APIResponse.fromJson(
          responseJson,
          (json) => (json as List)
              .map((item) =>
                  PaymentMethodUsage.fromJson(item as Map<String, dynamic>))
              .toList(),
        );

        return apiResponse;
      } else {
        log.e(
            'Failed to get how did you pay in this month: ${response.statusCode}');
        return APIResponse(
            message:
                "${ErrorMessage.somethingWentWrong}: Status code ${response.statusCode}");
      }
    } catch (e) {
      log.e('Error during get how did you pay in this month: $e');
      return APIResponse(message: "${ErrorMessage.somethingWentWrong}: $e");
    }
  }
}
