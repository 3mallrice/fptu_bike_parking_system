import 'dart:convert';
import 'dart:io';

import 'package:bai_system/api/model/bai_model/api_response.dart';
import 'package:bai_system/api/model/bai_model/bai_model.dart';
import 'package:bai_system/core/helper/local_storage_helper.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:logger/web.dart';
import 'package:mime/mime.dart';

import '../../../core/const/frontend/message.dart';
import 'api_root.dart';

class CallBikeApi {
  static const apiName = '/vehicles';
  final String api = APIRoot.root + apiName;
  final String detectUrl = 'https://platenumber.khangbpa.com';

  String token = "";
  var log = Logger();

  // Post vehicle
  Future<APIResponse<AddBaiRespModel>> createBai(
      AddBaiModel? addBaiModel) async {
    try {
      if (addBaiModel == null) {
        log.e('Bai model is null');
        return APIResponse(message: 'Bai model is null');
      }

      token = GetLocalHelper.getBearerToken() ?? "";

      if (token.isEmpty) {
        log.e('Token is empty');
        return APIResponse(
          message: ErrorMessage.tokenInvalid,
          isTokenValid: false,
        );
      }

      var request = http.MultipartRequest('POST', Uri.parse('$api/customer'));
      request.headers['Authorization'] = token;

      // Thêm các trường dữ liệu vào request
      request.fields['PlateNumber'] = addBaiModel.plateNumber;
      request.fields['VehicleTypeId'] = addBaiModel.vehicleTypeId;

      // Thêm file ảnh vào request
      var fileStream =
          http.ByteStream(addBaiModel.plateImage.openRead().cast());
      var length = await addBaiModel.plateImage.length();

      // Xác định MIME type của ảnh
      final mimeType =
          lookupMimeType(addBaiModel.plateImage.path) ?? 'image/jpeg';
      final mediaType = MediaType.parse(mimeType);

      var multipartFile = http.MultipartFile(
        'PlateImage',
        fileStream,
        length,
        contentType: mediaType,
        filename: addBaiModel.plateImage.path.split('/').last,
      );
      request.files.add(multipartFile);

      var response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseJson = jsonDecode(response.body);
        return APIResponse.fromJson(
          responseJson,
          (json) => AddBaiRespModel.fromJson(json as Map<String, dynamic>),
        );
      } else {
        log.e('Failed to create bai: ${response.statusCode}');
        return APIResponse(
          message: "${ErrorMessage.somethingWentWrong}: ${response.statusCode}",
        );
      }
    } catch (e) {
      log.e('Error during create bai: $e');
      return APIResponse(message: "${ErrorMessage.somethingWentWrong}: $e");
    }
  }

  Future<List<VehicleTypeModel>> getVehicleType() async {
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
          var jsonList = jsonResponse['data'] as List;
          return jsonList
              .map((json) => VehicleTypeModel.fromJson(json))
              .toList();
        } else {
          log.e('Unexpected JSON format: $jsonResponse');
          return [];
        }
      } else {
        log.e('Failed to get vehicle types: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      log.e('Error during get vehicle type: $e');
    }
    return [];
  }

  Future<APIResponse<List<BaiModel>>> getBai() async {
    try {
      token = GetLocalHelper.getBearerToken() ?? "";

      if (token == "") {
        log.e('Token is empty');
        return APIResponse(
          message: ErrorMessage.tokenInvalid,
          isTokenValid: false,
        );
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
        return apiResponse;
      } else {
        log.e('Failed to get vehicle: ${response.statusCode} ${response.body}');
        return APIResponse(
          message: "${ErrorMessage.somethingWentWrong}: ${response.statusCode}",
        );
      }
    } catch (e) {
      log.e('Error during get bai: $e');
      return APIResponse(message: "${ErrorMessage.somethingWentWrong}: $e");
    }
  }

  //POST: platenumber.khangbpa.com/detect_read
  //'Content-Type: multipart/form-data'
  // detect plate number
  Future<PlateNumberResponse?> detectPlateNumber(File imageFile) async {
    final url = Uri.parse('$detectUrl/detect_read');

    // Xác định MIME type của ảnh
    final mimeType = lookupMimeType(imageFile.path);
    final mediaType = mimeType != null
        ? MediaType.parse(mimeType)
        : MediaType('application', 'octet-stream');

    final request = http.MultipartRequest('POST', url)
      ..headers['accept'] = '*/*'
      ..files.add(await http.MultipartFile.fromPath(
        'PlateImage',
        imageFile.path,
        contentType: mediaType,
      ));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        PlateNumberResponse plateNumberResponse =
            PlateNumberResponse.fromJson(jsonDecode(responseBody));

        log.i('Success: $plateNumberResponse');
        return plateNumberResponse;
      } else {
        log.e('Failed to detect plate number: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log.e('Error during POST request: $e');
      return null;
    }
  }

  //DELETE: /vehicles/customer/{id}
  // Delete vehicle
  Future<APIResponse<int>> deleteBai(String id) async {
    try {
      token = GetLocalHelper.getBearerToken() ?? "";
      if (token == "") {
        log.e('Token is empty');
        return APIResponse(
          message: ErrorMessage.tokenInvalid,
          isTokenValid: false,
        );
      }
      final response = await http.delete(
        Uri.parse('$api/customer/$id'),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return APIResponse(
          data: response.statusCode,
          message: Message.deleteSuccess(message: ListName.vehicle),
        );
      }

      final errorMessage = response.statusCode == 404
          ? ErrorMessage.notFound(message: ListName.vehicle)
          : "${ErrorMessage.somethingWentWrong}: ${response.statusCode}";

      log.e('Failed to delete vehicle: ${response.statusCode}');
      return APIResponse(
        data: response.statusCode,
        message: errorMessage,
      );
    } catch (e) {
      log.e('Error during delete bai: $e');
      return APIResponse(message: "${ErrorMessage.somethingWentWrong}: $e");
    }
  }

  // PUT: /vehicles/customer
  // Update vehicle
  Future<APIResponse<int>> updateBai(UpdateBaiModel updateBaiModel) async {
    try {
      token = GetLocalHelper.getBearerToken() ?? "";
      if (token == "") {
        log.e('Token is empty');
        return APIResponse(
          message: ErrorMessage.tokenInvalid,
          isTokenValid: false,
        );
      }
      final response = await http.put(
        Uri.parse('$api/customer'),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updateBaiModel.toJson()),
      );

      if (response.statusCode == 200) {
        return APIResponse(
          data: response.statusCode,
          message: Message.deleteSuccess(message: ListName.vehicle),
        );
      }

      final errorMessage = response.statusCode == 404
          ? ErrorMessage.notFound(message: ListName.vehicle)
          : "${ErrorMessage.somethingWentWrong}: ${response.statusCode}";

      log.e('Failed to delete vehicle: ${response.statusCode}');
      return APIResponse(
        data: response.statusCode,
        message: errorMessage,
      );
    } catch (e) {
      log.e('Error during delete bai: $e');
      return APIResponse(message: "${ErrorMessage.somethingWentWrong}: $e");
    }
  }

  //GET: /vehicles/customer/{id}
  // Get vehicle by id
  Future<APIResponse<BaiModel>> getCustomerBaiById(String id) async {
    try {
      token = GetLocalHelper.getBearerToken() ?? "";
      if (token == "") {
        log.e('Token is empty');
        return APIResponse(
          message: ErrorMessage.tokenInvalid,
          isTokenValid: false,
        );
      }

      final response = await http.get(
        Uri.parse('$api/customer/$id'),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        BaiModel baiModel =
            BaiModel.fromJson(responseJson['data'] as Map<String, dynamic>);
        return APIResponse<BaiModel>(
          data: baiModel,
          message: responseJson['message'] ?? 'Success',
        );
      } else {
        log.e(
            'Failed to get vehicle by ID: ${response.statusCode} ${response.body}');
        return APIResponse(
          message: "${ErrorMessage.somethingWentWrong}: ${response.statusCode}",
        );
      }
    } catch (e) {
      log.e('Error during get vehicle by ID: $e');
      return APIResponse(message: "${ErrorMessage.somethingWentWrong}: $e");
    }
  }
}
