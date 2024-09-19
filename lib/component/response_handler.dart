import 'package:bai_system/component/snackbar.dart';
import 'package:bai_system/representation/login.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../api/model/bai_model/api_response.dart';
import '../core/const/frontend/message.dart';

mixin class ApiResponseHandler {
  final _log = Logger();

  static const String invalidToken = 'Token is invalid';
  static const String invalidResponse = 'Invalid response';

  Future<String?> handleApiResponse<T>({
    required BuildContext context,
    required APIResponse<T> response,
  }) async {
    if (response.isTokenValid == false &&
        response.message == ErrorMessage.tokenInvalid) {
      _log.e('Token is invalid');
      return invalidToken;
    }

    if (response.statusCode != 200 && response.data == null) {
      return response.message ?? ErrorMessage.somethingWentWrong;
    }

    return null;
  }

  Future<bool> handleApiResponseBool<T>({
    required BuildContext context,
    required APIResponse<T> response,
    required Function(String) showErrorDialog,
  }) async {
    if (response.isTokenValid == false &&
        response.message == ErrorMessage.tokenInvalid) {
      _log.e('Token is invalid');
      if (!context.mounted) return false;
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      Color background = Theme.of(context).colorScheme.surface;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: MySnackBar(
            prefix: Icon(
              Icons.cancel_rounded,
              color: background,
            ),
            message: ErrorMessage.tokenInvalid,
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          padding: const EdgeInsets.all(10),
        ),
      );
      return false;
    }

    if (response.statusCode != 200 && response.data == null) {
      showErrorDialog(response.message ?? ErrorMessage.somethingWentWrong);
      return false;
    }

    return true;
  }
}
