import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/core/helper/local_storage_helper.dart';
import 'package:fptu_bike_parking_system/representation/splash_screen.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import 'core/theme/theme_provider.dart';
import 'firebase_options.dart';
import 'route.dart';

void main() async {
  //flutter init
  WidgetsFlutterBinding.ensureInitialized();

  //init Hive
  await Hive.initFlutter();
  await LocalStorageHelper.initLocalStorageHelper();

  //flutter init
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /*This should be used while in development mode, 
  do NOT do this when you want to release to production, 
  the aim of this answer is to make the development 
  a bit easier for you, 
  for production, you need to fix your certificate issue 
  and use it properly, look at the other answers for this 
  as it might be helpful for your case.
  */
  HttpOverrides.global = MyHttpOverrides();

  //light/dart theme
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BAI',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,

      home: const AspectRatio(
        aspectRatio: 1,
        //child: MyNavigationBar(),
        child: SplashScreen(),
      ),
      // initialRoute: HomeScreen.routeName,
      routes: routes,
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
