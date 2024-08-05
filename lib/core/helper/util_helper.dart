import 'package:intl/intl.dart';

class UltilHelper {
  // Function to check if a date is today
  static bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Function to check if a date is yesterday
  static bool _isYesterday(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  // Function to format date
  static String formatDate(DateTime date) {
    if (_isToday(date)) {
      return 'Today';
    } else if (_isYesterday(date)) {
      return 'Yesterday';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  // Function to format date and time
  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(date);
  }

  // Function to format number
  // eg: 100000 -> 100.000
  static String formatNumber(int number) {
    return NumberFormat.decimalPattern('vi_VN').format(number);
  }
}
