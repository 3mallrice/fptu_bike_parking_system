import 'dart:convert';

import 'package:fptu_bike_parking_system/api/model/bai_model/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../../core/helper/local_storage_helper.dart';
import '../../model/bai_model/wallet_model.dart';

class CallWalletApi {
  static const String baseUrl = 'https://backend.khangbpa.com/api';
  static const apiName = '/wallet';
  final String api = baseUrl + apiName;

  String token = "";
  var log = Logger();

  // GET: /api/wallet/transaction/main
  // Get all transaction of user's main wallet
  Future<List<WalletModel>?> getMainWalletTransactions() async {
    try {
      token = GetLocalHelper.getBearerToken();

      if (token.isEmpty) {
        log.e('Token is empty');
        return null;
      }

      final response = await http.get(
        Uri.parse('$api/transaction/main'),
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

        return apiResponse.data;
      } else {
        log.e('Failed to get main wallet transactions: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log.e('Error during get main wallet transactions: $e');
    }
    return null;
  }

  // GET: /api/wallet/transaction/extra
  // Get all transaction of user's extra wallet
  Future<List<WalletModel>?> getExtraWalletTransactions() async {
    try {
      token = GetLocalHelper.getBearerToken();

      if (token.isEmpty) {
        log.e('Token is empty');
        return null;
      }

      final response = await http.get(
        Uri.parse('$api/transaction/extra'),
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

        return apiResponse.data;
      } else {
        log.e(
            'Failed to get extra wallet transactions: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log.e('Error during get extra wallet transactions: $e');
    }
    return null;
  }

  // GET: /api/wallet/balance/main
  // Get balance of user's main wallet
  Future<int?> getMainWalletBalance() async {
    try {
      token = GetLocalHelper.getBearerToken();

      if (token.isEmpty) {
        log.e('Token is empty');
        return null;
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

        return apiResponse.data;
      } else {
        log.e('Failed to get main wallet balance: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log.e('Error during get main wallet balance: $e');
    }
    return null;
  }

  // GET: /api/wallet/balance/extra
  // Get balance of user's extra wallet
  Future<ExtraBalanceModel?> getExtraWalletBalance() async {
    try {
      token = GetLocalHelper.getBearerToken();

      if (token.isEmpty) {
        log.e('Token is empty');
        return null;
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

        return apiResponse.data;
      } else {
        log.e('Failed to get extra wallet balance: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log.e('Error during get extra wallet balance: $e');
    }
    return null;
  }
}
