import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../../core/const/frontend/message.dart';
import '../../../core/helper/local_storage_helper.dart';
import '../../model/bai_model/api_response.dart';
import 'api_root.dart';

class CallCustomerApi {
  static const apiName = '/customers';
  final String api = APIRoot.root + apiName;

  String token = "";
  var log = Logger();

  // PUT: /api/customer
  // Update customer information
  Future<APIResponse<bool>> updateCustomerInfo(String customerName) async {
    try {
      token = GetLocalHelper.getBearerToken() ?? "";

      if (token.isEmpty) {
        log.e('Token is empty');
        return APIResponse(
          message: ErrorMessage.tokenInvalid,
          isTokenValid: false,
        );
      }

      final response = await http.put(
        Uri.parse(api),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'fullName': customerName}),
      );

      final apiResponseJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        APIResponse<bool> apiResponse = APIResponse<bool>.fromJson(
          apiResponseJson,
          (json) => json as bool,
        );

        log.d('Customer information: ${GetLocalHelper.getUserData()}');
        return apiResponse;
      } else {
        log.e(
            'Failed to updateCustomerInfo.\nStatus code: ${response.statusCode}\n Message: ${apiResponseJson['message']}');
        return APIResponse(
          message: apiResponseJson['message'],
        );
      }
    } catch (e) {
      log.e('Error during updateCustomerInfo: $e');
      return APIResponse(
        message: ErrorMessage.somethingWentWrong,
      );
    }
  }
}