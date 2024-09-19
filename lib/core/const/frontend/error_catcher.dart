class UserFriendErrMess {
  static String loginErrMessage(Object e) {
    if (e.toString().contains("network_error")) {
      return "No internet connection. Please check your network and try again.";
    } else if (e.toString().contains("Login failed: User data is null") ||
        e.toString().contains("Login failed: Google authentication failed")) {
      return "Login failed. Please try again.";
    } else {
      return "An unexpected error occurred. Please try again.";
    }
  }
}

class HttpErrorMapper {
  static String getErrorMessage(int statusCode, {String? serverMessage}) {
    return switch (statusCode) {
      400 =>
        "Bad Request: The server could not understand the request due to invalid syntax. Please check your input and try again.",
      401 =>
        "Unauthorized Access: Your credentials are either missing or incorrect. Please log in again and ensure you have the right permissions.",
      403 =>
        "Forbidden: You do not have the necessary rights to access this resource. If you believe this is an error, please contact your administrator for further assistance.",
      404 =>
        "Not Found: The resource you are looking for could not be found on the server. Please verify the URL and try again.",
      409 => switch (serverMessage) {
          "This Image not contain any plate number" =>
            "Conflict Detected: The provided image does not contain a recognizable plate number. Please upload a valid image and try again.",
          "Plate Number is exist in system" =>
            "Conflict Detected: The plate number you are trying to register already exists in the system. Please use a different plate number.",
          _ =>
            "A conflict occurred during the process. Please review the details and try again."
        },
      500 =>
        "Internal Server Error: Something went wrong on the server side. Please wait a few moments and try again later.",
      503 =>
        "Service Unavailable: The server is currently unable to handle the request due to maintenance or overload. Please try again after some time.",
      _ =>
        "An unknown error occurred. Status code: $statusCode. Please contact support if the problem persists.",
    };
  }
}
