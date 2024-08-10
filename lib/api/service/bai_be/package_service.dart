import 'dart:convert';

import 'package:fptu_bike_parking_system/api/model/bai_model/api_response.dart';
import 'package:fptu_bike_parking_system/api/model/bai_model/coin_package_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'api_root.dart';

class CallPackageApi {
  static const apiName = '/packages';
  final String api = APIRoot.root + apiName;

  String token = "";
  var log = Logger();

  // GET: /packages/active
  // Get all active packages
  Future<List<CoinPackage>?> getPackages() async {
    try {
      final response = await http.get(
        Uri.parse('$api/customer'),
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
        return apiResponse.data;
      } else {
        log.e('Failed to get package: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log.e('Error during get package: $e');
    }
    return null;
  }
}
