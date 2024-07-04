import 'dart:convert';

import 'package:fptu_bike_parking_system/api/model/bai_model/bai_model.dart';
import 'package:fptu_bike_parking_system/api/model/bai_model/login_model.dart';
import 'package:fptu_bike_parking_system/core/helper/local_storage_helper.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:logger/web.dart';

class CallBikeApi {
  static const String baseUrl = 'https://10.0.2.2:7041/api';
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

      UserData userData = UserData.fromJson(
          LocalStorageHelper.getValue(LocalStorageKey.userData));
      token = 'Bearer ${userData.bearerToken ?? ""}';

      // Tạo multipart request
      var request = http.MultipartRequest('POST', Uri.parse('$api/customer'));
      request.headers['Authorization'] = token;
      request.headers['Content-Type'] = 'multipart/form-data';

      // Thêm các trường dữ liệu vào request
      request.fields['plateNumber'] = baiModel.plateNumber!;
      request.fields['vehicleTypeId'] = baiModel.vehicleTypeId!;

      // Thêm file ảnh vào request
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      var fileStream = http.ByteStream(baiModel.plateImage!.openRead().cast());
      var length = await baiModel.plateImage!.length();
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
        headers: {'Authorization': 'Bearer $token'},
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
}
