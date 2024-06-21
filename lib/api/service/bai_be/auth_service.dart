import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../../core/helper/local_storage_helper.dart';
import '../../model/bai_model/api_response.dart';
import '../../model/bai_model/login_model.dart';

class CallAuthApi {
  static const String baseUrl = 'https://10.0.2.2:7041/api';
  static const apiName = '/auth';
  final String api = baseUrl + apiName;

  String token = "";
  var log = Logger();

  //Login with google
  Future<UserData?> loginWithGoogle(String idToken) async {
    try {
      final response = await http.post(
        Uri.parse('$api/google?idToken=$idToken'),
        headers: {'Content-Type': 'application/text'},
      );

      final apiResponseJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        APIResponse<UserData> apiResponse = APIResponse<UserData>.fromJson(
          apiResponseJson,
          (json) => UserData.fromJson(json as Map<String, dynamic>),
        );
        if (apiResponse.data != null) {
          // Save userDate{token, ...} to shared preferences
          LocalStorageHelper.setValue("userData", apiResponseJson['data']);
          log.i('Login success');
        } else {
          log.e('Login failed. ${apiResponse.message}');
        }
        return apiResponse.data;
      } else {
        log.e(
            'Failed to login.\nStatus code: ${response.statusCode}\n Message: ${apiResponseJson['message']}');
      }
    } catch (e) {
      log.e('Error during login: $e');
    }
    return null;
  }
}
