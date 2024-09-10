import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bai_system/api/service/bai_be/api_root.dart';
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

  Future<UserData?> loginWithGoogle(String idToken) async {
    try {
      final response = await http.post(
        Uri.parse('$api/google?idToken=$idToken'),
        headers: {'Content-Type': 'application/text'},
      ).timeout(const Duration(seconds: 30)); // Add timeout

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          log.e('Response body is empty');
          return null;
        }

        final apiResponseJson = jsonDecode(response.body) as Map<String, dynamic>;

        APIResponse<UserData> apiResponse = APIResponse<UserData>.fromJson(
          apiResponseJson,
              (json) => UserData.fromJson(json as Map<String, dynamic>),
        );

        if (apiResponse.data != null) {
          // Save userData{token, ...} to shared preferences
          await LocalStorageHelper.setValue(
              LocalStorageKey.userData, apiResponseJson['data']);
          log.i('Login success');
          return apiResponse.data;
        } else {
          log.e('Login failed. ${apiResponse.message}');
        }
      } else {
        final apiResponseJson = jsonDecode(response.body) as Map<String, dynamic>;
        log.e(
            'Failed to login.\nStatus code: ${response.statusCode}\nMessage: ${apiResponseJson['message']}');
      }
    } on SocketException catch (e) {
      log.e('Network error: $e');
    } on TimeoutException catch (e) {
      log.e('Request timed out: $e');
    } on FormatException catch (e) {
      log.e('Error parsing response: $e');
    } catch (e) {
      log.e('Unexpected error during login: $e');
    }
    return null;
  }
}