import 'dart:async';

import 'package:bai_system/core/helper/local_storage_helper.dart';
import 'package:bai_system/firebase_options.dart';
import 'package:bai_system/representation/splash_screen.dart';
import 'package:bai_system/service/internet_connection_checker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:info_kit/info_kit.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';

import 'api/service/weather/geo.dart';
import 'core/theme/theme_provider.dart';
import 'route.dart';
import 'service/firebase_service.dart';

final navigatorKey = GlobalKey<NavigatorState>();
var log = Logger();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Khởi tạo Hive
    await Hive.initFlutter();
    await LocalStorageHelper.initLocalStorageHelper();

    // Khởi tạo Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    if (!kIsWeb) {
      await initLocalNotifications();
    }

    // Lấy token FCM
    await getFcmToken();

    await GeoPermission().getCurrentPosition();

    await InfoKit.init(
      envEnabled: false,
      envFlavorPerPlatformEnabled: false,
      envFlavorEnabled: false,
    );

    runApp(
      MultiProvider(
        providers: [
          Provider(
            create: (context) => InternetConnectionService(),
            dispose: (_, service) => service.dispose(),
          ),
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ],
        child: const MyApp(),
      ),
    );
  } catch (error, stack) {
    log.e('Initialization error', error: error, stackTrace: stack);
    log.d(stack);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPushNotification();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BAI',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const AspectRatio(
        aspectRatio: 16 / 9,
        child: SplashScreen(),
      ),
      routes: routes,
      navigatorKey: navigatorKey,
    );
  }
}
