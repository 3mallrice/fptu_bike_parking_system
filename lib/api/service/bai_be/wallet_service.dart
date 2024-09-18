import 'dart:convert';

import 'package:bai_system/api/model/bai_model/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../../core/const/frontend/error_catcher.dart';
import '../../../core/const/frontend/message.dart';
import '../../../core/helper/local_storage_helper.dart';
import '../../model/bai_model/wallet_model.dart';
import 'api_root.dart';

class CallWalletApi {
  static const apiName = '/wallet';
  final String api = APIRoot.root + apiName;

  String token = "";
  var log = Logger();

  // GET: /api/wallet/transaction/main
  // Get all transaction of user's main wallet
  Future<APIResponse<List<WalletModel>>> getMainWalletTransactions(
      int pageIndex,
      int pageSize,
      DateTime? startDate,
      DateTime? endDate) async {
    try {
      String currentEmail = LocalStorageHelper.getCurrentUserEmail() ?? "";
      token = GetLocalHelper.getBearerToken(currentEmail) ?? "";

      if (token == "") {
        log.e('Token is empty');
        return APIResponse(
          message: ErrorMessage.tokenInvalid,
          isTokenValid: false,
        );
      }

      final response = await http.get(
        Uri.parse(
            '$api/transaction/main?pageIndex=$pageIndex&pageSize=$pageSize&StartDate=${startDate ?? ''}&EndDate=${endDate ?? ''}'),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);

        APIResponse<List<WalletModel>> apiResponse = APIResponse.fromJson(
          responseJson,
          (json) => (json as List)
              .map((item) => WalletModel.fromJson(item as Map<String, dynamic>))
              .toList(),
        );

        return apiResponse;
      } else {
        log.e('Failed to get main wallet transactions: ${response.statusCode}');
        return APIResponse(
            statusCode: response.statusCode,
            message: HttpErrorMapper.getErrorMessage(response.statusCode));
      }
    } catch (e) {
      log.e('Error during get main wallet transactions: $e');
      return APIResponse(
        statusCode: 400,
        message: ErrorMessage.somethingWentWrong,
      );
    }
  }

  // GET: /api/wallet/transaction/extra
  // Get all transaction of user's extra wallet
  Future<APIResponse<List<WalletModel>>> getExtraWalletTransactions(
      int pageIndex,
      int pageSize,
      DateTime? startDate,
      DateTime? endDate) async {
    try {
      String currentEmail = LocalStorageHelper.getCurrentUserEmail() ?? "";
      token = GetLocalHelper.getBearerToken(currentEmail) ?? "";

      if (token == "") {
        log.e('Token is empty');
        return APIResponse(
          message: ErrorMessage.tokenInvalid,
          isTokenValid: false,
        );
      }

      final response = await http.get(
        Uri.parse(
            '$api/transaction/extra?pageIndex=$pageIndex&pageSize=$pageSize&StartDate=${startDate ?? ''}&EndDate=${endDate ?? ''}'),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);

        APIResponse<List<WalletModel>> apiResponse = APIResponse.fromJson(
          responseJson,
          (json) => (json as List)
              .map((item) => WalletModel.fromJson(item as Map<String, dynamic>))
              .toList(),
        );

        return apiResponse;
      } else {
        log.e(
            'Failed to get extra wallet transactions: ${response.statusCode}');
        return APIResponse(
            statusCode: response.statusCode,
            message: HttpErrorMapper.getErrorMessage(response.statusCode));
      }
    } catch (e) {
      log.e('Error during get extra wallet transactions: $e');
      return APIResponse(
        statusCode: 400,
        message: ErrorMessage.somethingWentWrong,
      );
    }
  }

  // GET: /api/wallet/balance/main
  // Get balance of user's main wallet
  Future<APIResponse<int>> getMainWalletBalance() async {
    try {
      String currentEmail = LocalStorageHelper.getCurrentUserEmail() ?? "";
      token = GetLocalHelper.getBearerToken(currentEmail) ?? "";

      if (token == "") {
        log.e('Token is empty');
        return APIResponse<int>(
          message: ErrorMessage.tokenInvalid,
          isTokenValid: false,
        );
      }

      final response = await http.get(
        Uri.parse('$api/balance/main'),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        APIResponse<int> apiResponse = APIResponse.fromJson(
          responseJson,
          (json) => int.parse(json.toString()),
        );

        return apiResponse;
      } else if (response.statusCode == 401) {
        return APIResponse(
          message: ErrorMessage.tokenInvalid,
          isTokenValid: false,
        );
      } else {
        log.e('Failed to get main wallet balance: ${response.statusCode}');
        return APIResponse(
            statusCode: response.statusCode,
            message: HttpErrorMapper.getErrorMessage(response.statusCode));
      }
    } catch (e) {
      log.e('Error during get main wallet balance: $e');

      return APIResponse(
        statusCode: 400,
        message: ErrorMessage.somethingWentWrong,
      );
    }
  }

  // GET: /api/wallet/balance/extra
  // Get balance of user's extra wallet
  Future<APIResponse<ExtraBalanceModel>> getExtraWalletBalance() async {
    try {
      String currentEmail = LocalStorageHelper.getCurrentUserEmail() ?? "";
      token = GetLocalHelper.getBearerToken(currentEmail) ?? "";

      if (token == "") {
        log.e('Token is empty');
        return APIResponse<ExtraBalanceModel>(
          message: ErrorMessage.tokenInvalid,
          isTokenValid: false,
        );
      }

      final response = await http.get(
        Uri.parse('$api/balance/extra'),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        APIResponse<ExtraBalanceModel> apiResponse = APIResponse.fromJson(
          responseJson,
          (json) => ExtraBalanceModel.fromJson(json as Map<String, dynamic>),
        );

        return apiResponse;
      } else {
        log.e('Failed to get extra wallet balance: ${response.statusCode}');
        return APIResponse(
            statusCode: response.statusCode,
            message: HttpErrorMapper.getErrorMessage(response.statusCode));
      }
    } catch (e) {
      log.e('Error during get extra wallet balance: $e');
      return APIResponse(
        statusCode: 400,
        message: ErrorMessage.somethingWentWrong,
      );
    }
  }
}
