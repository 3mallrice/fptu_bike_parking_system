import 'dart:convert';

import 'package:bai_system/api/model/bai_model/notification_model.dart';
import 'package:bai_system/core/helper/local_storage_helper.dart';

class NotificationManager {
  static const String _storageKey = LocalStorageKey.storageKey;

  // Save a new notification
  Future<void> saveNotification(Notification notification) async {
    List<String> notifications = LocalStorageHelper.getValue(_storageKey) ?? [];
    notifications.add(jsonEncode(notification.toJson()));
    LocalStorageHelper.setValue(_storageKey, notifications);
    await _removeOldNotifications();
  }

  // Get all notifications from the last 7 days
  List<Notification> getRecentNotifications() {
    List<String> notifications = LocalStorageHelper.getValue(_storageKey) ?? [];
    final now = DateTime.now();
    return notifications
        .map((item) => Notification.fromJson(jsonDecode(item)))
        .where(
            (notification) => now.difference(notification.timestamp).inDays < 7)
        .toList();
  }

  // Remove notifications older than 7 days
  Future<void> _removeOldNotifications() async {
    List<String> notifications = LocalStorageHelper.getValue(_storageKey) ?? [];
    final now = DateTime.now();
    notifications = notifications.where((item) {
      final notification = Notification.fromJson(jsonDecode(item));
      return now.difference(notification.timestamp).inDays < 7;
    }).toList();
    LocalStorageHelper.setValue(_storageKey, notifications);
  }
}
