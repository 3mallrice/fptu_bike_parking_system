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
  static String getErrorMessage(int statusCode) {
    // Return user-friendly messages based on status code
    return switch (statusCode) {
      400 => "Bad request. Please try again.",
      401 => "Unauthorized. Please check your credentials.",
      403 => "Forbidden. You don't have permission.",
      404 => "Resource not found.",
      409 => "Conflict occurred. Please try again.",
      500 => "Internal server error. Please try again later.",
      503 => "Service unavailable. Please try again later.",
      _ => "An error occurred. Status code: $statusCode",
    };
  }
}
