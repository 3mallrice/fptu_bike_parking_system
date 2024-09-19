import 'package:bai_system/component/app_bar_component.dart';
import 'package:bai_system/component/dialog.dart';
import 'package:bai_system/core/const/utilities/util_helper.dart';
import 'package:bai_system/core/helper/asset_helper.dart';
import 'package:bai_system/representation/navigation_bar.dart';
import 'package:bai_system/service/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../component/empty_box.dart';
import '../component/internet_connection_wrapper.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  static String routeName = '/notification_screen';

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _hasNotificationPermission = false;
  final notificationManager = NotificationManager();

  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
  }

  Future<void> _checkNotificationPermission() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission();

    setState(() {
      _hasNotificationPermission =
          settings.authorizationStatus == AuthorizationStatus.authorized;
    });
  }

  void _requestPermission() async {
    showDialog(
        context: context,
        builder: (context) {
          return ConfirmDialog(
            title: 'Enable Notification',
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Please enable notification in setting to receive notification!',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.asset(
                      AssetHelper.notiAndroid,
                      width: MediaQuery.of(context).size.width * 0.5,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.asset(
                      AssetHelper.notiIos,
                      width: MediaQuery.of(context).size.width * 0.5,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            positiveLabel: 'Open Setting',
            onConfirm: () {
              openAppSettings();
              Navigator.of(context)
                  .pushReplacementNamed(MyNavigationBar.routeName);
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return InternetConnectionWrapper(
      child: Scaffold(
        appBar: const MyAppBar(
          title: 'Notifications',
          automaticallyImplyLeading: true,
        ),
        body: Builder(
          builder: (context) {
            if (!_hasNotificationPermission) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.notifications_off,
                      size: 100,
                      color: Colors.grey,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    const Text(
                      'You have not granted notification permission.',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.outline,
                        splashFactory: InkRipple.splashFactory,
                        foregroundColor: Theme.of(context).colorScheme.outline,
                      ),
                      onPressed: () => _requestPermission(),
                      child: Text('Grant Permission',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.surface)),
                    ),
                  ],
                ),
              );
            }

            final notifications = notificationManager.getRecentNotifications();
            if (notifications.isEmpty) {
              return const EmptyBox(
                message: 'Oops! No notification found.',
              );
            }

            return RefreshIndicator(
              onRefresh: () async => setState(() {}),
              child: ListView.separated(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Card(
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05,
                        vertical: 5),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: Theme.of(context).colorScheme.surface,
                    surfaceTintColor: Theme.of(context).colorScheme.surface,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      title: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          Text(
                            UltilHelper.formatDateMMMddyyyy(
                                notification.timestamp),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                  fontSize: 10,
                                ),
                          ),
                        ],
                      ),
                      leading: Image.asset(
                        AssetHelper.imgLogo,
                        width: 30,
                        height: 30,
                        fit: BoxFit.contain,
                      ),
                      subtitle: Text(
                        notification.body,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 0);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
