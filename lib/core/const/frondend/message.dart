class Message {
  static String saveImageSuccessfully = "Image saved successfully";
  static String saveImageUnSuccessfully = "Saved unsuccessfully";
  static String permissionDeny = "Permission denied";
}

class LabelMessage {
  static String ok = "OK";
  static String save = "Save";
  static String cancel = "Cancel";
  static String confirm = "Confirm";
  static String delete = "Delete";
  static String yes = "Yes";
  static String no = "No";
  static String close = "Close";
  static String done = "Done";
  static String checkout = "Check out";
}

class ErrorMessage {
  static String error = "Error";
  static String somethingWentWrong =
      "Something went wrong, please try again later!";
  static String errorWhileLoading =
      "Error while loading, please try again later!";
}

class ImageName {
  static String imageName({String? prefix}) =>
      "${prefix ?? "image"}_${DateTime.now().millisecondsSinceEpoch}";
}
