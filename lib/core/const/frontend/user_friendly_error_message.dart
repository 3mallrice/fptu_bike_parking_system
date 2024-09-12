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
