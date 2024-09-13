import 'dart:convert';

import 'package:bai_system/api/model/bai_model/api_response.dart';
import 'package:bai_system/api/model/bai_model/coin_package_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../../core/const/frontend/error_catcher.dart';
import '../../../core/const/frontend/message.dart';
import 'api_root.dart';

class CallPackageApi {
  static const apiName = '/packages';
  final String api = APIRoot.root + apiName;

  String token = "";
  var log = Logger();

  // GET: /packages/active
  // Get all active packages
  Future<APIResponse<List<CoinPackage>>> getPackages(int pageIndex) async {
    try {
      final response = await http.get(
        Uri.parse('$api/customer?pageIndex=$pageIndex&pageSize=10'),
      );
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        log.i('Get package: $jsonResponse');
        APIResponse<List<CoinPackage>> apiResponse = APIResponse.fromJson(
          jsonResponse,
          (json) => (json as List)
              .map((item) => CoinPackage.fromJson(item as Map<String, dynamic>))
              .toList(),
        );
        return apiResponse;
      } else {
        log.e('Failed to get package: ${response.statusCode}');
        return APIResponse(
          statusCode: response.statusCode,
          message: HttpErrorMapper.getErrorMessage(response.statusCode),
        );
      }
    } catch (e) {
      log.e('Error during get package: $e');
      return APIResponse(
        statusCode: 400,
        message: ErrorMessage.somethingWentWrong,
      );
    }
  }
}
