import 'dart:convert';

import 'package:bai_system/api/service/bai_be/api_root.dart';
import 'package:bai_system/core/const/frontend/error_catcher.dart';
import 'package:bai_system/core/const/frontend/message.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../../core/helper/local_storage_helper.dart';
import '../../model/bai_model/api_response.dart';
import '../../model/bai_model/login_model.dart';

class CallAuthApi {
  static const apiName = '/auth';
  final String api = APIRoot.root + apiName;

  String token = "";
  var log = Logger();

  //Login with google
  Future<APIResponse<UserData>> loginWithGoogle(String idToken) async {
    try {
      final response = await http.post(
        Uri.parse('$api/google?idToken=$idToken'),
        headers: {'Content-Type': 'application/text'},
      );

      final apiResponseJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        APIResponse<UserData> apiResponse = APIResponse<UserData>.fromJson(
            apiResponseJson,
            (json) => UserData.fromJson(json as Map<String, dynamic>));
        if (apiResponse.data != null) {
          // Save userDate{token, ...} to shared preferences
          LocalStorageHelper.setValue(
              LocalStorageKey.userData, apiResponseJson['data']);
          log.i('Login success');
        } else {
          log.e('Login failed. ${apiResponse.message}');
        }
        return apiResponse;
      } else {
        log.e(
            'Failed to login.\nStatus code: ${response.statusCode}\n Message: ${apiResponseJson['message']}');
        return APIResponse(
          statusCode: response.statusCode,
          message: HttpErrorMapper.getErrorMessage(response.statusCode),
        );
      }
    } catch (e) {
      log.e('Error during login: $e');
      return APIResponse(
        statusCode: 400,
        message: ErrorMessage.somethingWentWrong,
      );
    }
  }
}
