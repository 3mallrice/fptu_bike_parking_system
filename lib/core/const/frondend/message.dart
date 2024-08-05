class Message {
  static String saveImageSuccessfully = "Image saved successfully!";
  static String saveImageUnSuccessfully = "Saved unsuccessfully!";
  static String permissionDeny = "Permission denied!";
  static String loginSuccess = "Login success, welcome back!";

  static String actionSuccessfully({String? action}) => "$action successfully!";
}

class ListName {
  static String bai = "Bai";
  static String vehicleType = "Vehicle Type";
  static String plateNumber = "Plate Number";
  static String vehicle = "Vehicle";
}

class LabelMessage {
  static String ok = "OK";

  static String add({String? message}) => "Add ${message ?? ""}";
  static String save = "Save";
  static String cancel = "Cancel";
  static String confirm = "Confirm";
  static String delete = "Delete";
  static String yes = "Yes";
  static String no = "No";
  static String close = "Close";
  static String done = "Done";
  static String checkout = "Check out";
  static String pay = "Pay";
}

class ErrorMessage {
  static String error = "Error";
  static String somethingWentWrong =
      "Something went wrong, please try again later!";
  static String errorWhileLoading =
      "Error while loading, please try again later!";
  static String loginFailed = "Login failed, please try again!";
  static String imageNotFound = "Image not found";

  static String inputRequired({String? message}) =>
      "Action Failed! Please input all fields for $message";

  static String inputInvalid({String? message}) =>
      "Action Failed! Please input valid fields for $message";

  static String underDevelopment = "This feature is under development!";
}

class ImageName {
  static String imageName({String? prefix}) =>
      "${prefix ?? "image"}_${DateTime.now().millisecondsSinceEpoch}";
}

class StaticMessage {
  static String emptyList = "Empty List!";
  static String emptyBaiList =
      "Oops! Looks like there are no ‘Bai’ items in the list. Please add some!";
}

class ZaloPayMessage {
  static const String openApp = "Open ZaloPay";
  static const String cancelled = "Payment has been cancelled.";
  static const String success = "Payment was successful!";
  static const String failed = "Payment failed. Please try again.";
  static const String processing = "Payment is processing...";
}
