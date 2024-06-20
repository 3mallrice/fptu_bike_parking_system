import 'dart:convert';
import 'package:fptu_bike_parking_system/core/helper/local_storage_helper.dart';
import 'package:http/http.dart' as http;

import 'package:logger/logger.dart';

import '../../model/bai_model/api_response.dart';
import '../../model/bai_model/login_model.dart';

class CallAuthApi {
  static const String baseUrl = 'https://10.0.2.2:7041/api';
  static const apiName = '/auth';
  final String api = baseUrl + apiName;

  String token = "";
  var log = Logger();

  //Login with google
  Future<void> loginWithGoogle(String idToken) async {
    try {
      final response = await http.post(
        Uri.parse('$api/google?idToken=$idToken'),
        headers: {'Content-Type': 'application/text'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        APIResponse<UserData> apiResponse = APIResponse<UserData>.fromJson(
          jsonResponse,
          (json) => UserData.fromJson(json as Map<String, dynamic>),
        );

        if (apiResponse.data != null) {
          token = apiResponse.data?.bearerToken ?? "";
          LocalStorageHelper.setValue('token', token);

          //save the user data in json format
          LocalStorageHelper.setValue('user', jsonResponse['data']);
          log.i('Login successful. Token: $token');
          log.i('User data: ${jsonResponse['data']}');
        } else {
          log.e('Login failed: ${apiResponse.message}');
        }
      } else {
        log.e('Failed to login. Status code: ${response.statusCode}');
      }
    } catch (e) {
      log.e('Error during login: $e');
    }
  }
}
