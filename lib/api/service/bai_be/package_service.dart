import 'dart:convert';

import 'package:fptu_bike_parking_system/api/model/bai_model/package_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class CallPackageApi {
  static const String baseUrl = 'https://backend.khangbpa.com/api';
  static const apiName = '/packages';
  final String api = baseUrl + apiName;

  String token = "";
  var log = Logger();

  Future<List<PackageModel>?> getPackages() async {
    try {
      final response = await http.get(
        Uri.parse(api),
      );
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse is List) {
          return jsonResponse
              .map((json) => PackageModel.fromJson(json))
              .toList();
        } else if (jsonResponse is Map) {
          var jsonList = jsonResponse['data'] as List;
          return jsonList.map((json) => PackageModel.fromJson(json)).toList();
        } else {
          log.e('Unexpected JSON format: $jsonResponse');
          return null;
        }
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
