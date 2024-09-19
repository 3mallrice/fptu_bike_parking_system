import 'dart:convert';

import 'package:bai_system/api/model/bai_model/api_response.dart';
import 'package:bai_system/core/helper/local_storage_helper.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../../core/const/frontend/error_catcher.dart';
import '../../../core/const/frontend/message.dart';
import 'api_root.dart';

var log = Logger();

class FirebaseApi {
  static const apiName = '/notifications';
  final String api = APIRoot.root + apiName;

  String token = "";
  var log = Logger();

  // send FCM token to server
  Future<APIResponse<dynamic>> sendTokenToServer(String fcmToken) async {
    try {
      String currentEmail = LocalStorageHelper.getCurrentUserEmail() ?? "";
      token = GetLocalHelper.getBearerToken(currentEmail) ?? "";

      if (token == "") {
        log.e('Token is empty');
        return APIResponse(
          message: 'Token is empty',
          isTokenValid: false,
        );
      }

      final response = await http.put(
        Uri.parse('$api/customer/$fcmToken'),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        APIResponse<bool> apiResponse = APIResponse.fromJson(
          responseJson,
          (json) => true,
        );
        return apiResponse;
      } else {
        log.e('Failed to put customer fcm token: ${response.statusCode}');
        return APIResponse(
          statusCode: response.statusCode,
          message: HttpErrorMapper.getErrorMessage(response.statusCode),
        );
      }
    } catch (e) {
      log.e('Error during put customer fcm token: $e');
      return APIResponse(
        statusCode: 400,
        message: ErrorMessage.somethingWentWrong,
      );
    }
  }
}
