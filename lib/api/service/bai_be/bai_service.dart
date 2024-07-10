import 'dart:convert';

import 'package:fptu_bike_parking_system/api/model/bai_model/api_response.dart';
import 'package:fptu_bike_parking_system/api/model/bai_model/bai_model.dart';
import 'package:fptu_bike_parking_system/core/helper/local_storage_helper.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:logger/web.dart';

class CallBikeApi {
  static const String baseUrl = 'https://backend.khangbpa.com/api';
  static const apiName = '/vehicles';
  final String api = baseUrl + apiName;

  String token = "";
  var log = Logger();

  // Post vehicle
  Future<BaiModel?> createBai(BaiModel? baiModel) async {
    try {
      if (baiModel == null) {
        log.e('Bai model is null');
        return null;
      }

      token = GetLocalHelper.getBearerToken();

      if (token.isEmpty) {
        log.e('Token is empty');
        return null;
      }

      // Tạo multipart request
      var request = http.MultipartRequest('POST', Uri.parse('$api/customer'));
      request.headers['Authorization'] = token;
      request.headers['Content-Type'] = 'multipart/form-data';

      // Thêm các trường dữ liệu vào request
      request.fields['plateNumber'] = baiModel.plateNumber!;
      request.fields['vehicleTypeId'] = baiModel.vehicleTypeId!;

      // Thêm file ảnh vào request
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      var fileStream =
          http.ByteStream(baiModel.plateImageFile!.openRead().cast());
      var length = await baiModel.plateImageFile!.length();
      var multipartFile = http.MultipartFile(
        'PlateImage',
        fileStream,
        length,
        contentType: MediaType('image', 'png'),
        filename: '$fileName.png',
      );
      request.files.add(multipartFile);

      // Gửi request và chờ response
      var response = await http.Response.fromStream(await request.send());

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
        Uri.parse('$api/type'),
      );
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse is List) {
          return jsonResponse
              .map((json) => VehicleTypeModel.fromJson(json))
              .toList();
        } else if (jsonResponse is Map) {
          // Xử lý trường hợp phản hồi là một Map
          // Giả sử các loại xe nằm trong trường 'data'
          var jsonList = jsonResponse['data'] as List;
          return jsonList
              .map((json) => VehicleTypeModel.fromJson(json))
              .toList();
        } else {
          log.e('Unexpected JSON format: $jsonResponse');
          return null;
        }
      } else {
        log.e('Failed to get vehicle types: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log.e('Error during get vehicle type: $e');
    }
    return null;
  }

  Future<List<BaiModel>?> getBai() async {
    try {
      token = GetLocalHelper.getBearerToken();

      if (token.isEmpty) {
        log.e('Token is empty');
        return null;
      }

      final response = await http.get(
        Uri.parse('$api/customer'),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        APIResponse<List<BaiModel>> apiResponse = APIResponse.fromJson(
          responseJson,
          (json) => (json as List)
              .map((item) => BaiModel.fromJson(item as Map<String, dynamic>))
              .toList(),
        );
        return apiResponse.data;
      } else {
        log.e('Failed to get vehicle: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      log.e('Error during get bai: $e');
      return null;
    }
  }
}
