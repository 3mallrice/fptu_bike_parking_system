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

  static String formatVnPayDate(String? dateString) {
    if (dateString == null || dateString.length != 14) return 'N/A';
    try {
      final dateTime = DateTime(
        int.parse(dateString.substring(0, 4)), // Year
        int.parse(dateString.substring(4, 6)), // Month
        int.parse(dateString.substring(6, 8)), // Day
        int.parse(dateString.substring(8, 10)), // Hour
        int.parse(dateString.substring(10, 12)), // Minute
        int.parse(dateString.substring(12, 14)), // Second
      );
      return DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);
    } catch (e) {
      print('Error parsing date: $e');
      return 'N/A';
    }
  }

  // Function to format date
  static String formatDate(DateTime? date) {
    if (date == null) {
      return '';
    } else if (_isToday(date)) {
      return 'Today, ${formatDTS(date)}';
    } else if (_isYesterday(date)) {
      return 'Yesterday, ${formatDTS(date)}';
    } else {
      return formatDTS(date);
    }
  }

  // Function to format date and time seconds
  static String formatDTS(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(date);
  }

  // Function to format date and time
  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  // Function to format date
  static String formatDateOnly(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // Function to format date: August 12, 2021
  static String formatDateMMMddyyyy(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  // Function to format number
  // eg: 100000 -> 100.000
  static String formatMoney(int number) {
    return NumberFormat.decimalPattern('vi_VN').format(number);
  }

  // Function to format currency
  // eg: 100000 -> 100
  static String formatCurrency(int number) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: '')
        .format(number / 1000);
  }

  // Function to format plate number
  // eg: 4digit: 29A12345 -> 29A1 - 2345
  // eg: 5digit: 29A123456 -> 29A1 - 234.56
  // eg: 5digit electric: 29MĐ123456 -> 29MĐ1 - 234.56
  static String formatPlateNumber(String plateNumber) {
    switch (plateNumber.length) {
      case 8:
        return '${plateNumber.substring(0, 4)}-${plateNumber.substring(4)}';
      case 9:
        return '${plateNumber.substring(0, 4)}-${plateNumber.substring(4, 7)}.${plateNumber.substring(7)}';
      case 10:
        return '${plateNumber.substring(0, 5)}-${plateNumber.substring(5, 8)}.${plateNumber.substring(8)}';
      default:
        return plateNumber;
    }
  }
}
