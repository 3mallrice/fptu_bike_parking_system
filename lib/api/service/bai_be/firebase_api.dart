import 'dart:convert';
import 'dart:ui';

import 'package:bai_system/api/model/bai_model/api_response.dart';
import 'package:bai_system/api/model/bai_model/notification_model.dart';
import 'package:bai_system/api/service/bai_be/notification_service.dart';
import 'package:bai_system/core/helper/local_storage_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../../core/const/frontend/message.dart';
import 'api_root.dart';

var log = Logger();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log.d("Handling a background message: ${message.messageId}");

  // Save the notification
  final notificationManager = NotificationManager();
  await notificationManager.saveNotification(Notification(
    id: message.messageId ?? DateTime.now().toIso8601String(),
    title: message.notification?.title ?? '',
    body: message.notification?.body ?? '',
    timestamp: DateTime.now(),
  ));
}

class FirebaseApi {
  static const apiName = '/notifications';
  final String api = APIRoot.root + apiName;

  String token = "";
  var log = Logger();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late AndroidNotificationChannel channel;

  // create a new instance of firebase messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initialize notification
  Future<void> initNotifications() async {
    // request permission from user (will prompt user)
    await _firebaseMessaging.requestPermission();

    // fetch the FCM token for this device
    final fCMToken = await _firebaseMessaging.getToken();
    if (fCMToken == null) {
      log.e('Failed to get FCM token');
      return;
    }
    await sendTokenToServer(fCMToken);

    // print the token (normally you would send this to your server)
    log.i('fcmToken: $fCMToken');

    //initialize further settings for push notifications
    _initPushNotification();
    await _initBackgroundHandler();
    await _initLocalNotifications();
  }

  // function to initialize local notifications
  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/bai');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.',
      // description
      importance: Importance.high,
    );

    // Tạo channel trên thiết bị
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
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

  Future<void> _initBackgroundHandler() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

// function to initialize background settings
  void _initPushNotification() async {
    // handle notification if the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(_handleMessage);

    // attach event listener for when notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // handle notification when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
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
    },);
  }

  // send FCM token to server
  Future<APIResponse<dynamic>> sendTokenToServer(String fcmToken) async {
    try {
      token = GetLocalHelper.getBearerToken() ?? "";

      if (token == "") {
        log.e('Token is empty');
        return APIResponse(
          message: 'Token is empty',
          isTokenValid: false,
        );
      }

      final response = await http.put(
        Uri.parse('$api/customer/$fcmToken'),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        APIResponse<bool> apiResponse = APIResponse.fromJson(
          responseJson,
          (json) => true,
        );
        return apiResponse;
      } else {
        log.e('Failed to put customer fcm token: ${response.statusCode}');
        return APIResponse(
          message: '${ErrorMessage.somethingWentWrong}: ${response.statusCode}',
        );
      }
    } catch (e) {
      log.e('Error during put customer fcm token: $e');
      return APIResponse(
        message: 'Error during put customer fcm token',
      );
    }
  }
}
