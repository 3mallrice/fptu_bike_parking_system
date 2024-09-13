import 'dart:convert';

import 'package:bai_system/api/model/bai_model/feedback_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../../core/const/frontend/error_catcher.dart';
import '../../../core/const/frontend/message.dart';
import '../../../core/helper/local_storage_helper.dart';
import '../../model/bai_model/api_response.dart';
import 'api_root.dart';

class FeedbackApi {
  static const apiName = '/feedbacks/customers';
  final String api = APIRoot.root + apiName;

  String token = "";
  var log = Logger();

  // POST: /api/feedbacks/customers
  // Send feedback to Bai Be
  Future<APIResponse> sendFeedback(SendFeedbackModel sendFeedback) async {
    try {
      token = GetLocalHelper.getBearerToken() ?? "";

      if (token == "") {
        log.e('Token is empty');
        return APIResponse(
          message: ErrorMessage.tokenInvalid,
          isTokenValid: false,
        );
      }

      final response = await http.post(
        Uri.parse(api),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(sendFeedback.toJson()),
      );

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);

        APIResponse apiResponse = APIResponse.fromJson(responseJson, (json) {
          return json;
        });

        return apiResponse;
      } else {
        log.e(
            'Failed to send feedback: ${response.statusCode} ${response.body}');
        return APIResponse(
            statusCode: response.statusCode,
            message: HttpErrorMapper.getErrorMessage(response.statusCode));
      }
    } catch (e) {
      log.e('Error during send feedback: $e');
      return APIResponse(
        statusCode: 400,
        message: ErrorMessage.somethingWentWrong,
      );
    }
  }

  // GET: /api/feedbacks/customers
  // Get feedbacks of Bai Be
  Future<APIResponse<List<FeedbackModel>>> getFeedbacks(
      int pageIndex, int pageSize) async {
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
        Uri.parse('$api?pageIndex=$pageIndex&pageSize=$pageSize'),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);

        APIResponse<List<FeedbackModel>> apiResponse = APIResponse.fromJson(
            responseJson,
            (json) => (json as List)
                .map((item) =>
                    FeedbackModel.fromJson(item as Map<String, dynamic>))
                .toList());
        return apiResponse;
      } else {
        log.e(
            'Failed to get feedbacks list: ${response.statusCode} ${response.body}');
        return APIResponse(
          statusCode: response.statusCode,
          message: HttpErrorMapper.getErrorMessage(response.statusCode),
        );
      }
    } catch (e) {
      log.e('Error during get feedback: $e');
      return APIResponse(
        statusCode: 400,
        message: ErrorMessage.somethingWentWrong,
      );
    }
  }
}
