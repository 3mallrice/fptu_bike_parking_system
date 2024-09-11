import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';

import '../../api/model/bai_model/notification_model.dart';
import '../../api/service/bai_be/notification_service.dart';
import '../../firebase_options.dart';
import 'local_storage_helper.dart';

var log = Logger();

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  initLocalNotifications();
  _showFlutterNotification(message);
  log.i('Handling a background message: ${message.messageId}');
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

late AndroidNotificationChannel androidChannel;
bool isInitialized = false;

// create a new instance of firebase messaging
final _firebaseMessaging = FirebaseMessaging.instance;

// function to initialize notification
Future<void> getFcmToken() async {
  // request permission from user (will prompt user)
  await requestPermission();

  // fetch the FCM token for this device
  final fCMToken = await _firebaseMessaging.getToken();
  if (fCMToken == null) {
    log.e('Failed to get FCM token');
    return;
  }
  //save token to local storage
  await LocalStorageHelper.setValue(LocalStorageKey.fcmToken, fCMToken);

  // print the token (normally you would send this to your server)
  log.i('fcmToken: $fCMToken');
}

// request permission
Future<void> requestPermission() async {
  var settings = await _firebaseMessaging.requestPermission(
    provisional: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    log.i('User granted permission');
  } else {
    log.e('User declined or has not accepted permission');
  }
}

// function to initialize local notifications
Future<void> initLocalNotifications() async {
  if (isInitialized) {
    return;
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('bai');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  androidChannel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    // description
    importance: Importance.high,
    showBadge: true,
    sound: RawResourceAndroidNotificationSound('notification'),
    enableLights: true,
  );

  // Tạo channel trên thiết bị
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidChannel);

  isInitialized = true;
}

// function to handle received messages
void _handleMessage(RemoteMessage? message) {
  // if the message is null, do nothing
  if (message == null) return;

  // // navigate to new screen when message is received and user taps notification
  // navigatorKey.currentState?.pushNamed(
  //   NotificationScreen.routeName,
  //   arguments: message,
  // );
}

// function to initialize background settings
void initPushNotification() async {
  // handle notification if the app was terminated and now opened
  FirebaseMessaging.instance.getInitialMessage().then(_handleMessage);

  // attach event listener for when notification opens the app
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

  // handle notification when the app is in the foreground
  FirebaseMessaging.onMessage.listen(_showFlutterNotification);
}

void _showFlutterNotification(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          androidChannel.id,
          androidChannel.name,
          channelDescription: androidChannel.description,
          icon: android.smallIcon,
          color: const Color(0xFFF37021),
        ),
      ),
    );
  }

  final notificationManager = NotificationManager();
  await notificationManager.saveNotification(Notification(
    id: message.messageId ?? DateTime.now().toIso8601String(),
    title: notification?.title ?? '',
    body: notification?.body ?? '',
    timestamp: DateTime.now(),
  ));
}
