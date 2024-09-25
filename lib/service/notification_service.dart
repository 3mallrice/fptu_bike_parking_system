import 'dart:convert';

import 'package:bai_system/api/model/bai_model/notification_model.dart';
import 'package:bai_system/core/helper/local_storage_helper.dart';
import 'package:logger/logger.dart';

class NotificationManager {
  static const String _storageKey = LocalStorageKey.storageKey;
  final _currentEmail = LocalStorageHelper.getCurrentUserEmail() ?? '';
  final _log = Logger();

  // Save a new notification
  Future<void> saveNotification(Notification notification) async {
    try {
      List<String> notifications =
          LocalStorageHelper.getValue(_storageKey, _currentEmail) ?? [];
      final now = DateTime.now();

      // Remove notifications older than 7 days
      notifications = notifications.where((item) {
        final existingNotification = Notification.fromJson(jsonDecode(item));
        return now.difference(existingNotification.timestamp).inDays < 7;
      }).toList();

      notifications.add(jsonEncode(notification.toJson()));
      LocalStorageHelper.setValue(_storageKey, notifications, _currentEmail);
    } catch (e) {
      _log.e('Error saving notification: $e');
    }
  }

  // Get all notifications from the last 7 days and sort by timestamp
  List<Notification> getRecentNotifications() {
    try {
      List<String> notifications =
          LocalStorageHelper.getValue(_storageKey, _currentEmail) ?? [];
      final now = DateTime.now();

      // Filter notifications from the last 7 days
      List<Notification> recentNotifications = notifications
          .map((item) => Notification.fromJson(jsonDecode(item)))
          .where((notification) =>
              now.difference(notification.timestamp).inDays < 7)
          .toList();

      // Sort by timestamp in descending order (newest first)
      recentNotifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      return recentNotifications;
    } catch (e) {
      // Handle error
      _log.e('Error getting recent notifications: $e');
      return [];
    }
  }
}
