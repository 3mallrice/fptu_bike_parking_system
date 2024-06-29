import 'dart:convert';

import 'package:fptu_bike_parking_system/api/model/bai_model/bai.dart';
import 'package:logger/web.dart';
import 'package:http/http.dart' as http;

class BaiApi {
  static const String baseUrl = 'https://10.0.2.2:7041/api';
  static const apiName = '/vehicles';
  final String api = baseUrl + apiName;

  String token = "";
  var log = Logger();

  //Post vehicle
  Future<BaiModel?> createBai(BaiModel? baiModel) async {
    try {
      final response = await http.post(
        Uri.parse('$api/customer'),
        headers: {'Content-Type': 'application/text'},
        body: baiModel,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return BaiModel.fromJson(jsonDecode(response.body));
      } else {
        log.e('Failed to create bai: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log.e('Error during create bai: $e');
    }
    return null;
  }

  Future<List<VehicleTypeModel>?> getVehicleType() async {
    try {
      final response = await http.get(
        Uri.parse('$api/types'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => VehicleTypeModel.fromJson(json)).toList();
      } else {
        log.e('Failed to get vehicle types: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log.e('Error during get vehicle type: $e');
    }
    return null;
  }
}
