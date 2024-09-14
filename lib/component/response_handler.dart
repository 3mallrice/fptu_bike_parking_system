import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../api/model/bai_model/api_response.dart';
import '../core/const/frontend/message.dart';
import '../core/helper/return_login_dialog.dart';

mixin class ApiResponseHandler {
  final _log = Logger();

  Future<bool> handleApiResponse<T>({
    required BuildContext context,
    required APIResponse<T> response,
    required Function(String) showErrorDialog,
  }) async {
    if (response.isTokenValid == false &&
        response.message == ErrorMessage.tokenInvalid) {
      _log.e('Token is invalid');
      if (!context.mounted) return false;
      ReturnLoginDialog.returnLogin(context);
      return false;
    }

    if (response.statusCode != 200 && response.data == null) {
      showErrorDialog(response.message ?? ErrorMessage.somethingWentWrong);
      return false;
    }

    return true;
  }
}
