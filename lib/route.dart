import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/representation/fundin_screen.dart';
import 'package:fptu_bike_parking_system/representation/navigation_bar.dart';
import 'package:fptu_bike_parking_system/representation/qr_code.dart';
import 'package:fptu_bike_parking_system/representation/wallet_screen.dart';

import 'representation/home.dart';
import 'representation/home_screen.dart';

final Map<String, WidgetBuilder> routes = {
  HomeScreen.routeName: (context) => const HomeScreen(), //fake
  HomeAppScreen.routeName: (context) => const HomeAppScreen(),
  MyNavigationBar.routeName: (context) => const MyNavigationBar(),
  QrCodeScreen.routeName: (context) => const QrCodeScreen(),
  FundinScreen.routeName: (context) => const FundinScreen(),
  MyWallet.routeName: (context) => const MyWallet(),
};
