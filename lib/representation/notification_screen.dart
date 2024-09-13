import 'package:bai_system/service/notification_service.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  static String routeName = '/notification_screen';

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    //final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    final notificationManager = NotificationManager();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 20,
              ),
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      body: Builder(
        builder: (context) {
          final notifications = notificationManager.getRecentNotifications();
          if (notifications.isEmpty) {
            return const Center(child: Text('No recent notifications'));
          }
          return ListView.separated(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return ListTile(
                title: Text(notification.title),
                subtitle: Text(notification.body),
                trailing: Text(
                  '${notification.timestamp.day}/${notification.timestamp.month}',
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(
                height: 0,
                thickness: 1,
                indent: 16.0,
                endIndent: 16.0,
              );
            },
          );
        },
      ),
    );
  }
}
