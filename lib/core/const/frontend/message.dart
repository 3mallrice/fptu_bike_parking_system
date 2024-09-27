import 'package:bai_system/core/const/utilities/util_helper.dart';

import '../../../api/model/bai_model/coin_package_model.dart';

class Message {
  static String saveImageSuccessfully = "Image saved successfully!";
  static String saveImageUnSuccessfully = "Saved unsuccessfully!";
  static String permissionDeny = "Permission denied";

  static String permissionDenyMessage({required String message}) =>
      "Permission denied! Only $message with an active status can perform this action";
  static String loginSuccess = "Login success, welcome back!";

  static String actionSuccessfully({String? action}) => "$action successfully!";
  static String enableLocationService =
      "Enable location permission\nto get weather information!";
  static String copyToClipboard = "Copied to clipboard!";

  static String deleteConfirmation({String? message}) =>
      "Are you sure you want to delete $message?";
  static String confirmTitle = "Are you sure?";

  static String editConfirmation = "Are you sure you want to save changes?";

  static deleteSuccess({required String message}) =>
      "Delete $message successfully!";

  static editSuccess({required String message}) =>
      "Edit $message successfully!";

  static editUnSuccess({required String message}) => "Edit $message failed!";

  static deleteUnSuccess({required String message}) =>
      "Delete $message failed!";

  static String noMore({required String message}) =>
      "No more $message to load!";
}

class ListName {
  static String bai = "Bai";
  static String package = "Package";
  static String vehicleType = "Vehicle Type";
  static String plateNumber = "Plate Number";
  static String vehicle = "Vehicle";
  static String transaction = "Transaction";
  static String history = "History";
  static String feedback = "Feedback";
  static String profile = "Profile";
}

class LabelMessage {
  static String ok = "OK";

  static String add({String? message}) =>
      "Add ${message != null ? message.toLowerCase() : ""}";
  static String save = "Save";
  static String share = "Share";
  static String cancel = "Cancel";
  static String confirm = "Confirm";
  static String delete = "Delete";
  static String edit = "Edit";
  static String yes = "Yes";
  static String no = "No";
  static String close = "Close";
  static String done = "Done";
  static String checkout = "Check out";
  static String pay = "Pay";
}

class ErrorMessage {
  static String error = "Got an error!";
  static String somethingWentWrong =
      "Something went wrong, please try again later!";
  static String errorWhileLoading =
      "Error while loading, please try again later!";
  static String loginFailed = "Login failed, please try again!";
  static String imageNotFound = "Image not found";

  static String inputRequired({String? message}) =>
      "Action Failed! Please input all fields for ${message?.toLowerCase()}";

  static String inputInvalid({String? message}) =>
      "Action Failed! Please input valid fields for ${message?.toLowerCase()}";

  static String underDevelopment = "This feature is under development!";
  static String tokenInvalid = "Token is invalid!";
  static String paymentMethod = "Please select a payment method!";

  static String notFound({String? message}) =>
      "$message not found! Please contact the administrator.";
  static String tokenIsExpired =
      "Oops! Your session has expired. Please login again!";
}

class ImageName {
  static String imageName({String? prefix}) =>
      "${prefix ?? "image"}_${DateTime.now().millisecondsSinceEpoch}";
}

class EmptyBoxMessage {
  static String emptyListWithAction({required String label}) {
    return "Oops! Looks like there are no ${label.toLowerCase()} in the list. Please add some!";
  }

  static String emptyList({required String label}) {
    return "Oops! Looks like there are no ${label.toLowerCase()} in the list.";
  }

  static String empty = "Oops! Looks like there are no data in the list.";
}

class ZaloPayMessage {
  static const String openApp = "Open ZaloPay";
  static const String cancelled = "Payment has been cancelled";
  static const String success = "Payment was successful";
  static const String failed = "Payment failed. Please try again";
  static const String processing = "Payment is processing...";
}

String packageDetail(CoinPackage package) {
  List<String> details = [];

  details.add('If you purchase the ${package.packageName}, you will get:');
  details.add(
      '\u2022 ${UltilHelper.formatMoney(int.parse(package.amount))} bic (Main Wallet).');

  if (package.extraCoin != null) {
    details.add(
        '\u2022 ${UltilHelper.formatMoney(package.extraCoin!)} Extra bic (Extra Wallet).');
  }

  if (package.extraEXP != null && package.extraEXP! > 0) {
    details.add(
        '\u2022 Your Extra Wallet\'s expiration period will increase by ${UltilHelper.formatMoney(package.extraEXP!)} days.');
  }

  details.add('\nKeep in mind:');
  details.add(
      'Each purchase extends the expiration of all your extra coins by the specified days, giving you more flexibility to use them.');

  return details.join('\n');
}
